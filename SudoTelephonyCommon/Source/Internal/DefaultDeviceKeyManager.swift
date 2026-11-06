//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoKeyManager

/// `SudoKeyManager`-backed implementation of `DeviceKeyManager`.
///
/// Generates RSA key pairs for sealing a phone number's messages and unseals the
/// service's `RSAEncryptionOAEPAESGCM` envelopes. This is the single place that
/// imports `SudoKeyManager`; everything above it depends on the `DeviceKeyManager`
/// protocol.
public final class DefaultDeviceKeyManager: DeviceKeyManager, @unchecked Sendable {

    // MARK: - Constants

    private enum Defaults {
        /// The sealing algorithm the telephony service uses for message content.
        static let algorithm = "RSAEncryptionOAEPAESGCM"
        /// RSA block size in bytes for a 2048-bit key: the length of the sealed AES
        /// key prefix in the envelope.
        static let rsaBlockSize = 256
        /// Keychain service name for the SDK's key ring.
        static let keyRingServiceName = "sudo-telephony"
        /// Key manager tag used across the Sudo Platform.
        static let keyManagerKeyTag = "com.sudoplatform"
    }

    // MARK: - Properties

    private let keyManager: SudoKeyManager

    // MARK: - Lifecycle

    /// Create the device key manager for a key namespace.
    ///
    /// Constructs a `DefaultSudoKeyManager` internally. This is deliberate and required
    /// for correctness: the service seals message content with the
    /// `RSAEncryptionOAEPAESGCM` envelope, whose symmetric half is AES-GCM.
    /// `DefaultSudoKeyManager` performs AES-GCM for `decryptWithSymmetricKey`, whereas
    /// `LegacySudoKeyManager` performs AES-CBC and would fail to unseal every
    /// message. Taking a namespace rather than a `SudoKeyManager` keeps the caller
    /// from accidentally supplying the wrong implementation.
    ///
    /// - Parameter keyNamespace: Namespace isolating this SDK's keys in the keychain.
    public convenience init(keyNamespace: String) {
        let keyManager = DefaultSudoKeyManager(
            serviceName: Defaults.keyRingServiceName,
            keyTag: Defaults.keyManagerKeyTag,
            namespace: keyNamespace
        )
        self.init(keyManager: keyManager)
    }

    /// Create the device key manager over a configured `SudoKeyManager`.
    ///
    /// - Important: The key manager must perform AES-GCM for `decryptWithSymmetricKey`
    ///   (i.e. `DefaultSudoKeyManager`), to match the service's `RSAEncryptionOAEPAESGCM`
    ///   envelope. Prefer `init(keyNamespace:)`, which guarantees this; this
    ///   initialiser exists mainly to inject a mock in tests.
    ///
    /// - Parameter keyManager: The key store used for generation, storage, and
    ///   cryptographic operations.
    public init(keyManager: SudoKeyManager) {
        self.keyManager = keyManager
    }

    // MARK: - DeviceKeyManager

    public func generateKeyPair() throws -> RegisteredPublicKey {
        let keyId = UUID().uuidString
        do {
            try keyManager.generateKeyPair(keyId)
            guard let publicKey = try keyManager.getPublicKey(keyId) else {
                throw SudoTelephonyError.internalError("Public key missing after generation")
            }
            return RegisteredPublicKey(
                keyId: keyId,
                algorithm: Defaults.algorithm,
                keyFormat: .rsaPublicKey,
                publicKey: publicKey.base64EncodedString()
            )
        } catch let error as SudoTelephonyError {
            throw error
        } catch {
            throw SudoTelephonyError.internalError("Key pair generation failed: \(error)")
        }
    }

    public func unsealString(_ sealed: String, withKeyId keyId: String, algorithm: String) throws -> String {
        guard algorithm == Defaults.algorithm else {
            throw SudoTelephonyError.unsealingFailed("Unsupported sealing algorithm: \(algorithm)")
        }
        guard let payload = Data(base64Encoded: sealed) else {
            throw SudoTelephonyError.unsealingFailed("Sealed value is not valid base64")
        }
        guard payload.count > Defaults.rsaBlockSize else {
            throw SudoTelephonyError.unsealingFailed("Sealed value is too short to contain an envelope")
        }
        do {
            // The first RSA block is the AES key sealed to the public key; the
            // remainder is the AES-GCM payload in CryptoKit `combined` layout
            // ([nonce][ciphertext][tag]), which `decryptWithSymmetricKey` parses.
            let sealedKey = payload.subdata(in: 0 ..< Defaults.rsaBlockSize)
            let symmetricKey = try keyManager.decryptWithPrivateKey(
                keyId,
                data: sealedKey,
                algorithm: .rsaEncryptionOAEPSHA1
            )
            let cipherData = payload.subdata(in: Defaults.rsaBlockSize ..< payload.count)
            let plaintext = try keyManager.decryptWithSymmetricKey(symmetricKey, data: cipherData)
            guard let string = String(data: plaintext, encoding: .utf8) else {
                throw SudoTelephonyError.unsealingFailed("Unsealed value is not valid UTF-8")
            }
            return string
        } catch let error as SudoTelephonyError {
            throw error
        } catch {
            throw SudoTelephonyError.unsealingFailed("\(error)")
        }
    }

    public func removeAllKeys() throws {
        do {
            try keyManager.removeAllKeys()
        } catch {
            throw SudoTelephonyError.internalError("Removing keys failed: \(error)")
        }
    }

    public func exportKeys() throws -> Data {
        do {
            let archive = SecureKeyArchiveImpl(keyManager: keyManager, zip: true)
            // Exclude public keys to limit the archive size; they are re-derivable.
            archive.excludedKeyTypes = [KeyType.publicKey.rawValue]
            try archive.loadKeys()
            return try archive.archive(nil)
        } catch {
            throw SudoTelephonyError.internalError("Exporting keys failed: \(error)")
        }
    }

    public func importKeys(archiveData: Data) throws {
        do {
            try keyManager.removeAllKeys()
            guard let archive = SecureKeyArchiveImpl(
                archiveData: archiveData,
                keyManager: keyManager,
                zip: true
            ) else {
                throw SudoTelephonyError.internalError("Invalid key archive")
            }
            try archive.unarchive(nil)
            try archive.saveKeys()
        } catch let error as SudoTelephonyError {
            throw error
        } catch {
            throw SudoTelephonyError.internalError("Importing keys failed: \(error)")
        }
    }
}
