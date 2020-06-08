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
        action: CXStartCallAction,
        callRecord: CallRecord,
        connected: @escaping () -> Void,
        connectionFailed: @escaping (Error) -> Void,
        disconnected: @escaping (Error?) -> Void
    )

    /// Disconnects this call.
    func disconnect()

    /// Indicates if this call's outgoing audio should be muted.
    var isMuted: Bool { get set }

    /// Indicates if this call should be placed on hold.
    var isOnHold: Bool { get set }

    /// Plays a string of DTMF tones over this call.
    func playDTMF(_ digits: String)
}

class TwilioVendorCall: CallingVendorCall {
    static var supportsDTMF: Bool = true
    static var supportsHolding: Bool = true
    static var supportsGrouping: Bool = false
    static var supportsUngrouping: Bool = false

    private let call: TVOCall
    private let delegate: TVOCallDelegate

    required init(
        action: CXStartCallAction,
        callRecord: CallRecord,
        connected: @escaping () -> Void,
        connectionFailed: @escaping (Error) -> Void,
        disconnected: @escaping (Error?) -> Void
    ) {
        let connectOptions = TVOConnectOptions(accessToken: callRecord.accessToken) { builder in
            builder.params = [
                "To": callRecord.remotePhoneNumber,
                "From": callRecord.localPhoneNumber
            ]
            builder.uuid = action.callUUID
        }

        class BlockTVOCallDelegate: NSObject, TVOCallDelegate {
            private let connected: () -> Void
            private let connectionFailed: (Error) -> Void
            private let disconnected: (Error?) -> Void

            init(
                connected: @escaping () -> Void,
                connectionFailed: @escaping (Error) -> Void,
                disconnected: @escaping (Error?) -> Void
            ) {
                self.connected = connected
                self.connectionFailed = connectionFailed
                self.disconnected = disconnected

                super.init()
            }

            func callDidConnect(_ call: TVOCall) {
                connected()
            }

            func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
                connectionFailed(error)
            }

            func call(_ call: TVOCall, didDisconnectWithError error: Error?) {
                disconnected(error)
            }

            func callDidStartRinging(_ call: TVOCall) {}

            func call(_ call: TVOCall, isReconnectingWithError error: Error) {}

            func callDidReconnect(_ call: TVOCall) {}
        }

        delegate = BlockTVOCallDelegate(
            connected: connected,
            connectionFailed: connectionFailed,
            disconnected: disconnected
        )
        call = TwilioVoice.connect(with: connectOptions, delegate: delegate)
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
}

class SimulatorVendorCall: CallingVendorCall {
    static var supportsDTMF: Bool = false
    static var supportsHolding: Bool = false
    static var supportsGrouping: Bool = false
    static var supportsUngrouping: Bool = false

    required init(
        action: CXStartCallAction,
        callRecord: CallRecord,
        connected: @escaping () -> Void,
        connectionFailed: @escaping (Error) -> Void,
        disconnected: @escaping (Error?) -> Void
    ) {
        // TODO
    }

    func disconnect() {
        // TODO
    }

    var isMuted: Bool = false // TODO

    var isOnHold: Bool {
        get { assertionFailure("Should not be called since `supportsHolding` is false"); return false }
        set { assertionFailure("Should not be called since `supportsHolding` is false") }
    }

    func playDTMF(_ digits: String) {
        assertionFailure("Should not be called since `supportsDTMF` is false")
    }
}
