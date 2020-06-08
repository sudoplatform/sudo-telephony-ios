//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Errors for the calling feature
public enum CallingError: Error, LocalizedError {
    /// Not permitted to access the microphone
    case recordPermissionNotGranted
    /// CXStartCallAction failed
    case startCallActionFailed(Error)
    /// Failed to authorize outgoing call
    case failedToAuthorizeOutgoingCall(SudoTelephonyClientError?)

    public var errorDescription: String? {
        switch self {
        case .recordPermissionNotGranted:
            return "Not permitted to access the microphone"
        case .startCallActionFailed:
            return "CXStartCallAction failed"
        case .failedToAuthorizeOutgoingCall(let underlyingError): return underlyingError?.errorDescription
        }
    }
}

/// Calling configuration errors
public enum CallConfigurationError: Error {
    /// CallProviderConfiguration not provided.
    case missingCallProviderConfiguration
}

