//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The single error type surfaced from the public `SudoTelephonyClient` surface.
///
/// Consumers should switch over these cases rather than inspecting lower-level
/// Amplify or Apollo error types, which are never exposed by the SDK.
public enum SudoTelephonyError: Error, Equatable, LocalizedError, Sendable {

    // MARK: - Client

    /// The supplied argument was invalid. The associated value carries an optional
    /// human-readable explanation.
    case invalidArgument(_ msg: String?)

    /// The SDK could not locate its service configuration (the service stanza in
    /// `sudoplatformconfig.json`).
    case invalidConfig

    /// No user is currently signed in.
    case notSignedIn

    // MARK: - Service: platform

    /// The user's session is no longer authorized, for example because it expired and
    /// couldn't be refreshed. Sign in again.
    case notAuthorized

    /// The account is not entitled to perform the operation, for example because it
    /// already holds as many phone numbers as it may.
    case insufficientEntitlements

    /// A Sudo ownership proof was missing, invalid, or didn't name exactly one Sudo.
    /// Deployments that require Sudo ownership reject provisioning without one.
    case invalidToken

    /// Too many items were requested or changed at once, or requests were made too
    /// quickly.
    case limitExceeded

    /// The user's account is locked.
    case accountLocked

    /// The record changed since it was read. Fetch it again and retry.
    case versionMismatch

    // MARK: - Service: telephony

    /// The country isn't one the deployment can search for numbers in. See
    /// `getSupportedCountries()`.
    case unsupportedCountry

    /// The area code isn't a three-digit area code in use in the country.
    case invalidAreaCode

    /// The user's token has no identity ID, which provisioning needs. The user's
    /// registration may be incomplete.
    case identityContextMissing

    /// The search to provision from doesn't exist, belongs to another user, or has
    /// expired. Search again.
    case phoneNumberSearchExpired

    /// The number to provision wasn't one of the search's results.
    case phoneNumberNotInSearch

    /// The number to provision is already held, or being provisioned, by someone else.
    case phoneNumberUnavailable

    /// No phone number with that ID belongs to the user.
    case phoneNumberNotFound

    /// The phone number's state doesn't allow the operation, for example releasing a
    /// number that is still provisioning.
    case invalidPhoneNumberState

    /// The service rejected the request or returned an unexpected failure.
    case serviceError

    // MARK: - Common

    /// Sealed content couldn't be unsealed, usually because this device doesn't have
    /// the key it was sealed to. Importing a key archive from the device that has it
    /// fixes this. The associated value carries an optional underlying cause.
    case unsealingFailed(_ cause: String?)

    /// The service response was missing data the SDK required to build a result.
    case noResultError

    /// An unexpected internal failure occurred. The associated value carries an
    /// optional underlying cause.
    case internalError(_ cause: String?)

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .invalidArgument(let msg):
            return msg ?? "An invalid argument was supplied."
        case .invalidConfig:
            return "The telephony service configuration could not be found."
        case .notSignedIn:
            return "No user is currently signed in."
        case .notAuthorized:
            return "Your session is no longer authorized. Sign in again."
        case .insufficientEntitlements:
            return "The account is not entitled to perform this operation."
        case .invalidToken:
            return "The Sudo ownership proof is missing or couldn't be verified."
        case .limitExceeded:
            return "Too many items were requested at once. Try again with fewer."
        case .accountLocked:
            return "The account is locked."
        case .versionMismatch:
            return "The record changed since it was read. Fetch it again and retry."
        case .unsupportedCountry:
            return "Phone numbers aren't available in this country."
        case .invalidAreaCode:
            return "That area code isn't in use in this country."
        case .identityContextMissing:
            return "The account's registration is incomplete, so a phone number can't be provisioned."
        case .phoneNumberSearchExpired:
            return "The search has expired. Search again."
        case .phoneNumberNotInSearch:
            return "That number wasn't one of the search results."
        case .phoneNumberUnavailable:
            return "That number is no longer available. Choose another."
        case .phoneNumberNotFound:
            return "The phone number could not be found."
        case .invalidPhoneNumberState:
            return "The phone number's state doesn't allow this."
        case .serviceError:
            return "The telephony service returned an error."
        case .unsealingFailed:
            return "The content couldn't be decrypted on this device."
        case .noResultError:
            return "The service response did not contain the expected data."
        case .internalError(let cause):
            return cause ?? "An unexpected internal error occurred."
        }
    }
}
