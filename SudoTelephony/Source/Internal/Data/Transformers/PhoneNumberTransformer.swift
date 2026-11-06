//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Maps the generated phone-number response types to the public domain types.
///
/// Pure and independently testable — it performs no I/O. Unknown enum raw values
/// surface as `SudoTelephonyError.internalError` so a backend that adds a value the
/// SDK does not yet model fails loudly rather than silently.
enum PhoneNumberTransformer {

    /// Transform a `PhoneNumber` fragment into the public `PhoneNumber`.
    static func transform(_ fragment: GraphQL.PhoneNumberFields) throws -> PhoneNumber {
        let rawNumberType = fragment.enumRawValue("numberType")
        guard let numberType = rawNumberType.flatMap(PhoneNumberType.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneNumberType: \(rawNumberType ?? "nil")")
        }
        let rawState = fragment.enumRawValue("state")
        guard let state = rawState.flatMap(PhoneNumberState.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneNumberState: \(rawState ?? "nil")")
        }
        let failureReason = try fragment.enumRawValue("failureReason").map { raw -> PhoneNumberFailureReason in
            guard let reason = PhoneNumberFailureReason(rawValue: raw) else {
                throw SudoTelephonyError.internalError("Unknown PhoneNumberFailureReason: \(raw)")
            }
            return reason
        }
        return PhoneNumber(
            id: fragment.id,
            owner: fragment.owner,
            owners: fragment.owners.map { Owner(id: $0.id, issuer: $0.issuer) },
            identityId: fragment.identityId,
            keyRingId: fragment.keyRingId,
            keyIds: fragment.keyIds,
            phoneNumber: fragment.phoneNumber,
            countryCode: fragment.countryCode,
            numberType: numberType,
            areaCode: fragment.areaCode,
            state: state,
            failureReason: failureReason,
            gracePeriodEndsAt: fragment.gracePeriodEndsAtEpochMs.map(Date.init(epochMs:)),
            clientRefId: fragment.clientRefId,
            version: fragment.version,
            createdAt: Date(epochMs: fragment.createdAtEpochMs),
            updatedAt: Date(epochMs: fragment.updatedAtEpochMs)
        )
    }

    /// Transform an available-number search result row into the public type.
    static func transform(
        _ result: GraphQL.AvailablePhoneNumberFields
    ) throws -> AvailablePhoneNumber {
        let rawNumberType = result.enumRawValue("numberType")
        guard let numberType = rawNumberType.flatMap(PhoneNumberType.init(rawValue:)) else {
            throw SudoTelephonyError.internalError("Unknown PhoneNumberType: \(rawNumberType ?? "nil")")
        }
        return AvailablePhoneNumber(
            phoneNumber: result.phoneNumber,
            countryCode: result.countryCode,
            numberType: numberType,
            locality: result.locality,
            region: result.region
        )
    }

    /// Transform a search response into the public search result.
    static func transform(
        _ search: GraphQL.PhoneNumberSearchFields
    ) throws -> PhoneNumberSearchResult {
        try PhoneNumberSearchResult(
            id: search.id,
            countryCode: search.countryCode,
            areaCode: search.areaCode,
            results: search.results.map { try transform($0.fragments.availablePhoneNumberFields) },
            expiresAt: Date(epochMs: search.expiresAtEpochMs)
        )
    }

    /// Transform a list connection into the public page type.
    static func transform(
        items: [GraphQL.PhoneNumberFields],
        nextToken: String?
    ) throws -> ListOutput<PhoneNumber> {
        try ListOutput(
            items: items.map { try transform($0) },
            nextToken: nextToken
        )
    }
}
