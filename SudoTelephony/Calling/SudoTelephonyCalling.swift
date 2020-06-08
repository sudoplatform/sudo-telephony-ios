//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import CallKit
import TwilioVoice
import SudoLogging

/// Calling feature
class SudoTelephonyCalling: NSObject {

    /// Tracked call state.
    enum TrackedCall {
        case authorized(
            callRecord: CallRecord,
            vendor: CallingVendorCall.Type,
            callDelegate: ActiveCallDelegate
        )
        case connecting(vendorCall: CallingVendorCall)
        case connected(
            vendorCall: CallingVendorCall,
            userCallController: ActiveVoiceCall,
            callDelegate: ActiveCallDelegate
        )
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

    private let logger: Logger?

    /// Instantiates the calling feature.
    init(
        graphQLClient: AWSAppSyncClient,
        apiResultQueue: DispatchQueue,
        callProviderConfiguration: CallProviderConfiguration,
        logger: Logger?
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
        logger?.info("Creating outgoing call")
        self.checkMicrophonePermission { (hasMicrophonePermission) in

            // Check for microphone persmission before doing anything required for a call.
            guard hasMicrophonePermission == true else {
                self.logger?.error("Create call failed, missing record permission")
                delegate.activeVoiceCallDidFailToConnect(withError: .recordPermissionNotGranted)
                return
            }

            let input = CreateVoiceCallInput(from: localNumber.phoneNumber, to: remoteNumber)
            let mutation = CreateVoiceCallMutation(input: input)

            self.logger?.info("Fetching access token for outgoing call")

            self.graphQLClient.perform(
                mutation: mutation,
                queue: self.apiResultQueue,
                optimisticUpdate: nil,
                conflictResolutionBlock: nil
            ) { (result, error) in
                let containerError = result?.errors?.first
                guard error == nil, containerError == nil else {
                    let clientError = SudoTelephonyClientError(serviceError: error ?? containerError)
                    delegate.activeVoiceCallDidFailToConnect(withError: .failedToAuthorizeOutgoingCall(clientError))
                    return
                }

                guard let result = result?.data?.createVoiceCall else {
                    delegate.activeVoiceCallDidFailToConnect(withError: .failedToAuthorizeOutgoingCall(nil))
                    return
                }

                self.logger?.info("Successfully fetched access token for outgoing call")

                // Determine which vendor to use for the call.
                // TODO: determine vendor from property on mutation response or maybe from localNumber
                let vendor = TwilioVendorCall.self

                // Track call state.
                let callId = UUID()
                self.calls[callId] = TrackedCall.authorized(
                    callRecord: ( // TODO: The raw `result` will eventually be a call record.
                        accessToken: result.token,
                        localPhoneNumber: localNumber.phoneNumber,
                        remotePhoneNumber: remoteNumber
                    ),
                    vendor: vendor,
                    callDelegate: delegate
                )

                // Request CallKit call. The CXProviderDelegate implementation takes over from here.
                let callHandle = CXHandle(type: .phoneNumber, value: remoteNumber)
                let startCallAction = CXStartCallAction(call: callId, handle: callHandle)
                let transaction = CXTransaction(action: startCallAction)

                self.callKitController.request(transaction) { error in
                    guard error == nil else {
                        return
                    }

                    let callUpdate = CXCallUpdate()
                    callUpdate.remoteHandle = callHandle
                    callUpdate.supportsDTMF = vendor.supportsDTMF
                    callUpdate.supportsHolding = vendor.supportsHolding
                    callUpdate.supportsGrouping = vendor.supportsGrouping
                    callUpdate.supportsUngrouping = vendor.supportsUngrouping
                    callUpdate.hasVideo = false
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
                self.logger?.error(error.localizedDescription)
            }
        }
        self.audioDevice.block()
    }
}

extension SudoTelephonyCalling: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        logger?.info("providerDidReset")
        audioDevice.isEnabled = true
    }

    func providerDidBegin(_ provider: CXProvider) {
        logger?.info("providerDidBegin")
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        logger?.info("provider:startCallAction")
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

        let vendorCall = vendor.init(action: action, callRecord: callRecord, connected: {
            provider.reportOutgoingCall(with: callId, connectedAt: Date())
            action.fulfill()

            // Return an object that allows the user to control the active call.
            let activeCall = ActiveVoiceCall(
                callRecord: callRecord,
                callId: callId,
                callKitController: self.callKitController,
                setAudioRouteToSpeakerBlock: self.setAudioOutput
            )

            // Update the call status.
            if case .connecting(let vendorCall) = self.calls[callId] {
                self.calls[callId] = TrackedCall.connected(
                    vendorCall: vendorCall,
                    userCallController: activeCall,
                    callDelegate: callDelegate
                )
            } else {
                assertionFailure("Expected call to be in `connecting` state upon connection")
            }
            callDelegate.activeVoiceCallDidConnect(activeCall)
        }, connectionFailed: { error in
            action.fail()

            let endCallAction = CXEndCallAction(call: callId)
            let transaction = CXTransaction(action: endCallAction)
            self.callKitController.request(transaction) { endCallError in
                // best-effort; ignore endCallError
                callDelegate.activeVoiceCallDidFailToConnect(withError: .startCallActionFailed(error))
            }
        }, disconnected: { maybeError in
            let reason: CXCallEndedReason = maybeError.map { _ in .failed } ?? .remoteEnded
            provider.reportCall(with: callId, endedAt: Date(), reason: reason)

            let trackedCall = self.calls.removeValue(forKey: callId)
            if case .connected(_, let userCall, let callDelegate) = trackedCall {
                callDelegate.activeVoiceCall(userCall, didDisconnectWithError: maybeError)
            }
        })

        calls[callId] = TrackedCall.connecting(vendorCall: vendorCall)
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        logger?.info("provider:answerCallAction")
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        logger?.info("provider:endCallAction")
        switch calls[action.callUUID] {
        case .connecting(let vendorCall), .connected(let vendorCall, _, _):
            vendorCall.disconnect()
            action.fulfill()
        case .authorized, .none:
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        logger?.info("provider:setHeldCallAction")
        switch calls[action.callUUID] {
        case .connecting(let vendorCall), .connected(let vendorCall, _, _):
            vendorCall.isOnHold = action.isOnHold
            action.fulfill()
        case .authorized, .none:
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        logger?.info("provider:setMutedCallAction")
        switch calls[action.callUUID] {
        case .connected(let vendorCall, let userCall, let callDelegate):
            vendorCall.isMuted = action.isMuted
            userCall.isMuted = vendorCall.isMuted
            callDelegate.activeVoiceCall(userCall, didChangeMuteState: vendorCall.isMuted)
            action.fulfill()
        case .connecting, .authorized, .none:
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        assertionFailure("Should not be called since `supportsGrouping` = false")
        action.fail()
    }

    func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        logger?.info("provider:playDTMFCallAction")
        switch calls[action.callUUID] {
        case .connected(let vendorCall, _, _):
            vendorCall.playDTMF(action.digits)
            action.fulfill()
        case .connecting, .authorized, .none:
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        logger?.warning("provider:timedOutPerformingAction: \(action)")
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        logger?.info("provider:didActivateAudioSession")
        audioDevice.isEnabled = true
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        logger?.info("provider:didDeactivateAudioSession")
    }
}
