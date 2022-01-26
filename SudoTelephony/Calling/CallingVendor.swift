//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import TwilioVoice
import CallKit

/// Manages the vendor context for a call.
protocol CallingVendorCall: AnyObject {
    /// A Boolean value that indicates whether this vendor's calls can send DTMF (dual tone multifrequency) tones via hard pause digits or in-call keypad entries.
    ///
    /// If false, `playDTMF` will never be called.
    static var supportsDTMF: Bool { get }

    /// A Boolean value that indicates whether this vendor's calls can be placed on hold or removed from hold.
    ///
    /// If false, `isOnHold` will never be accessed.
    static var supportsHolding: Bool { get }

    /// A Boolean value that indicates whether this vendor's calls can be grouped with other calls.
    static var supportsGrouping: Bool { get }

    /// A Boolean value that indicates whether this vendor's calls can be ungrouped from other calls.
    static var supportsUngrouping: Bool { get }

    /// Instantiates and connects a call from this vendor.
    init(
        uuid: UUID,
        accessToken: String,
        localPhoneNumber: String,
        remotePhoneNumber: String,
        connected: @escaping (_ callUUID: UUID) -> Void,
        connectionFailed: @escaping (_ callUUID: UUID, _ error: Error) -> Void,
        disconnected: @escaping (_ callUUID: UUID, _ error: Error?) -> Void
    )

    /// Disconnects this call.
    func disconnect()

    /// Indicates if this call's outgoing audio should be muted.
    var isMuted: Bool { get set }

    /// Indicates if this call should be placed on hold.
    var isOnHold: Bool { get set }

    /// Plays a string of DTMF tones over this call.
    func playDTMF(_ digits: String)

    /// UUID of the call
    var uuid: UUID { get }

    /// Local number
    var localNumber: String { get }

    /// Remote number
    var remoteNumber: String { get }
}

class TwilioVendorCall: CallingVendorCall {

    class BlockCallDelegate: NSObject, CallDelegate {

        // twilio call has an optional UUID so we can't rely on it being
        // available.  However all calls have a uuid so we pass it in so it
        // can be passed back out from delegate events.
        let callUUID: UUID

        private let connected: (_ callUUID: UUID) -> Void
        private let connectionFailed: (_ callUUID: UUID, _ error: Error) -> Void
        private let disconnected: (_ callUUID: UUID, _ error: Error?) -> Void

        init(
            uuid: UUID,
            connected: @escaping (_ callUUID: UUID) -> Void,
            connectionFailed: @escaping (_ callUUID: UUID, _ error: Error) -> Void,
            disconnected: @escaping (_ callUUID: UUID, _ error: Error?) -> Void
        ) {
            self.connected = connected
            self.connectionFailed = connectionFailed
            self.disconnected = disconnected
            self.callUUID = uuid

            super.init()
        }

        func callDidConnect(call: Call) {
            connected(callUUID)
        }

        func callDidFailToConnect(call: Call, error: Error) {
            connectionFailed(callUUID, error)
        }

        func callDidDisconnect(call: Call, error: Error?) {
            disconnected(callUUID, error)
        }

        func callDidStartRinging(call: Call) {}

        func call(call: Call, isReconnectingWithError error: Error) {}

        func callDidReconnect(call: Call) {}
    }

    static var supportsDTMF: Bool = true
    static var supportsHolding: Bool = true
    static var supportsGrouping: Bool = false
    static var supportsUngrouping: Bool = false

    private let call: Call
    private let delegate: CallDelegate

    /// Make an outgoing call
    required init(
        uuid: UUID,
        accessToken: String,
        localPhoneNumber: String,
        remotePhoneNumber: String,
        connected: @escaping (_ callUUID: UUID) -> Void,
        connectionFailed: @escaping (_ callUUID: UUID, _ error: Error) -> Void,
        disconnected: @escaping (_ callUUID: UUID, _ error: Error?) -> Void
    ) {
        self.uuid = uuid

        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
            builder.params = [
                "To": remotePhoneNumber,
                "From": localPhoneNumber
            ]
            builder.uuid = uuid
        }

        delegate = BlockCallDelegate(
            uuid: uuid,
            connected: connected,
            connectionFailed: connectionFailed,
            disconnected: disconnected
        )

        call = TwilioVoiceSDK.connect(options: connectOptions, delegate: delegate)

        // The `Call.to` value is the user's Twilio identity since this is a call to a client app. We can retrieve the actual `to` phone number from the call record
        self.localNumber = localPhoneNumber
        self.remoteNumber = remotePhoneNumber
    }

    /// Accept an incoming call
    init(
        callInvite: CallInvite,
        connected: @escaping (_ callUUID: UUID) -> Void,
        connectionFailed: @escaping (_ callUUID: UUID, _ error: Error) -> Void,
        disconnected: @escaping (_ callUUID: UUID, _ error: Error?) -> Void
    ) {
        delegate = BlockCallDelegate(
            uuid: callInvite.uuid,
            connected: connected,
            connectionFailed: connectionFailed,
            disconnected: disconnected
        )

        let acceptOptions = AcceptOptions(callInvite: callInvite) { builder in
            builder.uuid = callInvite.uuid
        }

        call = callInvite.accept(options: acceptOptions, delegate: delegate)

        // The `Call.to` and `CallInvite.to` value is the user's Twilio identity since this is a call to a client app. We can retrieve the actual `to` phone number from the CallInvite custom parameters.
        self.localNumber = callInvite.localNumber
        self.remoteNumber = callInvite.remoteNumber
        self.uuid = callInvite.uuid
    }

    func disconnect() {
        call.disconnect()
    }

    var isMuted: Bool {
        get {
            return call.isMuted
        }
        set {
            call.isMuted = newValue
        }
    }

    var isOnHold: Bool {
        get {
            return call.isOnHold
        }
        set {
            call.isOnHold = newValue
        }
    }

    func playDTMF(_ digits: String) {
        call.sendDigits(digits)
    }

    let uuid: UUID

    let localNumber: String

    let remoteNumber: String
}
