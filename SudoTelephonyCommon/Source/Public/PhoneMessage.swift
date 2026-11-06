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

/// A message received on one of the user's phone numbers, with its content unsealed.
public struct PhoneMessage: Equatable, Sendable {

    /// ID of the message.
    public let id: String

    /// The user who owns the message: their subject.
    public let owner: String

    /// What else owns the message, from the phone number that received it, for
    /// example a Sudo.
    public let owners: [Owner]

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

    /// Version of the record, increased on each change.
    public let version: Int

    /// When the service received the message from the telephony provider.
    public let receivedAt: Date

    /// When the message was created.
    public let createdAt: Date

    /// When the message was last updated.
    public let updatedAt: Date

    /// ID of the Sudo that owns the message, or `nil` if its phone number has none.
    public var sudoId: String? {
        owners.sudoId
    }

    /// Create a phone message.
    public init(
        id: String,
        owner: String,
        owners: [Owner],
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
        version: Int,
        receivedAt: Date,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.owner = owner
        self.owners = owners
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
        self.version = version
        self.receivedAt = receivedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// A message whose sealed content couldn't be unsealed, for example because this
/// device doesn't have the key it was sealed to. It has everything about the
/// message except the sender and text.
public struct PartialPhoneMessage: Equatable, Sendable {

    /// ID of the message.
    public let id: String

    /// The user who owns the message: their subject.
    public let owner: String

    /// What else owns the message, for example a Sudo.
    public let owners: [Owner]

    /// ID of the phone number that received the message.
    public let phoneNumberId: String

    /// ID of the conversation the message belongs to.
    public let conversationId: String

    /// The kind of message.
    public let type: PhoneMessageType

    /// Whether the message was received or sent.
    public let direction: PhoneMessageDirection

    /// The user's number, in E.164 format.
    public let localPhoneNumber: String

    /// The number of SMS segments the message was carried in.
    public let segmentCount: Int

    /// True for an inbound MMS whose media was dropped and only its text kept.
    public let mediaOmitted: Bool

    /// Whether the user has marked the message as read.
    public let seen: Bool

    /// Version of the record, increased on each change.
    public let version: Int

    /// When the service received the message from the telephony provider.
    public let receivedAt: Date

    /// When the message was created.
    public let createdAt: Date

    /// When the message was last updated.
    public let updatedAt: Date

    /// ID of the Sudo that owns the message, or `nil` if its phone number has none.
    public var sudoId: String? {
        owners.sudoId
    }

    /// Create a partial phone message.
    public init(
        id: String,
        owner: String,
        owners: [Owner],
        phoneNumberId: String,
        conversationId: String,
        type: PhoneMessageType,
        direction: PhoneMessageDirection,
        localPhoneNumber: String,
        segmentCount: Int,
        mediaOmitted: Bool,
        seen: Bool,
        version: Int,
        receivedAt: Date,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.owner = owner
        self.owners = owners
        self.phoneNumberId = phoneNumberId
        self.conversationId = conversationId
        self.type = type
        self.direction = direction
        self.localPhoneNumber = localPhoneNumber
        self.segmentCount = segmentCount
        self.mediaOmitted = mediaOmitted
        self.seen = seen
        self.version = version
        self.receivedAt = receivedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
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
public struct ListPhoneMessagesForPhoneNumberIdInput: Equatable, Sendable {

    /// ID of the phone number whose messages to list.
    public let phoneNumberId: String

    /// Order of the messages. Defaults to newest first.
    public let sortOrder: MessageSortOrder?

    /// Maximum number of messages per page. See
    /// `TelephonyConfigurationData.listDefaultLimit` and `listMaxLimit`.
    public let limit: Int?

    /// An opaque token from a prior page.
    public let nextToken: String?

    /// Create a list input.
    public init(
        phoneNumberId: String,
        sortOrder: MessageSortOrder? = nil,
        limit: Int? = nil,
        nextToken: String? = nil
    ) {
        self.phoneNumberId = phoneNumberId
        self.sortOrder = sortOrder
        self.limit = limit
        self.nextToken = nextToken
    }
}

/// Input for listing the messages of one conversation, which belongs to one phone
/// number.
public struct ListPhoneMessagesForConversationIdInput: Equatable, Sendable {

    /// ID of the conversation whose messages to list.
    public let conversationId: String

    /// Order of the messages. Defaults to newest first.
    public let sortOrder: MessageSortOrder?

    /// Maximum number of messages per page. See
    /// `TelephonyConfigurationData.listDefaultLimit` and `listMaxLimit`.
    public let limit: Int?

    /// An opaque token from a prior page.
    public let nextToken: String?

    /// Create a list input.
    public init(
        conversationId: String,
        sortOrder: MessageSortOrder? = nil,
        limit: Int? = nil,
        nextToken: String? = nil
    ) {
        self.conversationId = conversationId
        self.sortOrder = sortOrder
        self.limit = limit
        self.nextToken = nextToken
    }
}
