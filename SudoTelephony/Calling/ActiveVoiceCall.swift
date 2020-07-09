//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CallKit

/// Delegate for receiving notifications about new `ActiveVoiceCall` events.
///
/// - Note: `ActiveCallDelegate` methods are called on the main thread.
public protocol ActiveCallDelegate {

    /// Notifies the delegate that the call has connected
    /// - Parameters:
    ///     - call: The `ActiveVoiceCall`
    func activeVoiceCallDidConnect(_ call: ActiveVoiceCall)

    /// Notifies the delegate that the call failed to connect
    /// - Parameters:
    ///     - error: `CallingError` that occurred.
    func activeVoiceCallDidFailToConnect(withError error: CallingError)

    /// Notifies the delegate that the call has been disconnected
    /// - Parameters:
    ///     - call: The `ActiveVoiceCall`
    ///     - error: Error that caused the call to disconnect if one occurred.
    func activeVoiceCall(_ call: ActiveVoiceCall, didDisconnectWithError error: Error?)

    /// Notifies the delegate that the call has been disconnected
    /// - Parameters:
    ///     - call: The `ActiveVoiceCall`
    ///     - isMuted: Whether outgoing call audio is muted
    func activeVoiceCall(_ call: ActiveVoiceCall, didChangeMuteState isMuted: Bool)
}

// TODO: This will eventually be the GraphQL response type from `createVoiceCall`.
typealias CallRecord = (accessToken: String, localPhoneNumber: String, remotePhoneNumber: String)

/// Enables controlling an active voice call and displaying its properties.
public class ActiveVoiceCall {
    /// The E164-formatted local phone number participating in this voice call.
    public let localPhoneNumber: String
    /// The E164-formatted remote phone number participating in this voice call.
    public let remotePhoneNumber: String

    internal let callId: UUID
    internal let callKitController: CXCallController

    internal let setAudioRouteToSpeakerBlock: ((_ toSpeaker: Bool) -> Void)

    public internal(set) var isMuted: Bool = false

    internal init(
        localNumber: String,
        remoteNumber: String,
        callId: UUID,
        callKitController: CXCallController,
        setAudioRouteToSpeakerBlock: @escaping ((Bool) -> Void)
    ) {
        self.localPhoneNumber = localNumber
        self.remotePhoneNumber = remoteNumber

        self.callId = callId
        self.callKitController = callKitController
        self.setAudioRouteToSpeakerBlock = setAudioRouteToSpeakerBlock
    }

    /// Disconnects the active call. If successful, callbacks added via `subscribe(onDisconnection:)` will be triggered.
    public func disconnect(completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        callKitController.requestTransaction(with: CXEndCallAction(call: callId)) { error in
            completion(error.map(Swift.Result.failure) ?? Swift.Result.success(()))
        }
    }

    /// Sets whether outgoing call audio should be muted.
    /// - Parameter speaker: If true, outgoing call audio should be muted.
    public func setMuted(_ muted: Bool) {
        let muteAction = CXSetMutedCallAction(call: callId, muted: muted)
        callKitController.requestTransaction(with: muteAction) { error in }
    }


    /// Sets whether call audio should be routed through the speakers.
    /// - Parameter toSpeaker: If true, audio should be routed through the speakers.
    public func setAudioOutput(toSpeaker: Bool) {
        setAudioRouteToSpeakerBlock(toSpeaker)
    }
}
