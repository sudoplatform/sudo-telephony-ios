//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The kind of phone number.
///
/// `unknown` carries a value that this version of the SDK doesn't recognise, for example one the service added after it was
/// released, so a number with a new type can still be read.
public enum PhoneNumberType: Hashable, Sendable {

    /// A geographic number tied to an area code.
    case local

    /// A type this version of the SDK doesn't recognise, with the value the service sent.
    case unknown(String)
}

extension PhoneNumberType: RawRepresentable, Codable {

    /// Create a number type from the service's value. An unrecognised value becomes `unknown`.
    public init(rawValue: String) {
        switch rawValue {
        case "LOCAL": self = .local
        default: self = .unknown(rawValue)
        }
    }

    /// The service's value for this number type.
    public var rawValue: String {
        switch self {
        case .local: "LOCAL"
        case .unknown(let rawValue): rawValue
        }
    }
}

/// The lifecycle state of a provisioned phone number.
///
/// The usual progression is `provisioning → active ⇄ suspended → released`, or `provisioning → failed`. `unknown` carries a
/// state that this version of the SDK doesn't recognise, so a number in a new state can still be read.
public enum PhoneNumberState: Hashable, Sendable {

    /// The carrier order is in progress.
    case provisioning

    /// The number is active and receives messages.
    case active

    /// A grace period: the number still receives messages but is pending release.
    case suspended

    /// The number has been returned to the carrier.
    case released

    /// Provisioning failed. Inspect `PhoneNumber.failureReason` for the cause.
    case failed

    /// A state this version of the SDK doesn't recognise, with the value the service sent.
    case unknown(String)
}

extension PhoneNumberState: RawRepresentable, Codable {

    /// Create a state from the service's value. An unrecognised value becomes `unknown`.
    public init(rawValue: String) {
        switch rawValue {
        case "PROVISIONING": self = .provisioning
        case "ACTIVE": self = .active
        case "SUSPENDED": self = .suspended
        case "RELEASED": self = .released
        case "FAILED": self = .failed
        default: self = .unknown(rawValue)
        }
    }

    /// The service's value for this state.
    public var rawValue: String {
        switch self {
        case .provisioning: "PROVISIONING"
        case .active: "ACTIVE"
        case .suspended: "SUSPENDED"
        case .released: "RELEASED"
        case .failed: "FAILED"
        case .unknown(let rawValue): rawValue
        }
    }
}

/// The reason provisioning a phone number failed.
///
/// `unknown` carries a reason that this version of the SDK doesn't recognise, so a failed number with a new reason can
/// still be read.
public enum PhoneNumberFailureReason: Hashable, Sendable {

    /// The number was taken by someone else after the search returned it.
    case numberUnavailable

    /// The carrier rejected or failed the order.
    case carrierError

    /// The Sudo or user that owned the number was deleted before its order was placed.
    case ownerDeleted

    /// A reason this version of the SDK doesn't recognise, with the value the service sent.
    case unknown(String)
}

extension PhoneNumberFailureReason: RawRepresentable, Codable {

    /// Create a failure reason from the service's value. An unrecognised value becomes `unknown`.
    public init(rawValue: String) {
        switch rawValue {
        case "NUMBER_UNAVAILABLE": self = .numberUnavailable
        case "CARRIER_ERROR": self = .carrierError
        case "OWNER_DELETED": self = .ownerDeleted
        default: self = .unknown(rawValue)
        }
    }

    /// The service's value for this failure reason.
    public var rawValue: String {
        switch self {
        case .numberUnavailable: "NUMBER_UNAVAILABLE"
        case .carrierError: "CARRIER_ERROR"
        case .ownerDeleted: "OWNER_DELETED"
        case .unknown(let rawValue): rawValue
        }
    }
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
