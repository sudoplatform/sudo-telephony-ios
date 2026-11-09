//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Maps the generated phone-number response types to the public domain types.
///
/// Pure and independently testable — it performs no I/O. An enum value the SDK doesn't
/// recognise maps to the enum's `unknown` case, carrying the value, so a value the
/// service adds later doesn't stop a number being read.
enum PhoneNumberTransformer {

    /// Transform a `PhoneNumber` fragment into the public `PhoneNumber`.
    static func transform(_ fragment: GraphQL.PhoneNumberFields) throws -> PhoneNumber {
        let numberType: PhoneNumberType = try fragment.enumValue("numberType")
        let state: PhoneNumberState = try fragment.enumValue("state")
        let failureReason: PhoneNumberFailureReason? = fragment.optionalEnumValue("failureReason")
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
        let numberType: PhoneNumberType = try result.enumValue("numberType")
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
