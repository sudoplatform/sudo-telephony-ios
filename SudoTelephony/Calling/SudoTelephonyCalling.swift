//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import AWSAppSync
import CallKit
import Foundation
import SudoLogging
import SudoUser
import TwilioVoice

/// Calling feature
class SudoTelephonyCalling: NSObject {

    /// Tracked call state.
    enum TrackedCall {
        case authorized(
            callRecord: CallRecord,
            vendor: CallingVendorCall.Type,
            callDelegate: ActiveCallDelegate
        )
        case incoming(call: IncomingCall, pushHandler: PushHandler)
        case connecting(vendorCall: CallingVendorCall, userCallController: ActiveVoiceCall, callDelegate: ActiveCallDelegate)
        case connected(vendorCall: CallingVendorCall, userCallController: ActiveVoiceCall, callDelegate: ActiveCallDelegate)
    }

    /// GraphQL client for communicating with the Sudo  service.
    private let graphQLClient: AWSAppSyncClient

    /// Queue for processing API result.
    private let apiResultQueue: DispatchQueue

    /// CallKit action controller.
    private let callKitController = CXCallController()

    /// CallKit notification reporter.
    private let callKitProvider: CXProvider

    /// Call state tracking.
    private var calls: [UUID: TrackedCall] = [:]

    /// Audio device, used primarily to route audio to speakerphone.
    private let audioDevice = TVODefaultAudioDevice()

    private let logger: Logger

    /// User client to check/subscribe to sign in status so push tokens can be updated correctly.
    private let sudoUserClient: SudoUserClient

    /// To manage register/de-registering push tokens with our calling vendors.
    let pushTokenManager: PushTokenManagement

    /// Instantiates the calling feature.
    init(
        graphQLClient: AWSAppSyncClient,
        apiResultQueue: DispatchQueue,
        sudoUserClient: SudoUserClient,
        callProviderConfiguration: CallProviderConfiguration,
        logger: Logger
    ) {
        self.graphQLClient = graphQLClient
        self.apiResultQueue = apiResultQueue

        callKitProvider = CXProvider(configuration: {
            let configuration = callProviderConfiguration.cxProviderConfiguration()
            configuration.maximumCallGroups = 1
            configuration.maximumCallsPerCallGroup = 1
            configuration.supportsVideo = false
            configuration.supportedHandleTypes = [.phoneNumber]
            return configuration
        }())

        self.logger = logger

        self.sudoUserClient = sudoUserClient

        self.pushTokenManager = PushTokenManagement(graphQLClient: graphQLClient, apiResultQueue: apiResultQueue, sudoUserClient: sudoUserClient, logger: logger)

        super.init()

        callKitProvider.setDelegate(self, queue: nil)
        TwilioVoice.audioDevice = audioDevice
    }

    /// Cleans up initialized resources.
    deinit {
        callKitProvider.invalidate()
    }

    /// - SeeAlso: `SudoTelephonyClient.createVoiceCall`
    func createVoiceCall(localNumber: PhoneNumber, remoteNumber: String, delegate: ActiveCallDelegate) throws {
        logger.info("Creating outgoing call")
        self.checkMicrophonePermission { (hasMicrophonePermission) in

            // Check for microphone persmission before doing anything required for a call.
            guard hasMicrophonePermission == true else {
                self.logger.error("Create call failed, missing record permission")
                DispatchQueue.main.async {
                    delegate.activeVoiceCallDidFailToConnect(withError: .recordPermissionNotGranted)
                }
                return
            }

            let input = CreateVoiceCallInput(from: localNumber.phoneNumber, to: remoteNumber)
            let mutation = CreateVoiceCallMutation(input: input)

            self.logger.info("Fetching access token for outgoing call")

            self.graphQLClient.perform(
                mutation: mutation,
                queue: self.apiResultQueue,
                optimisticUpdate: nil,
                conflictResolutionBlock: nil
            ) { (result, error) in
                let containerError = result?.errors?.first
                guard error == nil, containerError == nil else {
                    let clientError = SudoTelephonyClientError(serviceError: error ?? containerError)
                    DispatchQueue.main.async {
                        delegate.activeVoiceCallDidFailToConnect(withError: .failedToAuthorizeOutgoingCall(clientError))
                    }
                    return
                }

                guard let result = result?.data?.createVoiceCall else {
                    DispatchQueue.main.async {
                        delegate.activeVoiceCallDidFailToConnect(withError: .failedToAuthorizeOutgoingCall(nil))
                    }
                    return
                }

                self.logger.info("Successfully fetched access token for outgoing call")

                // Determine which vendor to use for the call.
                // TODO: determine vendor from property on mutation response or maybe from localNumber
                let vendor = TwilioVendorCall.self

                // Track call state.
                let callId = UUID()
                self.calls[callId] = TrackedCall.authorized(
                    callRecord: ( // TODO: The raw `result` will eventually be a call record.
                        accessToken: result.vendorAuthorization.accessToken,
                        localPhoneNumber: localNumber.phoneNumber,
                        remotePhoneNumber: remoteNumber
                    ),
                    vendor: vendor,
                    callDelegate: delegate
                )

                // Request CallKit call. The CXProviderDelegate implementation takes over from here.

                // TODO: Ask the user to pass in the display name as part of the incoing call so we know
                // what to report to callKit.
                let callHandle = CXHandle(displayName: nil, remoteNumber: remoteNumber)
                let startCallAction = CXStartCallAction(call: callId, handle: callHandle)
                let transaction = CXTransaction(action: startCallAction)

                self.callKitController.request(transaction) { error in
                    guard error == nil else {
                        return
                    }

                    let callUpdate = self.createCallUpdate(vendor: vendor)
                    callUpdate.remoteHandle = callHandle
                    self.callKitProvider.reportCall(with: callId, updated: callUpdate)
                }
            }
        }
    }

    func checkMicrophonePermission(completion: @escaping (_ granted: Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                completion(granted)
            }
        @unknown default:
            completion(false)
        }
    }

    // This function exists here because when making and receiving a call we want to toggle the audio route back to the normal speaker.
    // We also pass this function to the active call so in-progress call objects can change the audio route.
    private func setAudioOutput(toSpeaker: Bool) {
        self.audioDevice.block = {
            kTVODefaultAVAudioSessionConfigurationBlock()

            do {
                if toSpeaker {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                } else {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
                }
            } catch {
                self.logger.error(error.localizedDescription)
            }
        }
        self.audioDevice.block()
    }
}

extension SudoTelephonyCalling: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        logger.info("providerDidReset")
        audioDevice.isEnabled = true
    }

    func providerDidBegin(_ provider: CXProvider) {
        logger.info("providerDidBegin")
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        logger.info("provider:startCallAction")
        let callId = action.callUUID
        provider.reportOutgoingCall(with: callId, startedConnectingAt: Date())

        audioDevice.isEnabled = false
        audioDevice.block()

        guard
            let trackedCall = calls[callId],
            case .authorized(let callRecord, let vendor, let callDelegate) = trackedCall
        else {
            calls.removeValue(forKey: callId)
            action.fail()
            return
        }

        // Reset the audio route to use the normal speaker
        self.setAudioOutput(toSpeaker: false)

        let vendorCall = vendor.init(uuid: callId, callRecord: callRecord, connected: { callUUID in
            provider.reportOutgoingCall(with: callUUID, connectedAt: Date())
            action.fulfill()

            // Update the call status.
            if case .connecting(let vendorCall, let activeCall, let delegate) = self.calls[callId] {
                self.calls[callId] = TrackedCall.connected(
                    vendorCall: vendorCall,
                    userCallController: activeCall,
                    callDelegate: delegate
                )

                callDelegate.activeVoiceCallDidConnect(activeCall)
            } else {
                assertionFailure("Expected call to be in `connecting` state upon connection")
            }
        }, connectionFailed: { (callUUID, error) in
            action.fail()

            let endCallAction = CXEndCallAction(call: callUUID)
            let transaction = CXTransaction(action: endCallAction)
            self.callKitController.request(transaction) { endCallError in
                // best-effort; ignore endCallError
                callDelegate.activeVoiceCallDidFailToConnect(withError: .startCallActionFailed(error))
            }
        }, disconnected: { (callUUID, maybeError) in
            let reason: CXCallEndedReason = maybeError.map { _ in .failed } ?? .remoteEnded
            provider.reportCall(with: callUUID, endedAt: Date(), reason: reason)

            let trackedCall = self.calls.removeValue(forKey: callId)
            if case .connected(_, let userCall, let callDelegate) = trackedCall {
                callDelegate.activeVoiceCall(userCall, didDisconnectWithError: maybeError)
            }
        })

        // Return an object that allows the user to control the active call.
        let activeCall = ActiveVoiceCall(
            localNumber: callRecord.localPhoneNumber,
            remoteNumber: callRecord.remotePhoneNumber,
            callId: callId,
            callKitController: self.callKitController,
            setAudioRouteToSpeakerBlock: self.setAudioOutput
        )

        calls[callId] = TrackedCall.connecting(vendorCall: vendorCall, userCallController: activeCall, callDelegate: callDelegate)
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        logger.info("provider:answerCallAction")

        guard case .incoming(let incomingCall, _) = self.calls[action.callUUID] else {
            return
        }

        guard let delegate = incomingCall.delegate else {
            return
        }

        incomingCall.accept(with: delegate)

        action.fulfill(withDateConnected: Date())
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        logger.info("provider:endCallAction")
        switch calls[action.callUUID] {
        case .connecting(let vendorCall, _, _), .connected(let vendorCall, _, _):
            vendorCall.disconnect()
            action.fulfill()
        case .authorized, .none:
            action.fail()
        case .incoming(let incomingCall, _):
            incomingCall.decline()
            action.fulfill()
            break
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        logger.info("provider:setHeldCallAction")
        switch calls[action.callUUID] {
        case .connecting(let vendorCall, _, _), .connected(let vendorCall, _, _):
            vendorCall.isOnHold = action.isOnHold
            action.fulfill()
        case .authorized, .incoming, .none:
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        logger.info("provider:setMutedCallAction")
        switch calls[action.callUUID] {
        case .connected(let vendorCall, let userCall, let callDelegate):
            vendorCall.isMuted = action.isMuted
            userCall.isMuted = vendorCall.isMuted
            callDelegate.activeVoiceCall(userCall, didChangeMuteState: vendorCall.isMuted)
            action.fulfill()
        case .connecting, .authorized, .incoming, .none:
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        assertionFailure("Should not be called since `supportsGrouping` = false")
        action.fail()
    }

    func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        logger.info("provider:playDTMFCallAction")
        switch calls[action.callUUID] {
        case .connected(let vendorCall, _, _):
            vendorCall.playDTMF(action.digits)
            action.fulfill()
        case .connecting, .authorized, .incoming, .none:
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        logger.warning("provider:timedOutPerformingAction: \(action)")
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        logger.info("provider:didActivateAudioSession")
        audioDevice.isEnabled = true
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        logger.info("provider:didDeactivateAudioSession")
    }
}

extension SudoTelephonyCalling {

    func registerForIncomingCalls(with token: Data, useSandbox: Bool, completion: ((SudoTelephonyClientError?) -> Void)?) {
        self.pushTokenManager.registerForIncomingCalls(with: token, useSandbox: useSandbox, completion: completion)
    }

    func deregisterForIncomingCalls(completion: ((SudoTelephonyClientError?) -> Void)?) {
        self.pushTokenManager.deregisterForIncomingCalls(completion: completion)
    }

    func handleIncomingPushNotificationPayload(_ payload: [AnyHashable : Any], notificationDelegate: IncomingCallNotificationDelegate) -> Bool {
        self.logger.info("didReceiveIncomingVoipPushWithPayload")

        let vendorPushHandlerType = TwilioPushHandler.self
        let vendorCallType = TwilioVendorCall.self

        // Use a push handler to handle the incoming push payload.  All the relevant callbacks and event handling for the incoming call are handled here.
        // Events from CallKit (e.g. answer call, decline call) are passed through the `IncomingCall` and handled here.
        let pushHandler = vendorPushHandlerType.init(
            incomingCallAnswered: { (vendorCall, activeCallDelegate) in
                self.logger.info("Incoming call answered: \(vendorCall)")
                let activeCall = ActiveVoiceCall(
                    localNumber: vendorCall.localNumber,
                    remoteNumber: vendorCall.remoteNumber,
                    callId: vendorCall.uuid,
                    callKitController: self.callKitController,
                    setAudioRouteToSpeakerBlock: self.setAudioOutput
                )

                self.calls[vendorCall.uuid] = TrackedCall.connecting(vendorCall: vendorCall, userCallController: activeCall, callDelegate: activeCallDelegate)
                self.setAudioOutput(toSpeaker: false)

                DispatchQueue.main.async {
                    notificationDelegate.incomingCallAnswered(activeCall)
                }
        },
            incomingCallDeclined: { (incomingCall) in
                self.calls.removeValue(forKey: incomingCall.uuid)
                DispatchQueue.main.async {
                    notificationDelegate.incomingCall(incomingCall, cancelledWithError: nil)
                }
        },
            incomingCallCanceled: { (canceledIncomingCall, maybeError) in
                self.logger.error("incoingCallCanceled: \(canceledIncomingCall)")
                self.calls.removeValue(forKey: canceledIncomingCall.uuid)
                let endCallAction = CXEndCallAction(call: canceledIncomingCall.uuid)
                let transaction = CXTransaction(action: endCallAction)
                self.callKitController.request(transaction) { endCallError in
                    // Best effort, ignore the end call error
                    DispatchQueue.main.async {
                        notificationDelegate.incomingCall(canceledIncomingCall, cancelledWithError: maybeError)
                    }
                }
        },
            updateCallKitDisplayName: { (uuid, newName) in
                guard case .incoming(let call, _) = self.calls[uuid] else {
                    self.logger.error("Attempted to update display name for incoming call \(uuid), but no record found")
                    return
                }

                let update = self.createCallUpdate(vendor: vendorCallType)
                update.remoteHandle = CXHandle(displayName: newName, remoteNumber: call.remoteNumber)
                self.callKitProvider.reportCall(with: uuid, updated: update)
        },
            callConnected: { (uuid) in
                self.logger.info("Incoming Call Connected with UUID: \(uuid)")

                // look up the incoming call, notify callkit and the appropriate delegates
                guard case .connecting(let vendorCall, let activeCall, let callDelegate) = self.calls[uuid] else {
                    return
                }

                self.calls[uuid] = TrackedCall.connected(vendorCall: vendorCall, userCallController: activeCall, callDelegate: callDelegate)
                DispatchQueue.main.async {
                    callDelegate.activeVoiceCallDidConnect(activeCall)
                }
        },
            callConnectionFailed: { (uuid, error) in
                self.logger.error("Call connection failed: \(uuid)")

                // look up the incoming call, notify callkit and the appropriate delegates
                let trackedCall = self.calls.removeValue(forKey: uuid)

                if case .connecting(_, _, let callDelegate) = trackedCall {
                    let endCallAction = CXEndCallAction(call: uuid)
                    let transaction = CXTransaction(action: endCallAction)
                    self.callKitController.request(transaction) { endCallError in
                        // best-effort ignore endCallError
                        DispatchQueue.main.async {
                            callDelegate.activeVoiceCallDidFailToConnect(withError: .startCallActionFailed(error))
                        }
                    }
                }
        },
            callDisconnected: { (uuid, maybeError) in
                if let error = maybeError {
                    self.logger.error("Call disconnected with error: \(error)")
                }
                else {
                    self.logger.info("Call disconnected: \(uuid)")
                }

                // look up the incoming call, notify callkit and the appropriate delegates
                let reason: CXCallEndedReason = maybeError.map { _ in .failed } ?? .remoteEnded
                self.callKitProvider.reportCall(with: uuid, endedAt: Date(), reason: reason)

                let trackedCall = self.calls.removeValue(forKey: uuid)

                if case .connected(_, let userCall, let callDelegate) = trackedCall {
                    DispatchQueue.main.async {
                        callDelegate.activeVoiceCall(userCall, didDisconnectWithError: maybeError)
                    }
                }
        })

        // Give the push handler a logger to log any important failures.
        pushHandler.logger = self.logger

        // Handle the push
        let handled = pushHandler.handlePush(payload: payload)

        // If the push payload was converted to an incoming call by our push handler, notify the delegate, callkit, and save the incoming call.
        if handled, let incomingCall = pushHandler.incomingCall {
            // report the incoming call to the user.  This allows them to set the notification delegate and the call kit display name
            // before we report the call to CallKit
            notificationDelegate.incomingCallReceived(incomingCall)

            // save this incoming call along with the push handler.
            self.calls[incomingCall.uuid] = .incoming(call: incomingCall, pushHandler: pushHandler)

            // handle the incoming call - report to call kit etc.
            self.reportIncoming(call: incomingCall, vendor: vendorCallType)

            return true
        }
        else {
            return false
        }
    }

    func reportIncoming(call: IncomingCall, vendor: CallingVendorCall.Type) {
        let callUpdate = self.createCallUpdate(vendor: vendor)
        callUpdate.remoteHandle = CXHandle(displayName: call.displayName, remoteNumber: call.remoteNumber)
        callKitProvider.reportNewIncomingCall(with: call.uuid, update: callUpdate) { error in
            if let error = error {
                self.logger.error("Failed to report incoming call successfully: \(error.localizedDescription).")
            } else {
                self.logger.info("Incoming call successfully reported.")
            }
        }
    }

    private func createCallUpdate(vendor: CallingVendorCall.Type) -> CXCallUpdate {
        let update = CXCallUpdate()
        update.supportsDTMF = vendor.supportsDTMF
        update.supportsHolding = vendor.supportsHolding
        update.supportsGrouping = vendor.supportsGrouping
        update.supportsUngrouping = vendor.supportsUngrouping
        update.hasVideo = false
        return update
    }
}

extension CXHandle {
    convenience init(displayName: CallKitDisplayName?, remoteNumber: String) {
        if let displayName = displayName {
            // Address the CallKit "feature" where iOS will ignore our display name if it's able to resolve the incoming phone number itself.  In this case
            // pass a generic handle to avoid the lookup.
            let type: CXHandle.HandleType = displayName.ignoreSystemContacts ? .generic : .phoneNumber
            self.init(type: type, value: displayName.value)
        }
        else {
            self.init(type: .phoneNumber, value: remoteNumber)
        }
    }
}
