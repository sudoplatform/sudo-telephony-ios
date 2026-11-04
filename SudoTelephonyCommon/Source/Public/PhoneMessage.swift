//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The kind of phone message. MMS and voicemail are planned but not yet delivered.
public enum PhoneMessageType: String, Equatable, Sendable, Codable {

    /// A text message.
    case sms = "SMS"
}

/// The direction of a phone message. Only inbound is delivered today.
public enum PhoneMessageDirection: String, Equatable, Sendable, Codable {

    /// Received on the user's number from the other party.
    case inbound = "INBOUND"
}

/// A phone message with its sensitive fields unsealed.
///
/// `body` and `remotePhoneNumber` are decrypted by the SDK before the message reaches
/// a consumer; the sealed forms never leave the data layer.
public struct PhoneMessage: Equatable, Sendable {

    /// ID of the message.
    public let id: String

    /// ID of the phone number that received the message.
    public let phoneNumberId: String

    /// ID of the conversation grouping every message between this number and the
    /// other party.
    public let conversationId: String

    /// The kind of message.
    public let type: PhoneMessageType

    /// Whether the message was received or sent.
    public let direction: PhoneMessageDirection

    /// The user's number, in E.164 format.
    public let localPhoneNumber: String

    /// The other party's number (the sender of an inbound message), in E.164 format
    /// or a short code. Decrypted. `nil` only for future cases such as voicemails
    /// from withheld numbers; always set for SMS.
    public let remotePhoneNumber: String?

    /// The decrypted message text. Empty for a media-only MMS.
    public let body: String

    /// The number of SMS segments the message was carried in.
    public let segmentCount: Int

    /// True for an inbound MMS whose media was dropped and only its text kept.
    public let mediaOmitted: Bool

    /// Whether the user has marked the message as read.
    public let seen: Bool

    /// Time in milliseconds since the Unix epoch when the service received the
    /// message from the telephony provider.
    public let receivedAtEpochMs: Double

    /// Time in milliseconds since the Unix epoch when the message was created.
    public let createdAtEpochMs: Double

    /// Time in milliseconds since the Unix epoch when the message was last updated.
    public let updatedAtEpochMs: Double

    /// Create a phone message.
    public init(
        id: String,
        phoneNumberId: String,
        conversationId: String,
        type: PhoneMessageType,
        direction: PhoneMessageDirection,
        localPhoneNumber: String,
        remotePhoneNumber: String?,
        body: String,
        segmentCount: Int,
        mediaOmitted: Bool,
        seen: Bool,
        receivedAtEpochMs: Double,
        createdAtEpochMs: Double,
        updatedAtEpochMs: Double
    ) {
        self.id = id
        self.phoneNumberId = phoneNumberId
        self.conversationId = conversationId
        self.type = type
        self.direction = direction
        self.localPhoneNumber = localPhoneNumber
        self.remotePhoneNumber = remotePhoneNumber
        self.body = body
        self.segmentCount = segmentCount
        self.mediaOmitted = mediaOmitted
        self.seen = seen
        self.receivedAtEpochMs = receivedAtEpochMs
        self.createdAtEpochMs = createdAtEpochMs
        self.updatedAtEpochMs = updatedAtEpochMs
    }
}

/// A page of phone messages.
public struct PhoneMessageListToken: Equatable, Sendable {

    /// The messages on this page, with content unsealed.
    public let items: [PhoneMessage]

    /// An opaque token to fetch the next page, or `nil` when there are no more.
    public let nextToken: String?

    /// Create a page of phone messages.
    public init(items: [PhoneMessage], nextToken: String?) {
        self.items = items
        self.nextToken = nextToken
    }
}

/// The order messages are returned in.
public enum MessageSortOrder: String, Equatable, Sendable {

    /// Oldest first.
    case ascending = "ASC"

    /// Newest first (the service default).
    case descending = "DESC"
}

/// The outcome of a batch operation (delete or update) on phone messages.
public struct PhoneMessageBatchResult: Equatable, Sendable {

    /// IDs the operation applied to.
    public let succeededIds: [String]

    /// IDs that weren't found or don't belong to the caller.
    public let failedIds: [String]

    /// Create a batch result.
    public init(succeededIds: [String], failedIds: [String]) {
        self.succeededIds = succeededIds
        self.failedIds = failedIds
    }
}

/// Input for listing a phone number's messages.
public struct ListPhoneMessagesInput: Equatable, Sendable {

    /// ID of the phone number whose messages to list.
    public let phoneNumberId: String

    /// Limit the list to a single conversation.
    public let conversationId: String?

    /// Order of the messages. Defaults to newest first.
    public let sortOrder: MessageSortOrder?

    /// Maximum number of messages per page.
    public let limit: Int?

    /// An opaque token from a prior page.
    public let nextToken: String?

    /// Create a list input.
    public init(
        phoneNumberId: String,
        conversationId: String? = nil,
        sortOrder: MessageSortOrder? = nil,
        limit: Int? = nil,
        nextToken: String? = nil
    ) {
        self.phoneNumberId = phoneNumberId
        self.conversationId = conversationId
        self.sortOrder = sortOrder
        self.limit = limit
        self.nextToken = nextToken
    }
}
