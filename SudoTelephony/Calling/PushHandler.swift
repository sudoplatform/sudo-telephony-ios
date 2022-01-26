//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import TwilioVoice
import SudoLogging

// Push handler is a bridge for us between the push notification payload, the call provider (Twilio), and the sdk user.
// It receives a push payload and attempts to handle it.
//
// It lets us know about some events, e.g the push payload was turned into a call invite, or if the call was canceled.
// When this happens we notify the user of the new incoming call, or if the call was canceled.  We also notify callkit of these events.
// When we let the user know about the incoming call we give them the ability to set the display name and the delegate for the call related
// events (active call delegate).  If the call is answered we know where to send events.
//
// When we need to get info back from the SDK user, e.g. decline call or answer call, the push handler will also tell us about these events.
// When a call is answered, The IncomingCall will tell the push handler about the event.

// The push handler has access to the underlying types, e.g. CallInvite (the Twilio call will have it and could pass it back if need be).
// That makes it the appropriate place to create the `VendorCall`.  Of course `VendorCall` has some closures that need to be passed in, so we'll pass
// those into the push handler.  That way when a call is answered the push handler has the closures and data needed to init a `VendorCall`.
// The push handler will then notify us that the call was answered so we can report it to callKit.

protocol PushHandler {
    init(
        incomingCallAnswered: @escaping (CallingVendorCall, ActiveCallDelegate) -> Void,
        incomingCallDeclined: @escaping (IncomingCall) -> Void,
        incomingCallCanceled: @escaping (_ canceledCall: IncomingCall, _ error: Error?) -> Void,
        updateCallKitDisplayName: @escaping (_ uuid: UUID, _ name: CallKitDisplayName) -> Void,
        callConnected: @escaping (UUID) -> Void,
        callConnectionFailed: @escaping (UUID, Error) -> Void,
        callDisconnected: @escaping (UUID, Error?) -> Void
    )

    /// Ask the handler to handle the push payload
    /// - Returns: true if the push was able to be handled.
    func handlePush(payload: [AnyHashable: Any]) -> Bool

    var incomingCall: IncomingCall? { get }
}

class TwilioPushHandler: NSObject, PushHandler, NotificationDelegate {

    internal private(set) var incomingCall: IncomingCall?

    var callInvite: CallInvite?

    var logger: Logger?

    let incomingCallAnswered: (CallingVendorCall, ActiveCallDelegate) -> Void
    let incomingCallDeclined: (IncomingCall) -> Void
    let incomingCallCanceled: (_ canceledCall: IncomingCall, _ error: Error?) -> Void
    let callConnected: (UUID) -> Void
    let callConnectionFailed: (UUID, Error) -> Void
    let callDisconnected: (UUID, Error?) -> Void
    let updateCallKitDisplayName: (_ uuid: UUID, _ name: CallKitDisplayName) -> Void

    required init(
        incomingCallAnswered: @escaping (CallingVendorCall, ActiveCallDelegate) -> Void,
        incomingCallDeclined: @escaping (IncomingCall) -> Void,
        incomingCallCanceled: @escaping (IncomingCall, Error?) -> Void,
        updateCallKitDisplayName: @escaping (_ uuid: UUID, _ name: CallKitDisplayName) -> Void,
        callConnected: @escaping (UUID) -> Void,
        callConnectionFailed: @escaping (UUID, Error) -> Void,
        callDisconnected: @escaping (UUID, Error?) -> Void
    ) {
        self.incomingCallAnswered = incomingCallAnswered
        self.incomingCallDeclined = incomingCallDeclined
        self.incomingCallCanceled = incomingCallCanceled
        self.updateCallKitDisplayName = updateCallKitDisplayName
        self.callConnected = callConnected
        self.callConnectionFailed = callConnectionFailed
        self.callDisconnected = callDisconnected
    }

    func handlePush(payload: [AnyHashable : Any]) -> Bool {
        let pushHandled = TwilioVoiceSDK.handleNotification(payload,
                                          delegate: self,
                                          delegateQueue: nil
        )
        return pushHandled
    }

    func callInviteReceived(callInvite: CallInvite) {
        self.callInvite = callInvite
        let twilioIncomingCall = TwilioIncomingCall(invite: callInvite)

        // To avoid having to deal with optional self, capture the closures locally.
        let callConnected = self.callConnected
        let callConnectionFailed = self.callConnectionFailed
        let callDisconnected = self.callDisconnected

        // Capture self weakly in these blocks to avoid a retain cycle.
        twilioIncomingCall.acceptWithDelegateBlock = { [weak self] (invite, delegate) in
            let twilioVendorCall = TwilioVendorCall(callInvite: callInvite, connected: callConnected, connectionFailed: callConnectionFailed, disconnected: callDisconnected)
            self?.incomingCallAnswered(twilioVendorCall, delegate)
        }

        twilioIncomingCall.declineCallBlock = { [weak self] (incomingCall) in
            callInvite.reject()
            self?.incomingCallDeclined(incomingCall)
        }

        twilioIncomingCall.displayNameUpdated = { [weak self] (updatedDisplayName) in
            self?.updateCallKitDisplayName(callInvite.uuid, updatedDisplayName)
        }

        self.incomingCall = twilioIncomingCall
    }

    func cancelledCallInviteReceived(cancelledCallInvite: CancelledCallInvite, error: Error) {
        guard let invite = self.callInvite else {
            self.logger?.error("Incoming call canceled, but no prior call invite found.")
            return
        }

        self.incomingCallCanceled(TwilioIncomingCall(invite: invite), error)
    }
}
