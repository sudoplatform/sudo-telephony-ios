//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import TwilioVoice
import CallKit

/// Manages the vendor context for a call.
protocol CallingVendorCall: class {
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

    class BlockTVOCallDelegate: NSObject, TVOCallDelegate {
        private let connected: (_ callUUID: UUID) -> Void
        private let connectionFailed: (_ callUUID: UUID, _ error: Error) -> Void
        private let disconnected: (_ callUUID: UUID, _ error: Error?) -> Void

        init(
            connected: @escaping (_ callUUID: UUID) -> Void,
            connectionFailed: @escaping (_ callUUID: UUID, _ error: Error) -> Void,
            disconnected: @escaping (_ callUUID: UUID, _ error: Error?) -> Void
        ) {
            self.connected = connected
            self.connectionFailed = connectionFailed
            self.disconnected = disconnected

            super.init()
        }

        func callDidConnect(_ call: TVOCall) {
            connected(call.uuid)
        }

        func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
            connectionFailed(call.uuid, error)
        }

        func call(_ call: TVOCall, didDisconnectWithError error: Error?) {
            disconnected(call.uuid, error)
        }

        func callDidStartRinging(_ call: TVOCall) {}

        func call(_ call: TVOCall, isReconnectingWithError error: Error) {}

        func callDidReconnect(_ call: TVOCall) {}
    }

    static var supportsDTMF: Bool = true
    static var supportsHolding: Bool = true
    static var supportsGrouping: Bool = false
    static var supportsUngrouping: Bool = false

    private let call: TVOCall
    private let delegate: TVOCallDelegate

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
        let connectOptions = TVOConnectOptions(accessToken: accessToken) { builder in
            builder.params = [
                "To": remotePhoneNumber,
                "From": localPhoneNumber
            ]
            builder.uuid = uuid
        }

        delegate = BlockTVOCallDelegate(
            connected: connected,
            connectionFailed: connectionFailed,
            disconnected: disconnected
        )
        call = TwilioVoice.connect(with: connectOptions, delegate: delegate)

        // The `TVOCall.to` value is the user's Twilio identity since this is a call to a client app. We can retrieve the actual `to` phone number from the call record
        self.localNumber = localPhoneNumber
        self.remoteNumber = remotePhoneNumber
    }

    /// Accept an incoming call
    init(
        callInvite: TVOCallInvite,
        connected: @escaping (_ callUUID: UUID) -> Void,
        connectionFailed: @escaping (_ callUUID: UUID, _ error: Error) -> Void,
        disconnected: @escaping (_ callUUID: UUID, _ error: Error?) -> Void
    ) {
        delegate = BlockTVOCallDelegate(
            connected: connected,
            connectionFailed: connectionFailed,
            disconnected: disconnected
        )

        let options = TVOAcceptOptions(callInvite: callInvite) { (builder) in
            builder.uuid = callInvite.uuid
        }

        call = callInvite.accept(with: options, delegate: delegate)

        // The `TVOCall.to` and `TVOCallInvite.to` value is the user's Twilio identity since this is a call to a client app. We can retrieve the actual `to` phone number from the TVOCallInvite custom parameters.
        self.localNumber = callInvite.localNumber
        self.remoteNumber = callInvite.remoteNumber
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

    var uuid: UUID {
        return call.uuid
    }

    let localNumber: String

    let remoteNumber: String
}
