//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Security
import SudoKeyManager
import SudoLogging
import Synchronization

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
        /// Key store password whose value is the singleton key pair's ID.
        static let singletonKeyIdName = "singleton-key-id"
    }

    // MARK: - Properties

    private let keyManager: SudoKeyManager
    private let logger: Logger

    /// Guards every read-modify-write of the singleton key ID's record. The state it
    /// protects lives in the key store, so the mutex holds no value of its own.
    private let singletonLock = Mutex(())

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
    public convenience init(keyManager: SudoKeyManager) {
        self.init(keyManager: keyManager, logger: .telephonySDKLogger)
    }

    /// Create the device key manager over a configured `SudoKeyManager`, logging to
    /// `logger`.
    ///
    /// - Important: As for `init(keyManager:)`, the key manager must perform AES-GCM
    ///   for `decryptWithSymmetricKey`.
    ///
    /// - Parameters:
    ///   - keyManager: The key store used for generation, storage, and cryptographic
    ///     operations.
    ///   - logger: Where key events, such as the singleton key pair being replaced,
    ///     are logged.
    public init(keyManager: SudoKeyManager, logger: Logger) {
        self.keyManager = keyManager
        self.logger = logger
    }

    // MARK: - DeviceKeyManager

    public func generateKeyPair() throws -> RegisteredPublicKey {
        let keyId = UUID().uuidString
        do {
            try keyManager.generateKeyPair(keyId)
            guard let publicKey = try keyManager.getPublicKey(keyId) else {
                throw SudoTelephonyError.internalError("Public key missing after generation")
            }
            return registeredPublicKey(keyId: keyId, publicKey: publicKey)
        } catch let error as SudoTelephonyError {
            throw error
        } catch {
            throw SudoTelephonyError.internalError("Key pair generation failed: \(error)")
        }
    }

    public func getSingletonKeyPair() throws -> RegisteredPublicKey? {
        try withSingletonLock {
            do {
                return try existingSingletonKeyPair()
            } catch let error as SudoTelephonyError {
                throw error
            } catch {
                throw SudoTelephonyError.internalError("Singleton key pair retrieval failed: \(error)")
            }
        }
    }

    public func createSingletonKeyPairIfAbsent() throws -> CreateSingletonKeysIfAbsentResult.KeyResult {
        // Serialise get-or-create so concurrent calls can't each create a "singleton" key.
        try withSingletonLock {
            do {
                if let existing = try existingSingletonKeyPair() {
                    return CreateSingletonKeysIfAbsentResult.KeyResult(created: false, keyId: existing.keyId)
                }
                // No singleton yet, or its private key is missing: start a new one. Generate
                // before recording the ID so a failed generation never leaves the record
                // naming a key that doesn't exist.
                let missingKeyId = try singletonKeyId()
                let key = try generateKeyPair()
                do {
                    try recordSingletonKeyId(key.keyId)
                } catch {
                    try? keyManager.deleteKeyPair(key.keyId)
                    throw error
                }
                if let missingKeyId {
                    reportReplacedSingletonKeyPair(missingKeyId: missingKeyId, replacementKeyId: key.keyId)
                } else {
                    logger.info("Created singleton key pair \(key.keyId)")
                }
                return CreateSingletonKeysIfAbsentResult.KeyResult(created: true, keyId: key.keyId)
            } catch let error as SudoTelephonyError {
                throw error
            } catch {
                throw SudoTelephonyError.internalError("Singleton key pair creation failed: \(error)")
            }
        }
    }

    public func removeKeyPair(keyId: String) throws {
        try withSingletonLock {
            do {
                guard try keyId != singletonKeyId() else { return }
                try keyManager.deleteKeyPair(keyId)
            } catch {
                throw SudoTelephonyError.internalError("Removing key pair failed: \(error)")
            }
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
        // Import replaces the singleton key ID's record along with every key.
        try withSingletonLock {
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
                try restoreSingletonPublicKey()
            } catch let error as SudoTelephonyError {
                throw error
            } catch {
                throw SudoTelephonyError.internalError("Importing keys failed: \(error)")
            }
        }
    }

    // MARK: - Private

    /// Runs `body` while holding the singleton lock. The body is synchronous, so the
    /// lock can never be held across a suspension point.
    private func withSingletonLock<Result: Sendable>(_ body: () throws -> Result) throws -> Result {
        try singletonLock.withLock { _ in try body() }
    }

    /// The singleton key pair, or `nil` if none is recorded or its private key isn't on
    /// this device. Call while holding the singleton lock.
    private func existingSingletonKeyPair() throws -> RegisteredPublicKey? {
        guard let keyId = try singletonKeyId() else {
            return nil
        }
        if let publicKey = try keyManager.getPublicKey(keyId) {
            return registeredPublicKey(keyId: keyId, publicKey: publicKey)
        }
        // Import restores the public key, so a private key without one means the key
        // store is inconsistent. Treating it as missing would replace the key and split
        // numbers across two "singleton" keys, so fail instead.
        if try keyManager.getPrivateKey(keyId) != nil {
            throw SudoTelephonyError.internalError("Singleton key pair \(keyId) has a private key but no public key")
        }
        return nil
    }

    private func registeredPublicKey(keyId: String, publicKey: Data) -> RegisteredPublicKey {
        RegisteredPublicKey(
            keyId: keyId,
            algorithm: Defaults.algorithm,
            keyFormat: .rsaPublicKey,
            publicKey: publicKey.base64EncodedString()
        )
    }

    /// The ID of the singleton key pair, or `nil` if none has been created.
    private func singletonKeyId() throws -> String? {
        guard
            let data = try keyManager.getPassword(Defaults.singletonKeyIdName),
            let keyId = String(data: data, encoding: .utf8),
            !keyId.isEmpty
        else { return nil }
        return keyId
    }

    private func recordSingletonKeyId(_ keyId: String) throws {
        try keyManager.deletePassword(Defaults.singletonKeyIdName)
        try keyManager.addPassword(Data(keyId.utf8), name: Defaults.singletonKeyIdName)
    }

    /// Stores the singleton key pair's public key again after an import.
    ///
    /// `exportKeys()` leaves public keys out of the archive, so an import restores only
    /// the singleton's private key. Provisioning registers the public key, so it is
    /// derived from the private key here, once, rather than abandoning the key pair
    /// numbers are still sealed to.
    private func restoreSingletonPublicKey() throws {
        guard
            let keyId = try singletonKeyId(),
            try keyManager.getPublicKey(keyId) == nil,
            let privateKey = try keyManager.getPrivateKey(keyId)
        else { return }
        try keyManager.addPublicKey(Self.derivePublicKey(fromPrivateKey: privateKey), name: keyId)
        logger.info("Restored the public key of singleton key pair \(keyId) from its private key")
    }

    /// Reports that the singleton key pair's private key was missing from this device,
    /// so a new singleton replaced it.
    ///
    /// Logged as an error and output as one, so an app's log driver can record it as
    /// a non-fatal: numbers sealed to the missing key can no longer be read on this
    /// device until a key archive containing it is imported.
    private func reportReplacedSingletonKeyPair(missingKeyId: String, replacementKeyId: String) {
        let message = "Singleton key pair \(missingKeyId) has no private key on this device; replaced it with \(replacementKeyId). "
            + "Numbers sealed to \(missingKeyId) can't be read here until a key archive containing it is imported."
        logger.error(message)
        logger.outputError(
            SudoTelephonyError.internalError(message),
            withUserInfo: ["missingKeyId": missingKeyId, "replacementKeyId": replacementKeyId]
        )
    }

    /// The PKCS#1 public key for a PKCS#1 RSA private key.
    private static func derivePublicKey(fromPrivateKey privateKeyData: Data) throws -> Data {
        let attributes: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate
        ]
        var error: Unmanaged<CFError>?
        guard
            let privateKey = SecKeyCreateWithData(privateKeyData as CFData, attributes as CFDictionary, &error),
            let publicKey = SecKeyCopyPublicKey(privateKey),
            let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, &error)
        else {
            let cause = error.map { "\($0.takeRetainedValue())" } ?? "unknown"
            throw SudoTelephonyError.internalError("Deriving public key failed: \(cause)")
        }
        return publicKeyData as Data
    }
}
