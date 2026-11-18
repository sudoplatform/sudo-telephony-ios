//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoNotification
import SudoTelephonyCommon

/// Describes the telephony service's push notification filter fields to the notification SDK.
///
/// Pass an instance to `DefaultSudoNotificationClient` so the app can filter telephony pushes, for example with
/// the `setTelephonyNotifications` extensions on `NotificationConfiguration`.
public final class DefaultSudoTelephonyNotificationFilterClient: SudoNotificationFilterClient {

    // MARK: - Properties

    /// Always `Constants.serviceName`.
    public let serviceName = SudoTelephonyCommon.Constants.serviceName

    /// The fields a telephony notification filter rule can match on.
    private static let schema = NotificationMetaData(
        serviceName: SudoTelephonyCommon.Constants.serviceName,
        schema: [
            NotificationSchemaEntry(
                description: "Type of notification message",
                fieldName: "meta.type",
                type: "string"
            ),
            NotificationSchemaEntry(
                description: "ID of the phone number the message was received on",
                fieldName: "meta.phoneNumberId",
                type: "string"
            ),
            NotificationSchemaEntry(
                description: "ID of the Sudo that owns the phone number",
                fieldName: "meta.sudoId",
                type: "string"
            ),
            NotificationSchemaEntry(
                description: "ID of the conversation the message belongs to",
                fieldName: "meta.conversationId",
                type: "string"
            ),
            NotificationSchemaEntry(
                description: "ID of the key pair the notification content is sealed with",
                fieldName: "meta.keyId",
                type: "string"
            )
        ]
    )

    // MARK: - Lifecycle

    /// Create a filter client.
    public init() {}

    // MARK: - Conformance: SudoNotificationFilterClient

    public func getSchema() -> NotificationMetaData {
        Self.schema
    }
}
