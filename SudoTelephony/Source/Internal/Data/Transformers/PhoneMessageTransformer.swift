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
        _ fragment: GraphQL.SealedPhoneMessageFields,
        keyId: String,
        deviceKeyManager: DeviceKeyManager
    ) throws -> PhoneMessage {
        let partial = try partial(fragment)
        let body = try deviceKeyManager.unsealString(fragment.body, withKeyId: keyId, algorithm: algorithm)
        let remotePhoneNumber = try fragment.remotePhoneNumber.map {
            try deviceKeyManager.unsealString($0, withKeyId: keyId, algorithm: algorithm)
        }
        return PhoneMessage(
            id: partial.id,
            owner: partial.owner,
            owners: partial.owners,
            phoneNumberId: partial.phoneNumberId,
            conversationId: partial.conversationId,
            type: partial.type,
            direction: partial.direction,
            localPhoneNumber: partial.localPhoneNumber,
            remotePhoneNumber: remotePhoneNumber,
            body: body,
            segmentCount: partial.segmentCount,
            mediaOmitted: partial.mediaOmitted,
            seen: partial.seen,
            version: partial.version,
            receivedAt: partial.receivedAt,
            createdAt: partial.createdAt,
            updatedAt: partial.updatedAt
        )
    }

    /// Transform and unseal a page of message fragments. A message that can't be unsealed, e.g. because this device lacks
    /// its key, is returned as a partial message instead of failing the whole page. Any other failure still fails it.
    static func transform(
        items fragments: [GraphQL.SealedPhoneMessageFields],
        nextToken: String?,
        keyId: String,
        deviceKeyManager: DeviceKeyManager
    ) throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage> {
        var items: [PhoneMessage] = []
        var failed: [PartialResult<PartialPhoneMessage>] = []
        for fragment in fragments {
            do {
                try items.append(transform(fragment, keyId: keyId, deviceKeyManager: deviceKeyManager))
            } catch let error as SudoTelephonyError {
                guard case .unsealingFailed = error else { throw error }
                try failed.append(PartialResult(partial: partial(fragment), error: error))
            }
        }
        if failed.isEmpty {
            return .success(.init(items: items, nextToken: nextToken))
        }
        return .partial(.init(items: items, failed: failed, nextToken: nextToken))
    }

    /// Transform the parts of a message fragment that aren't sealed, for a message whose content can't be unsealed.
    static func partial(_ fragment: GraphQL.SealedPhoneMessageFields) throws -> PartialPhoneMessage {
        let rawType = fragment.enumRawValue("type")
        guard let type = rawType.flatMap(PhoneMessageType.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageType: \(rawType ?? "nil")")
        }
        let rawDirection = fragment.enumRawValue("direction")
        guard let direction = rawDirection.flatMap(PhoneMessageDirection.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageDirection: \(rawDirection ?? "nil")")
        }
        return PartialPhoneMessage(
            id: fragment.id,
            owner: fragment.owner,
            owners: fragment.owners.map { Owner(id: $0.id, issuer: $0.issuer) },
            phoneNumberId: fragment.phoneNumberId,
            conversationId: fragment.conversationId,
            type: type,
            direction: direction,
            localPhoneNumber: fragment.localPhoneNumber,
            segmentCount: fragment.segmentCount,
            mediaOmitted: fragment.mediaOmitted,
            seen: fragment.seen,
            version: fragment.version,
            receivedAt: Date(epochMs: fragment.receivedAtEpochMs),
            createdAt: Date(epochMs: fragment.createdAtEpochMs),
            updatedAt: Date(epochMs: fragment.updatedAtEpochMs)
        )
    }

    /// Transform a batch result selection set into the public type.
    static func transform(_ result: GraphQL.PhoneMessageBatchResultFields) -> PhoneMessageBatchResult {
        PhoneMessageBatchResult(
            succeededIds: result.succeededIds,
            failedIds: result.failedIds
        )
    }

    /// Transform a message-event subscription payload into the public event.
    static func transform(
        _ event: GraphQL.OnPhoneMessageEventSubscription.Data.OnPhoneMessageEvent
    ) throws -> PhoneMessageEvent {
        let rawType = event.enumRawValue("type")
        guard let type = rawType.flatMap(PhoneMessageType.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageType: \(rawType ?? "nil")")
        }
        let rawDirection = event.enumRawValue("direction")
        guard let direction = rawDirection.flatMap(PhoneMessageDirection.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageDirection: \(rawDirection ?? "nil")")
        }
        let rawChangeType = event.enumRawValue("changeType")
        guard let changeType = rawChangeType.flatMap(PhoneMessageChangeType.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneMessageChangeType: \(rawChangeType ?? "nil")")
        }
        return PhoneMessageEvent(
            id: event.id,
            owner: event.owner,
            owners: event.owners.map { Owner(id: $0.id, issuer: $0.issuer) },
            phoneNumberId: event.phoneNumberId,
            conversationId: event.conversationId,
            type: type,
            direction: direction,
            changeType: changeType,
            seen: event.seen,
            version: event.version,
            updatedAt: Date(epochMs: event.updatedAtEpochMs)
        )
    }
}
