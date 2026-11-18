//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The unsealed JSON of a `messageReceived` notification. Its `type` is read by
/// `TelephonyServiceNotification`, which chose this payload from it.
struct MessageReceivedPayload: Decodable, Equatable {

    /// The start of the message body, at most 140 characters.
    let bodyPreview: String

    /// Whether the body is longer than `bodyPreview`.
    let bodyTruncated: Bool

    /// ID of the conversation the message belongs to.
    let conversationId: String

    /// Whether the message had media, which the service doesn't keep.
    let mediaOmitted: Bool

    /// ID of the message received.
    let messageId: String

    /// Subject ID of the user the notification is for.
    let owner: String

    /// ID of the phone number that received the message.
    let phoneNumberId: String

    /// When the service received the message, in milliseconds since the epoch.
    let receivedAtEpochMs: Int

    /// The sender's number.
    let remotePhoneNumber: String

    /// ID of the Sudo that owns the phone number. The service leaves it out when the number has no Sudo.
    let sudoId: String?
}
