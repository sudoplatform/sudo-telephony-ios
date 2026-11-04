//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The change a phone message event reports.
public enum PhoneMessageChangeType: String, Equatable, Sendable, Codable {

    /// A new message arrived.
    case received = "RECEIVED"

    /// A message changed, for example its read state.
    case updated = "UPDATED"

    /// A message was deleted.
    case deleted = "DELETED"
}

/// A real-time notification that one of the caller's messages changed.
///
/// The event carries metadata only: message content (`body`, `remotePhoneNumber`)
/// never travels over the subscription. Call `getPhoneMessage(id:)` with `id` to
/// fetch and unseal the full message when `changeType` is `.received` or `.updated`.
public struct PhoneMessageEvent: Equatable, Sendable {

    /// ID of the message. Pass to `getPhoneMessage(id:)` to fetch the full content.
    public let id: String

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

    /// Create a phone message event.
    public init(
        id: String,
        phoneNumberId: String,
        conversationId: String,
        type: PhoneMessageType,
        direction: PhoneMessageDirection,
        changeType: PhoneMessageChangeType,
        seen: Bool
    ) {
        self.id = id
        self.phoneNumberId = phoneNumberId
        self.conversationId = conversationId
        self.type = type
        self.direction = direction
        self.changeType = changeType
        self.seen = seen
    }
}

/// A handle to an active subscription.
///
/// Hold the token for as long as updates are wanted; call `cancel()` — or release the
/// last reference — to end the subscription and free its transport resources. The SDK
/// follows the Sudo Platform convention of returning a cancellable token rather than a
/// stream so callers manage the subscription's lifetime explicitly.
public protocol SubscriptionToken: AnyObject, Sendable {

    /// End the subscription. Idempotent: calling it more than once has no effect.
    func cancel()
}
