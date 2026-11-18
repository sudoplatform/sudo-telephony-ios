//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Maps unsealed telephony service notification payloads to the public notification types.
enum TelephonyServiceNotificationTransformer {

    /// Map a `messageReceived` payload to its public notification.
    ///
    /// - Parameter payload: The unsealed payload.
    /// - Returns: The public notification, with `receivedAt` keeping millisecond precision.
    static func transform(_ payload: MessageReceivedPayload) -> PhoneMessageReceivedNotification {
        PhoneMessageReceivedNotification(
            bodyPreview: payload.bodyPreview,
            bodyTruncated: payload.bodyTruncated,
            conversationId: payload.conversationId,
            mediaOmitted: payload.mediaOmitted,
            messageId: payload.messageId,
            owner: payload.owner,
            phoneNumberId: payload.phoneNumberId,
            receivedAt: Date(timeIntervalSince1970: Double(payload.receivedAtEpochMs) / 1000),
            remotePhoneNumber: payload.remotePhoneNumber,
            sudoId: payload.sudoId
        )
    }
}
