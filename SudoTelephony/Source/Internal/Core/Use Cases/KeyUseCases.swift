//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Creates the keys the client needs if this device doesn't have them.
final class CreateSingletonKeysIfAbsentUseCase {

    // MARK: - Properties

    private let deviceKeyManager: DeviceKeyManager
    private let enforceSingletonKeyPair: Bool

    // MARK: - Lifecycle

    /// Create the use case.
    ///
    /// - Parameters:
    ///   - deviceKeyManager: The on-device key store.
    ///   - enforceSingletonKeyPair: Whether the client enforces a singleton key pair.
    init(deviceKeyManager: DeviceKeyManager, enforceSingletonKeyPair: Bool) {
        self.deviceKeyManager = deviceKeyManager
        self.enforceSingletonKeyPair = enforceSingletonKeyPair
    }

    // MARK: - Methods

    /// Execute the operation.
    ///
    /// - Returns: Whether the singleton key pair was created, and its ID.
    /// - Throws: `SudoTelephonyError.invalidConfig` if the client doesn't enforce a
    ///   singleton key pair, since each number then gets its own key when it is
    ///   provisioned; otherwise `SudoTelephonyError` if the key can't be created.
    func execute() async throws -> CreateSingletonKeysIfAbsentResult {
        guard enforceSingletonKeyPair else {
            throw SudoTelephonyError.invalidConfig
        }
        return try CreateSingletonKeysIfAbsentResult(keyPair: deviceKeyManager.createSingletonKeyPairIfAbsent())
    }
}
