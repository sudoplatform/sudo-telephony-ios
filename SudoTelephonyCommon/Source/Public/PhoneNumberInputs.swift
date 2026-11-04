//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Input for searching the carrier for available phone numbers.
public struct SearchAvailablePhoneNumbersInput: Equatable, Sendable {

    /// ISO 3166-1 alpha-2 country code to search. Must be one of the values returned
    /// by `getSupportedCountries()`.
    public let countryCode: String

    /// Three-digit area code to narrow the search.
    ///
    /// Currently required by the service: a search without an area code is rejected
    /// with `SudoTelephonyError.invalidArgument`, and an unrecognised area code is
    /// also rejected. The field is nullable in the contract for countries or future
    /// deployments that allow a country-wide search, but supply it for the
    /// deployments in service today.
    public let areaCode: String?

    /// Maximum number of results. The service default is 10 and the maximum is 20.
    public let limit: Int?

    /// Create a search input.
    public init(countryCode: String, areaCode: String? = nil, limit: Int? = nil) {
        self.countryCode = countryCode
        self.areaCode = areaCode
        self.limit = limit
    }
}

/// Input for provisioning a phone number from a prior search.
///
/// The SDK generates the RSA key pair that the number's inbound messages are sealed
/// to and registers its public half automatically, so key material is not part of
/// this input.
public struct ProvisionPhoneNumberInput: Equatable, Sendable {

    /// ID of the caller's own, unexpired search that returned the number.
    public let searchId: String

    /// The number to provision, in E.164 format. Must be one of the search results.
    public let phoneNumber: String

    /// Proofs that the caller owns the Sudo the number will belong to. Required only
    /// in deployments that enforce Sudo ownership; when given, must include exactly
    /// one proof issued by the Sudo service.
    ///
    /// Get the proof from SudoProfiles with the audience
    /// `"sudoplatform.telephony.phone-number"`, for example
    /// `getOwnershipProof(sudoId:audience:)`. The provisioned number's `owners` then
    /// include the Sudo.
    public let ownershipProofTokens: [String]?

    /// An optional caller-supplied reference string stored with the number. Repeating
    /// a request with the same value returns the number the first request
    /// provisioned, without provisioning another.
    public let clientRefId: String?

    /// Create a provision input.
    public init(
        searchId: String,
        phoneNumber: String,
        ownershipProofTokens: [String]? = nil,
        clientRefId: String? = nil
    ) {
        self.searchId = searchId
        self.phoneNumber = phoneNumber
        self.ownershipProofTokens = ownershipProofTokens
        self.clientRefId = clientRefId
    }
}

/// Input for listing a user's provisioned phone numbers.
public struct ListPhoneNumbersInput: Equatable, Sendable {

    /// Maximum number of numbers to return in the page.
    public let limit: Int?

    /// An opaque token from a prior page, to fetch the next page.
    public let nextToken: String?

    /// Create a list input.
    public init(limit: Int? = nil, nextToken: String? = nil) {
        self.limit = limit
        self.nextToken = nextToken
    }
}
