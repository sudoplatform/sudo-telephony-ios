//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The kind of phone number.
public enum PhoneNumberType: String, Equatable, Sendable, Codable {

    /// A geographic number tied to an area code.
    case local = "LOCAL"
}

/// The lifecycle state of a provisioned phone number.
///
/// The usual progression is `provisioning → active ⇄ suspended → released`, or
/// `provisioning → failed`.
public enum PhoneNumberState: String, Equatable, Sendable, Codable {

    /// The carrier order is in progress.
    case provisioning = "PROVISIONING"

    /// The number is active and receives messages.
    case active = "ACTIVE"

    /// A grace period: the number still receives messages but is pending release.
    case suspended = "SUSPENDED"

    /// The number has been returned to the carrier.
    case released = "RELEASED"

    /// Provisioning failed. Inspect `PhoneNumber.failureReason` for the cause.
    case failed = "FAILED"
}

/// The reason provisioning a phone number failed.
public enum PhoneNumberFailureReason: String, Equatable, Sendable, Codable {

    /// The number was taken by someone else after the search returned it.
    case numberUnavailable = "NUMBER_UNAVAILABLE"

    /// The carrier rejected or failed the order.
    case carrierError = "CARRIER_ERROR"
}

/// A phone number that a search found available to provision.
public struct AvailablePhoneNumber: Equatable, Sendable {

    /// The number in E.164 format, for example `+14155550123`.
    public let phoneNumber: String

    /// ISO 3166-1 alpha-2 country code of the number, for example `US`.
    public let countryCode: String

    /// The kind of number.
    public let numberType: PhoneNumberType

    /// City or rate centre of the number, if the carrier reports one.
    public let locality: String?

    /// State or province code of the number, for example `NY` or `ON`.
    public let region: String?

    /// Create an available phone number.
    public init(
        phoneNumber: String,
        countryCode: String,
        numberType: PhoneNumberType,
        locality: String?,
        region: String?
    ) {
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.numberType = numberType
        self.locality = locality
        self.region = region
    }
}

/// The result of a phone number search.
///
/// The search is kept for 15 minutes so provisioning can confirm the requested
/// number came from it. The carrier does not reserve the numbers, so a result can
/// be taken by someone else before `expiresAtEpochMs`.
public struct PhoneNumberSearchResult: Equatable, Sendable {

    /// ID of the search. Pass it as `searchId` when provisioning.
    public let id: String

    /// ISO 3166-1 alpha-2 country code that was searched.
    public let countryCode: String

    /// Area code that was searched. Null for a country-wide search.
    public let areaCode: String?

    /// The available numbers, without duplicates and at most the requested limit.
    public let results: [AvailablePhoneNumber]

    /// Time in milliseconds since the Unix epoch after which provisioning from this
    /// search is refused.
    public let expiresAtEpochMs: Double

    /// Create a phone number search result.
    public init(
        id: String,
        countryCode: String,
        areaCode: String?,
        results: [AvailablePhoneNumber],
        expiresAtEpochMs: Double
    ) {
        self.id = id
        self.countryCode = countryCode
        self.areaCode = areaCode
        self.results = results
        self.expiresAtEpochMs = expiresAtEpochMs
    }
}

/// A phone number provisioned for a user.
public struct PhoneNumber: Equatable, Sendable {

    /// ID of the phone number.
    public let id: String

    /// The number in E.164 format, for example `+14155550123`.
    public let phoneNumber: String

    /// ISO 3166-1 alpha-2 country code of the number, for example `US`.
    public let countryCode: String

    /// The kind of number.
    public let numberType: PhoneNumberType

    /// Area code of the number. Null where the country has no area codes.
    public let areaCode: String?

    /// The lifecycle state of the number.
    public let state: PhoneNumberState

    /// Why provisioning failed, set only when `state` is `.failed`.
    public let failureReason: PhoneNumberFailureReason?

    /// Time in milliseconds since the Unix epoch when the suspension grace period
    /// ends. Set only while `state` is `.suspended`.
    public let gracePeriodEndsAtEpochMs: Double?

    /// An optional caller-supplied reference string set at provisioning time.
    public let clientRefId: String?

    /// What owns the number besides the user, for example the Sudo whose ownership proof
    /// it was provisioned with. Empty for a number provisioned without a proof.
    public let owners: [Owner]

    /// Time in milliseconds since the Unix epoch when the number was created.
    public let createdAtEpochMs: Double

    /// Time in milliseconds since the Unix epoch when the number was last updated.
    public let updatedAtEpochMs: Double

    /// Create a phone number.
    public init(
        id: String,
        phoneNumber: String,
        countryCode: String,
        numberType: PhoneNumberType,
        areaCode: String?,
        state: PhoneNumberState,
        failureReason: PhoneNumberFailureReason?,
        gracePeriodEndsAtEpochMs: Double?,
        clientRefId: String?,
        owners: [Owner],
        createdAtEpochMs: Double,
        updatedAtEpochMs: Double
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.numberType = numberType
        self.areaCode = areaCode
        self.state = state
        self.failureReason = failureReason
        self.gracePeriodEndsAtEpochMs = gracePeriodEndsAtEpochMs
        self.clientRefId = clientRefId
        self.owners = owners
        self.createdAtEpochMs = createdAtEpochMs
        self.updatedAtEpochMs = updatedAtEpochMs
    }
}

/// A page of provisioned phone numbers.
public struct PhoneNumberListToken: Equatable, Sendable {

    /// The phone numbers in this page.
    public let items: [PhoneNumber]

    /// An opaque token to fetch the next page, or `nil` when there are no more.
    public let nextToken: String?

    /// Create a page of phone numbers.
    public init(items: [PhoneNumber], nextToken: String?) {
        self.items = items
        self.nextToken = nextToken
    }
}
