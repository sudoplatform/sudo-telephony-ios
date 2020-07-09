//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import TwilioVoice

public protocol IncomingCall: class {

    /// When an incoming call is recieved the delegate should be set in order to get updates on call related events.
    /// For example if the call is answered through CallKit the delegate will recieve the call connected event with
    /// a handle to the call.
    var delegate: ActiveCallDelegate? { get set }

    /// The phone number receiving the call
    var localNumber: String { get }

    /// The phone number the call is coming from
    var remoteNumber: String { get }

    /// The UUID for the call
    var uuid: UUID { get }

    /// Accepts the call with a delegate to provide call lifecycle updates.
    func accept(with delegate: ActiveCallDelegate)

    /// Decline the call.
    func decline()

    /// The display name used by callKit when reporting a call
    var displayName: CallKitDisplayName? { get set }
}



class TwilioIncomingCall: IncomingCall {

    private let invite: TVOCallInvite

    init(invite: TVOCallInvite) {
        self.invite = invite
    }

    var delegate: ActiveCallDelegate?

    /// The phone number receiving the call
    var localNumber: String {
        return invite.localNumber

    }

    /// The phone number the call is coming from
    var remoteNumber: String {
        return invite.remoteNumber
    }

    /// The UUID for the call
    var uuid: UUID { return invite.uuid }

    /// The display name used by callKit when reporting a call
    var displayNameUpdated: ((CallKitDisplayName) -> Void)?
    var displayName: CallKitDisplayName? {
        didSet {
            if let newValue = displayName {
                self.displayNameUpdated?(newValue)
            }
        }
    }

    /// Accepts the call with a delegate to provide call lifecycle updates.
    var acceptWithDelegateBlock: ((_ call: TVOCallInvite, _ delegate: ActiveCallDelegate) -> Void)?

    func accept(with delegate: ActiveCallDelegate) {
        self.acceptWithDelegateBlock?(self.invite, delegate)
    }

    /// Decline the call.

    var declineCallBlock: ((TwilioIncomingCall) -> Void)?

    func decline() {
        self.declineCallBlock?(self)
    }
}


/// Helper variables to pull the correct to/from values from the invites custom parameters.
/// We do this because we can't rely on the call invites to field because it's a guid not a phone number.
extension TVOCallInvite {
    var localNumber: String { return self.customParameters?["SudoPlatformLocalPhoneNumber"] ?? "" }
    var remoteNumber: String { return self.customParameters?["SudoPlatformRemotePhoneNumber"] ?? "" }
}
