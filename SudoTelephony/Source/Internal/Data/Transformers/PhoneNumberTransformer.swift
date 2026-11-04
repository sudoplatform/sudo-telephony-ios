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
    static func transform(_ fragment: GraphQL.PhoneNumberFragment) throws -> PhoneNumber {
        guard let numberType = PhoneNumberType(rawValue: fragment.numberType) else {
            throw SudoTelephonyError.internalError("Unknown PhoneNumberType: \(fragment.numberType)")
        }
        guard let state = PhoneNumberState(rawValue: fragment.state) else {
            throw SudoTelephonyError.internalError("Unknown PhoneNumberState: \(fragment.state)")
        }
        let failureReason = try fragment.failureReason.map { raw -> PhoneNumberFailureReason in
            guard let reason = PhoneNumberFailureReason(rawValue: raw) else {
                throw SudoTelephonyError.internalError("Unknown PhoneNumberFailureReason: \(raw)")
            }
            return reason
        }
        return PhoneNumber(
            id: fragment.id,
            phoneNumber: fragment.phoneNumber,
            countryCode: fragment.countryCode,
            numberType: numberType,
            areaCode: fragment.areaCode,
            state: state,
            failureReason: failureReason,
            gracePeriodEndsAtEpochMs: fragment.gracePeriodEndsAtEpochMs,
            clientRefId: fragment.clientRefId,
            owners: fragment.owners.map { Owner(id: $0.id, issuer: $0.issuer) },
            createdAtEpochMs: fragment.createdAtEpochMs,
            updatedAtEpochMs: fragment.updatedAtEpochMs
        )
    }

    /// Transform an available-number search result row into the public type.
    static func transform(
        _ result: GraphQL.SearchAvailablePhoneNumbersQuery.Data.Search.Result
    ) throws -> AvailablePhoneNumber {
        guard let numberType = PhoneNumberType(rawValue: result.numberType) else {
            throw SudoTelephonyError.internalError("Unknown PhoneNumberType: \(result.numberType)")
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
        _ search: GraphQL.SearchAvailablePhoneNumbersQuery.Data.Search
    ) throws -> PhoneNumberSearchResult {
        try PhoneNumberSearchResult(
            id: search.id,
            countryCode: search.countryCode,
            areaCode: search.areaCode,
            results: search.results.map { try transform($0) },
            expiresAtEpochMs: search.expiresAtEpochMs
        )
    }

    /// Transform a list connection into the public page type.
    static func transform(
        items: [GraphQL.PhoneNumberFragment],
        nextToken: String?
    ) throws -> PhoneNumberListToken {
        try PhoneNumberListToken(
            items: items.map { try transform($0) },
            nextToken: nextToken
        )
    }
}
