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

    /// No user is currently signed in, so the operation that requires an owner
    /// subject cannot proceed.
    case notSignedIn

    // MARK: - Service

    /// The account is not entitled to perform the operation.
    case insufficientEntitlements

    /// The service rejected the request or returned an unexpected failure.
    case serviceError

    // MARK: - Common

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
        case .insufficientEntitlements:
            return "The account is not entitled to perform this operation."
        case .serviceError:
            return "The telephony service returned an error."
        case .noResultError:
            return "The service response did not contain the expected data."
        case .internalError(let cause):
            return cause ?? "An unexpected internal error occurred."
        }
    }
}
