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
/// be taken by someone else before `expiresAt`.
public struct PhoneNumberSearchResult: Equatable, Sendable {

    /// ID of the search. Pass it as `searchId` when provisioning.
    public let id: String

    /// ISO 3166-1 alpha-2 country code that was searched.
    public let countryCode: String

    /// Area code that was searched. Null for a country-wide search.
    public let areaCode: String?

    /// The available numbers, without duplicates and at most the requested limit.
    public let results: [AvailablePhoneNumber]

    /// When provisioning from this search stops being accepted.
    public let expiresAt: Date

    /// Create a phone number search result.
    public init(
        id: String,
        countryCode: String,
        areaCode: String?,
        results: [AvailablePhoneNumber],
        expiresAt: Date
    ) {
        self.id = id
        self.countryCode = countryCode
        self.areaCode = areaCode
        self.results = results
        self.expiresAt = expiresAt
    }
}

/// A phone number provisioned for a user.
///
/// The user always owns the number (`owner`). If it was provisioned with a Sudo
/// ownership proof, the Sudo owns it too, and is listed in `owners` and returned
/// by `sudoId`.
public struct PhoneNumber: Equatable, Sendable {

    /// ID of the phone number.
    public let id: String

    /// The user who owns the number: their subject.
    public let owner: String

    /// What else owns the number, for example the Sudo whose ownership proof it was
    /// provisioned with. Empty for a number provisioned without a proof.
    public let owners: [Owner]

    /// ID of the user's identity, which the number's message keys are registered to.
    public let identityId: String

    /// ID of the key ring holding the number's message keys.
    public let keyRingId: String

    /// IDs of the keys the number's inbound messages are sealed to.
    public let keyIds: [String]

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

    /// When the suspension grace period ends. Set only while `state` is `.suspended`.
    public let gracePeriodEndsAt: Date?

    /// An optional caller-supplied reference string set at provisioning time.
    public let clientRefId: String?

    /// Version of the record, increased on each change.
    public let version: Int

    /// When the number was created.
    public let createdAt: Date

    /// When the number was last updated.
    public let updatedAt: Date

    /// ID of the Sudo that owns the number, or `nil` if it was provisioned without
    /// a Sudo ownership proof.
    public var sudoId: String? {
        owners.sudoId
    }

    /// Create a phone number.
    public init(
        id: String,
        owner: String,
        owners: [Owner],
        identityId: String,
        keyRingId: String,
        keyIds: [String],
        phoneNumber: String,
        countryCode: String,
        numberType: PhoneNumberType,
        areaCode: String?,
        state: PhoneNumberState,
        failureReason: PhoneNumberFailureReason?,
        gracePeriodEndsAt: Date?,
        clientRefId: String?,
        version: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.owner = owner
        self.owners = owners
        self.identityId = identityId
        self.keyRingId = keyRingId
        self.keyIds = keyIds
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.numberType = numberType
        self.areaCode = areaCode
        self.state = state
        self.failureReason = failureReason
        self.gracePeriodEndsAt = gracePeriodEndsAt
        self.clientRefId = clientRefId
        self.version = version
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
