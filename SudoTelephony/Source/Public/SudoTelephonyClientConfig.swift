//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Options that change how a `DefaultSudoTelephonyClient` behaves.
public struct SudoTelephonyClientConfig: Equatable, Sendable {

    // MARK: - Properties

    /// Whether every phone number is provisioned with one shared key pair instead of
    /// a key pair of its own.
    ///
    /// When `true`, every number is registered with a single key pair, which the app
    /// creates by calling `createSingletonKeysIfAbsent()` before provisioning. The
    /// client never creates it itself: provisioning without it throws
    /// `SudoTelephonyError.singletonKeyPairNotFound`. It is never removed when a
    /// number is deprovisioned or fails to provision; only `reset()` removes it.
    ///
    /// Messages are still sealed, but every number's messages are sealed to the same
    /// key, so all numbers can be read with that one key. Apps that don't need
    /// numbers kept cryptographically separate from one another can use this to keep
    /// key management and key export / import simple.
    ///
    /// When `false` (the default), each number gets its own key pair, which is
    /// removed from the device when the number is deprovisioned or when the service
    /// rejects its provisioning.
    public let enforceSingletonKeyPair: Bool

    // MARK: - Lifecycle

    /// Create a client configuration.
    ///
    /// - Parameter enforceSingletonKeyPair: Whether every phone number shares one
    ///   key pair. Defaults to `false`.
    public init(enforceSingletonKeyPair: Bool = false) {
        self.enforceSingletonKeyPair = enforceSingletonKeyPair
    }
}
