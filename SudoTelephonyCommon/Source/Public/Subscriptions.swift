//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The change a phone message event reports.
///
/// `unknown` carries a change that this version of the SDK doesn't recognise, so the event is still delivered.
public enum PhoneMessageChangeType: Hashable, Sendable {

    /// A new message arrived.
    case received

    /// A message changed, for example its read state.
    case updated

    /// A message was deleted.
    case deleted

    /// A change this version of the SDK doesn't recognise, with the value the service sent.
    case unknown(String)
}

extension PhoneMessageChangeType: RawRepresentable, Codable {

    /// Create a change type from the service's value. An unrecognised value becomes `unknown`.
    public init(rawValue: String) {
        switch rawValue {
        case "RECEIVED": self = .received
        case "UPDATED": self = .updated
        case "DELETED": self = .deleted
        default: self = .unknown(rawValue)
        }
    }

    /// The service's value for this change type.
    public var rawValue: String {
        switch self {
        case .received: "RECEIVED"
        case .updated: "UPDATED"
        case .deleted: "DELETED"
        case .unknown(let rawValue): rawValue
        }
    }
}

/// A real-time notification that one of the caller's messages changed.
///
/// The event carries metadata only: message content (`body`, `remotePhoneNumber`)
/// never travels over the subscription. Call `getPhoneMessage(withId:)` with `id` to
/// fetch and unseal the full message when `changeType` is `.received` or `.updated`.
public struct PhoneMessageEvent: Equatable, Sendable {

    /// ID of the message. Pass to `getPhoneMessage(withId:)` to fetch the full content.
    public let id: String

    /// The user who owns the message: their subject.
    public let owner: String

    /// What else owns the message, from its phone number, for example a Sudo.
    public let owners: [Owner]

    /// ID of the phone number the message belongs to.
    public let phoneNumberId: String

    /// ID of the conversation the message belongs to.
    public let conversationId: String

    /// The kind of message.
    public let type: PhoneMessageType

    /// Whether the message was received or sent.
    public let direction: PhoneMessageDirection

    /// The change being reported.
    public let changeType: PhoneMessageChangeType

    /// Whether the message is marked read.
    public let seen: Bool

    /// Version of the message after the change.
    public let version: Int

    /// When the message was last updated.
    public let updatedAt: Date

    /// ID of the Sudo that owns the message, or `nil` if its phone number has none.
    public var sudoId: String? {
        owners.sudoId
    }

    /// Create a phone message event.
    public init(
        id: String,
        owner: String,
        owners: [Owner],
        phoneNumberId: String,
        conversationId: String,
        type: PhoneMessageType,
        direction: PhoneMessageDirection,
        changeType: PhoneMessageChangeType,
        seen: Bool,
        version: Int,
        updatedAt: Date
    ) {
        self.id = id
        self.owner = owner
        self.owners = owners
        self.phoneNumberId = phoneNumberId
        self.conversationId = conversationId
        self.type = type
        self.direction = direction
        self.changeType = changeType
        self.seen = seen
        self.version = version
        self.updatedAt = updatedAt
    }
}

/// A handle to an active subscription.
///
/// Hold the token for as long as updates are wanted; call `cancel()` — or release the
/// last reference — to end the subscription and free its transport resources. The SDK
/// follows the Sudo Platform convention of returning a cancellable token rather than a
/// stream so callers manage the subscription's lifetime explicitly.
public protocol SubscriptionToken: AnyObject, Sendable {

    /// End the subscription. Idempotent: calling it more than once has no effect. No
    /// callbacks reach the subscriber once it returns; if a callback is in progress on
    /// another thread, it waits for it to finish.
    func cancel()
}

/// The connection state of a subscription.
public enum SubscriptionConnectionState: Equatable, Sendable {

    /// Connected and receiving updates.
    case connected

    /// Disconnected, and won't receive any more updates. Subscribe again to resume.
    ///
    /// - Parameter cause: Why the connection closed, or `nil` if the service ended the
    ///   subscription without an error.
    case disconnected(cause: SudoTelephonyError?)
}

/// Something that subscribes to the telephony service's real-time updates.
///
/// The SDK holds a subscriber weakly, so a subscriber can keep its own subscription
/// token without a retain cycle. Once the subscriber is released, its subscriptions end.
/// Callbacks may arrive on any thread, one at a time per subscription. A callback must
/// not block waiting on another thread that cancels the same subscription, because
/// `cancel()` waits for a callback in progress to finish.
public protocol Subscriber: AnyObject, Sendable {

    /// Notifies the subscriber that the subscription's connection state changed.
    ///
    /// `connected` is reported once, when the service acknowledges the subscription.
    /// `disconnected` is reported at most once, after which the subscription has ended
    /// and the caller must subscribe again to receive updates. Neither is reported after
    /// the caller cancels the subscription.
    ///
    /// - Parameter state: The connection state.
    func connectionStatusChanged(_ state: SubscriptionConnectionState)
}

/// Subscribes to changes to the caller's phone numbers.
public protocol PhoneNumberSubscriber: Subscriber {

    /// Notifies the subscriber that one of the caller's phone numbers changed.
    ///
    /// - Parameter phoneNumber: The number as it now stands.
    func phoneNumberUpdated(_ phoneNumber: PhoneNumber)
}

/// Subscribes to changes to the caller's phone messages.
public protocol PhoneMessageSubscriber: Subscriber {

    /// Notifies the subscriber that one of the caller's phone messages changed.
    ///
    /// The event carries no message content; fetch the message with
    /// `getPhoneMessage(withId:)` to read its text.
    ///
    /// - Parameter event: The change being reported.
    func phoneMessageEvent(_ event: PhoneMessageEvent)
}
