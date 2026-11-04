//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Maps the generated `SealedPhoneMessage` fragment to the public `PhoneMessage`,
/// unsealing `body` and `remotePhoneNumber` with the device key manager.
///
/// The telephony service seals both fields with the `RSAEncryptionOAEPAESGCM`
/// envelope keyed to the phone number's key ring; the keyId passed here is the key
/// pair the SDK generated when provisioning that number.
enum PhoneMessageTransformer {

    private static let algorithm = "RSAEncryptionOAEPAESGCM"

    /// Transform and unseal a single message fragment.
    static func transform(
        _ fragment: GraphQL.SealedPhoneMessageFragment,
        keyId: String,
        deviceKeyManager: DeviceKeyManager
    ) throws -> PhoneMessage {
        guard let type = PhoneMessageType(rawValue: fragment.type) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageType: \(fragment.type)")
        }
        guard let direction = PhoneMessageDirection(rawValue: fragment.direction) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageDirection: \(fragment.direction)")
        }
        let body = try deviceKeyManager.unsealString(fragment.body, withKeyId: keyId, algorithm: algorithm)
        let remotePhoneNumber = try fragment.remotePhoneNumber.map {
            try deviceKeyManager.unsealString($0, withKeyId: keyId, algorithm: algorithm)
        }
        return PhoneMessage(
            id: fragment.id,
            phoneNumberId: fragment.phoneNumberId,
            conversationId: fragment.conversationId,
            type: type,
            direction: direction,
            localPhoneNumber: fragment.localPhoneNumber,
            remotePhoneNumber: remotePhoneNumber,
            body: body,
            segmentCount: fragment.segmentCount,
            mediaOmitted: fragment.mediaOmitted,
            seen: fragment.seen,
            receivedAtEpochMs: fragment.receivedAtEpochMs,
            createdAtEpochMs: fragment.createdAtEpochMs,
            updatedAtEpochMs: fragment.updatedAtEpochMs
        )
    }

    /// Transform a batch result selection set into the public type.
    static func transform(_ result: GraphQL.BatchResult) -> PhoneMessageBatchResult {
        PhoneMessageBatchResult(
            succeededIds: result.succeededIds,
            failedIds: result.failedIds
        )
    }

    /// Transform a message-event subscription payload into the public event.
    static func transform(
        _ event: GraphQL.OnPhoneMessageEventSubscription.Data.Event
    ) throws -> PhoneMessageEvent {
        guard let type = PhoneMessageType(rawValue: event.type) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageType: \(event.type)")
        }
        guard let direction = PhoneMessageDirection(rawValue: event.direction) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageDirection: \(event.direction)")
        }
        guard let changeType = PhoneMessageChangeType(rawValue: event.changeType) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageChangeType: \(event.changeType)")
        }
        return PhoneMessageEvent(
            id: event.id,
            phoneNumberId: event.phoneNumberId,
            conversationId: event.conversationId,
            type: type,
            direction: direction,
            changeType: changeType,
            seen: event.seen
        )
    }
}
