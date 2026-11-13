//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation
import SudoApiClient
import SudoTelephonyCommon

extension SudoTelephonyError {

    /// Map a transport-level error into the public SDK error type.
    ///
    /// This is the single mapping site; it is applied centrally by
    /// `SudoApiGraphQLExecutor` so repositories never translate errors inline. An
    /// error that is already a `SudoTelephonyError` (for example from a transformer)
    /// passes through unchanged.
    ///
    /// Note on explanations: when the service classifies a validation failure as
    /// `InvalidArgumentError`, `SudoApiClient` surfaces a bare `.invalidArgument`
    /// without the service's message, so the SDK cannot recover that text. When the
    /// service returns an unclassified GraphQL error, its message does survive in the
    /// `.graphQLError` cause and is preserved here.
    ///
    /// - Parameter error: The error to map.
    /// - Returns: The corresponding `SudoTelephonyError`.
    static func fromApiOperationError(_ error: Error) -> SudoTelephonyError {
        if let sdkError = error as? SudoTelephonyError {
            return sdkError
        }
        guard let apiError = error as? ApiOperationError else {
            return .internalError("\(error)")
        }
        switch apiError {
        case .notSignedIn:
            return .notSignedIn
        case .notAuthorized:
            return .notAuthorized
        case .insufficientEntitlements:
            return .insufficientEntitlements
        case .invalidArgument, .invalidRequest:
            return .invalidArgument(nil)
        case .limitExceeded, .rateLimitExceeded:
            return .limitExceeded
        case .accountLocked:
            return .accountLocked
        case .versionMismatch:
            return .versionMismatch
        case .serviceError, .preconditionFailure:
            return .serviceError
        case .graphQLError(let cause):
            if let error = fromServiceErrorType(serviceErrorType(from: cause)) {
                return error
            }
            // An unclassified GraphQL error keeps the service's human-readable
            // message; surface it rather than discarding it. A message mentioning an
            // argument (e.g. a required area code) is reported as `.invalidArgument`
            // so callers can distinguish bad input from a service fault.
            let message = serviceMessage(from: cause)
            if let message, indicatesInvalidArgument(message) {
                return .invalidArgument(message)
            }
            return .internalError(message ?? "\(cause)")
        case .requestFailed(_, let cause):
            return .internalError(cause.map { "\($0)" })
        case .appSyncClientError(let cause):
            return .internalError("\(cause)")
        case .fatalError(let description):
            return .internalError(description)
        default:
            return .internalError("\(apiError)")
        }
    }

    /// The SDK error for an error type the service returns that `SudoApiClient`
    /// doesn't classify itself, or `nil` if it isn't one the SDK knows.
    static func fromServiceErrorType(_ errorType: String?) -> SudoTelephonyError? {
        switch errorType {
        case ServiceErrorType.invalidToken:
            return .invalidToken
        case ServiceErrorType.noEntitlements:
            return .insufficientEntitlements
        case ServiceErrorType.unsupportedCountry:
            return .unsupportedCountry
        case ServiceErrorType.invalidAreaCode:
            return .invalidAreaCode
        case ServiceErrorType.identityContextMissing:
            return .identityContextMissing
        case ServiceErrorType.phoneNumberSearchExpired:
            return .phoneNumberSearchExpired
        case ServiceErrorType.phoneNumberNotInSearch:
            return .phoneNumberNotInSearch
        case ServiceErrorType.phoneNumberUnavailable:
            return .phoneNumberUnavailable
        case ServiceErrorType.phoneNumberNotFound:
            return .phoneNumberNotFound
        case ServiceErrorType.invalidPhoneNumberState:
            return .invalidPhoneNumberState
        case ServiceErrorType.supportedCountriesUnavailable:
            return .serviceError
        default:
            return nil
        }
    }

    /// Error types from the telephony service (`src/util/errors.ts`) and the
    /// platform errors it uses that `SudoApiClient` passes through unclassified.
    enum ServiceErrorType {
        static let invalidToken = "sudoplatform.InvalidTokenError"
        static let noEntitlements = "sudoplatform.NoEntitlementsError"
        static let unsupportedCountry = "sudoplatform.telephony.UnsupportedCountry"
        static let invalidAreaCode = "sudoplatform.telephony.InvalidAreaCode"
        static let identityContextMissing = "sudoplatform.telephony.IdentityContextMissing"
        static let phoneNumberSearchExpired = "sudoplatform.telephony.PhoneNumberSearchExpired"
        static let phoneNumberNotInSearch = "sudoplatform.telephony.PhoneNumberNotInSearch"
        static let phoneNumberUnavailable = "sudoplatform.telephony.PhoneNumberUnavailable"
        static let phoneNumberNotFound = "sudoplatform.telephony.PhoneNumberNotFound"
        static let invalidPhoneNumberState = "sudoplatform.telephony.InvalidPhoneNumberState"
        static let supportedCountriesUnavailable = "sudoplatform.telephony.SupportedCountriesUnavailable"
    }

    /// The service's error type from a GraphQL error cause, if any.
    static func serviceErrorType(from cause: Error) -> String? {
        (cause as? GraphQLError)?.extensions?["errorType"]?.stringValue
    }

    /// The service's human-readable message from a GraphQL error cause, if any.
    private static func serviceMessage(from cause: Error) -> String? {
        if let graphQLError = cause as? GraphQLError {
            return graphQLError.message
        }
        return nil
    }

    /// Whether a service message describes an invalid-argument condition.
    private static func indicatesInvalidArgument(_ message: String) -> Bool {
        let lowered = message.lowercased()
        return lowered.contains("invalid argument")
            || lowered.contains("area code")
            || lowered.contains("required")
    }
}
