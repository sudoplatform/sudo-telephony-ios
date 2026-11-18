//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging
import SudoNotificationExtension
import SudoTelephonyCommon

/// Decodes telephony service push notifications in an app's Notification Service Extension.
///
/// Pass an instance to `DefaultSudoNotifiableClient`. The extension must share the keychain
/// access group, and the key namespace, of the app's `DefaultSudoTelephonyClient`, so it can
/// unseal what the service sealed to the phone number's key.
public final class DefaultSudoTelephonyNotifiableClient: SudoNotifiableClient {

    // MARK: - Properties

    /// Always `Constants.serviceName`.
    public let serviceName = Constants.serviceName

    private let deviceKeyManager: DeviceKeyManager
    private let logger: Logger

    // MARK: - Lifecycle

    /// Create a notifiable client.
    ///
    /// - Parameter keyNamespace: The namespace to find the unsealing keys in. Must match the
    ///   namespace the app's `DefaultSudoTelephonyClient` uses.
    public convenience init(keyNamespace: String = Constants.defaultKeyNamespace) {
        self.init(
            deviceKeyManager: DefaultDeviceKeyManager(keyNamespace: keyNamespace),
            logger: Logger.telephonySDKLogger
        )
    }

    /// Create a notifiable client over the given dependencies.
    ///
    /// - Parameters:
    ///   - deviceKeyManager: Unseals the notification payload.
    ///   - logger: Records why a notification couldn't be decoded.
    init(deviceKeyManager: DeviceKeyManager, logger: Logger) {
        self.deviceKeyManager = deviceKeyManager
        self.logger = logger
    }

    // MARK: - Conformance: SudoNotifiableClient

    /// Unseal and decode a telephony service push notification.
    ///
    /// Never throws or traps. A payload that can't be used, whether malformed, in an unsupported
    /// version, of an unknown type, or sealed to a key this device doesn't hold, is returned as a
    /// `TelephonyUnknownNotification`, and only the failing step, the type, the key ID and the
    /// error's type are logged.
    ///
    /// - Parameter data: The payload as returned by `DefaultSudoNotifiableClient`'s `extractData`.
    /// - Returns: A `PhoneMessageReceivedNotification`, or a `TelephonyUnknownNotification`.
    public func decode(data: String) -> any SudoNotification {
        let decoder = JSONDecoder()

        let sealedNotification: SealedTelephonyNotification
        do {
            sealedNotification = try decoder.decode(SealedTelephonyNotification.self, from: Data(data.utf8))
        } catch {
            logger.error("Couldn't decode the push payload as a sealed telephony notification: \(errorKind(error))")
            return TelephonyUnknownNotification(type: Constants.serviceName)
        }

        let notificationType = sealedNotification.type

        guard sealedNotification.version == SealedTelephonyNotification.supportedVersion else {
            logger.error("Unsupported push payload version \(sealedNotification.version) for notification type \(notificationType)")
            return TelephonyUnknownNotification(type: notificationType)
        }

        guard TelephonyServiceNotificationType(rawValue: notificationType) != nil else {
            logger.info("Notification type \(notificationType) isn't supported by this SDK version")
            return TelephonyUnknownNotification(type: notificationType)
        }

        guard
            let keyId = sealedNotification.keyId,
            let algorithm = sealedNotification.algorithm,
            let sealed = sealedNotification.sealed
        else {
            logger.error("Notification type \(notificationType) is missing its sealing fields")
            return TelephonyUnknownNotification(type: notificationType)
        }

        let unsealed: String
        do {
            unsealed = try deviceKeyManager.unsealString(sealed, withKeyId: keyId, algorithm: algorithm)
        } catch {
            let sealedByteCount = Data(base64Encoded: sealed)?.count ?? -1
            logger.error(
                "Couldn't unseal notification type \(notificationType) with key \(keyId), algorithm \(algorithm), "
                    + "\(sealedByteCount) sealed bytes: \(errorKind(error))"
            )
            return TelephonyUnknownNotification(type: notificationType)
        }

        let notification: TelephonyServiceNotification
        do {
            notification = try decoder.decode(TelephonyServiceNotification.self, from: Data(unsealed.utf8))
        } catch {
            logger.error("Couldn't decode unsealed notification type \(notificationType) with key \(keyId): \(errorKind(error))")
            return TelephonyUnknownNotification(type: notificationType)
        }

        guard notification.type == notificationType else {
            logger.error("Notification type \(notificationType) unsealed as type \(notification.type) with key \(keyId)")
            return TelephonyUnknownNotification(type: notificationType)
        }

        switch notification {
        case .messageReceived(let payload):
            return TelephonyServiceNotificationTransformer.transform(payload)
        case .unknown(let unknownType):
            return TelephonyUnknownNotification(type: unknownType)
        }
    }

    // MARK: - Helpers

    /// Name an error without its description or associated values, which can carry payload content.
    ///
    /// - Parameter error: The error to name.
    /// - Returns: The error's type, and for an enum case with associated values its case name too,
    ///   for example `SudoTelephonyError.unsealingFailed` or `DecodingError.keyNotFound`.
    private func errorKind(_ error: Error) -> String {
        let typeName = String(describing: Swift.type(of: error))
        guard let caseName = Mirror(reflecting: error).children.first?.label else {
            return typeName
        }
        return "\(typeName).\(caseName)"
    }
}
