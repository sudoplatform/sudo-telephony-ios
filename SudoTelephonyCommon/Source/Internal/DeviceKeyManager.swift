//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// A public key the SDK generated on the device and will register with the service
/// so inbound messages are sealed to it.
public struct RegisteredPublicKey: Equatable, Sendable {

    /// The client-generated key identifier. The service echoes it back on sealed
    /// messages as `keyId`, and it names the key pair in the key store for unsealing.
    public let keyId: String

    /// The sealing algorithm the service should use, for example
    /// `RSAEncryptionOAEPAESGCM`.
    public let algorithm: String

    /// The encoding of `publicKey`. `RSA_PUBLIC_KEY` (PKCS#1) or `SPKI`.
    public let keyFormat: PublicKeyFormat

    /// The base64-encoded public key bytes.
    public let publicKey: String

    /// Create a registered public key descriptor.
    public init(keyId: String, algorithm: String, keyFormat: PublicKeyFormat, publicKey: String) {
        self.keyId = keyId
        self.algorithm = algorithm
        self.keyFormat = keyFormat
        self.publicKey = publicKey
    }
}

/// The encoding of a registered public key. Mirrors the service's `KeyFormat` enum.
public enum PublicKeyFormat: String, Equatable, Sendable {

    /// PKCS#1 RSA public key.
    case rsaPublicKey = "RSA_PUBLIC_KEY"

    /// X.509 SubjectPublicKeyInfo.
    case spki = "SPKI"
}

/// On-device key management and unsealing for the telephony SDK.
///
/// This is the seam over `SudoKeyManager`. Core/data code depends on this protocol,
/// not on `SudoKeyManager` directly, so repositories and use cases stay unit-testable
/// with a mock and the concrete crypto is wired at the composition root.
public protocol DeviceKeyManager: Sendable {

    /// Generate a new RSA key pair for sealing a phone number's messages and return
    /// the public half to register with the service.
    ///
    /// The private half is stored under `keyId` and used later to unseal.
    ///
    /// - Returns: The registered public key descriptor to send when provisioning.
    /// - Throws: `SudoTelephonyError` if key generation fails.
    func generateKeyPair() throws -> RegisteredPublicKey

    /// Unseal a base64 `RSAEncryptionOAEPAESGCM` envelope sealed to the key pair named
    /// by `keyId`, returning the plaintext string.
    ///
    /// The envelope is `[RSA-OAEP-sealed AES key][AES-GCM-sealed payload]`: the first
    /// RSA block is decrypted with the private key to recover the AES key, which then
    /// decrypts the remainder (`[nonce][ciphertext][tag]`).
    ///
    /// - Parameters:
    ///   - sealed: The base64-encoded sealed value.
    ///   - keyId: The key pair the value was sealed to.
    ///   - algorithm: The sealing algorithm reported by the service.
    /// - Returns: The decrypted UTF-8 string.
    /// - Throws: `SudoTelephonyError` if the value cannot be unsealed.
    func unsealString(_ sealed: String, withKeyId keyId: String, algorithm: String) throws -> String

    /// Remove every key this SDK holds in the key store.
    ///
    /// Used to tear down local key material when the user resets or signs out. The
    /// SDK does not delete per-number keys on deprovision, matching the platform
    /// convention that key lifetime is tied to the key ring, not individual objects.
    ///
    /// - Throws: `SudoTelephonyError` if the removal fails.
    func removeAllKeys() throws

    /// Export the SDK's cryptographic keys to a portable key archive.
    ///
    /// The archive lets the user move their message-sealing keys to another device
    /// (or restore them after a reinstall), so retained sealed messages stay readable.
    /// Public keys are excluded to limit the archive size.
    ///
    /// - Returns: The serialized key archive. It contains private key material and
    ///   must be stored securely by the caller.
    /// - Throws: `SudoTelephonyError` if the export fails.
    func exportKeys() throws -> Data

    /// Import cryptographic keys from a key archive produced by `exportKeys()`.
    ///
    /// Existing keys are removed before the archive is restored.
    ///
    /// - Parameter archiveData: The key archive to import.
    /// - Throws: `SudoTelephonyError` if the archive is invalid or the import fails.
    func importKeys(archiveData: Data) throws
}
