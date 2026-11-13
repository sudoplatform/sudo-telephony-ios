//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The result of `SudoTelephonyClient.createSingletonKeysIfAbsent()`.
public struct CreateSingletonKeysIfAbsentResult: Equatable, Sendable {

    // MARK: - Supplementary

    /// The outcome for one key.
    public struct KeyResult: Equatable, Sendable {

        /// Whether the key had to be created. `true` means the device's key material
        /// changed, so a key backup made before this call doesn't contain it.
        public let created: Bool

        /// The key's identifier.
        public let keyId: String

        /// Create a key result.
        public init(created: Bool, keyId: String) {
            self.created = created
            self.keyId = keyId
        }
    }

    // MARK: - Properties

    /// The singleton key pair every phone number is sealed to.
    public let keyPair: KeyResult

    // MARK: - Lifecycle

    /// Create a result.
    public init(keyPair: KeyResult) {
        self.keyPair = keyPair
    }
}
