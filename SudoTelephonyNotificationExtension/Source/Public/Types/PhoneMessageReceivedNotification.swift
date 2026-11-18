//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoNotificationExtension
import SudoTelephonyCommon

/// A push notification that an inbound message was received on one of the user's phone numbers.
///
/// The sender's number and the body preview are decrypted. Fetch the full message with
/// `SudoTelephonyClient.getPhoneMessage(withId:)` using `messageId`.
public struct PhoneMessageReceivedNotification: SudoNotification, Equatable {

    // MARK: - Properties

    /// The start of the message body, at most 140 characters.
    public let bodyPreview: String

    /// Whether the body is longer than `bodyPreview`.
    public let bodyTruncated: Bool

    /// ID of the conversation the message belongs to.
    public let conversationId: String

    /// Whether the message had media, which the service doesn't keep.
    public let mediaOmitted: Bool

    /// ID of the message received.
    public let messageId: String

    /// Subject ID of the user the notification is for.
    public let owner: String

    /// ID of the phone number that received the message.
    public let phoneNumberId: String

    /// When the service received the message.
    public let receivedAt: Date

    /// The sender's number, in E.164 format or a short code.
    public let remotePhoneNumber: String

    /// Always `Constants.serviceName`.
    public let serviceName = Constants.serviceName

    /// ID of the Sudo that owns the phone number, or `nil` if the number has none.
    public let sudoId: String?

    /// Always `TelephonyServiceNotificationType.messageReceived.rawValue`.
    public let type = TelephonyServiceNotificationType.messageReceived.rawValue

    // MARK: - Lifecycle

    /// Create a message received notification.
    ///
    /// - Parameters:
    ///   - bodyPreview: The start of the message body, at most 140 characters.
    ///   - bodyTruncated: Whether the body is longer than `bodyPreview`.
    ///   - conversationId: ID of the conversation the message belongs to.
    ///   - mediaOmitted: Whether the message had media, which the service doesn't keep.
    ///   - messageId: ID of the message received.
    ///   - owner: Subject ID of the user the notification is for.
    ///   - phoneNumberId: ID of the phone number that received the message.
    ///   - receivedAt: When the service received the message.
    ///   - remotePhoneNumber: The sender's number.
    ///   - sudoId: ID of the Sudo that owns the phone number, or `nil` if the number has none.
    public init(
        bodyPreview: String,
        bodyTruncated: Bool,
        conversationId: String,
        mediaOmitted: Bool,
        messageId: String,
        owner: String,
        phoneNumberId: String,
        receivedAt: Date,
        remotePhoneNumber: String,
        sudoId: String?
    ) {
        self.bodyPreview = bodyPreview
        self.bodyTruncated = bodyTruncated
        self.conversationId = conversationId
        self.mediaOmitted = mediaOmitted
        self.messageId = messageId
        self.owner = owner
        self.phoneNumberId = phoneNumberId
        self.receivedAt = receivedAt
        self.remotePhoneNumber = remotePhoneNumber
        self.sudoId = sudoId
    }
}
