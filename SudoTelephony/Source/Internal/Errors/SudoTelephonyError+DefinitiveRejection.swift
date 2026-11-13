//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoTelephonyCommon

extension SudoTelephonyError {

    /// Whether a transport error proves the service did not carry out the request.
    ///
    /// Decided from the raw error, before `fromApiOperationError(_:)` maps it. The
    /// mapping also recognises some errors from the wording of their message (for
    /// example reporting an unclassified GraphQL error that says "required" as
    /// `.invalidArgument`), which helps callers but proves nothing about whether the
    /// service acted. So only typed failures qualify: those `SudoApiClient` classifies
    /// itself, and GraphQL errors whose `errorType` is a telephony rejection.
    /// Anything that could follow a request the service accepted (a transport
    /// failure, an internal or unclassified service error) doesn't, so callers keep
    /// state such as a provisioning key rather than discard it for a number that may
    /// exist.
    ///
    /// - Parameter error: The error thrown by `SudoApiClient`, before mapping.
    /// - Returns: `true` if the service, or the client before sending, refused the request.
    static func isDefinitiveRejection(_ error: Error) -> Bool {
        guard let apiError = error as? ApiOperationError else {
            return false
        }
        switch apiError {
        case .notSignedIn,
             .notAuthorized,
             .insufficientEntitlements,
             .invalidArgument,
             .invalidRequest,
             .limitExceeded,
             .rateLimitExceeded,
             .accountLocked,
             .versionMismatch:
            return true
        case .graphQLError(let cause):
            guard let rejection = fromServiceErrorType(serviceErrorType(from: cause)) else {
                return false
            }
            return rejection != .serviceError
        default:
            return false
        }
    }
}
