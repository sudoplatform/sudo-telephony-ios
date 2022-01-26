//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import SudoKeyManager
import SudoLogging
import SudoUser
import SudoApiClient

protocol TelephonyKeyManager: AnyObject {
    func removeAllKeys() throws
    func getKeyPair() -> KeyPair?
    func getKeyId() -> String?
    func getKeyRingId() -> String?
    func decryptSealedData(data: Data) throws -> Data

    /// Generates a unique key id that does not collide with any existing key ids.
    ///
    /// - Throws:
    ///     `SudoKeyManagerError.uuidGenerationLimitExceeded`
    func generateKeyId() throws -> String

    /// Generates and securely stores a key pair for public key cryptography.
    ///
    /// - Parameter name: Name of the key pair to be generated.
    ///
    /// - Throws:
    ///     `SudoKeyManagerError.duplicateKey`,
    ///     `SudoKeyManagerError.unhandledUnderlyingSecAPIError`,
    ///     `SudoKeyManagerError.fatalError`
    func generateKeyPair(_ name: String) throws

    func setKeyId(value: String) throws

    func setKeyRingId(value: String) throws
}

class DefaultTelephonyKeyManager: TelephonyKeyManager {

    private struct Constants {
        static let defaultKeyManagerServiceName = "com.sudoplatform.appservicename"
        static let defaultKeyManagerKeyTag = "com.sudoplatform"
        static let keyIdName = "com.sudoplatform.keyId"
        static let keyRingIdName = "com.sudoplatform.keyRingId"
    }

    private let sudoKeyManager: SudoKeyManager
    private let sudoUserClient: SudoUserClient
    private let graphQLClient: SudoApiClient
    private let logger: Logger

    init(keyNamespace: String,
         sudoUserClient: SudoUserClient,
         graphQLClient: SudoApiClient,
         logger: Logger) {

        self.sudoKeyManager = SudoKeyManagerImpl(
            serviceName: Constants.defaultKeyManagerServiceName,
            keyTag: Constants.defaultKeyManagerKeyTag,
            namespace: keyNamespace
        )
        self.sudoUserClient = sudoUserClient
        self.graphQLClient = graphQLClient
        self.logger = logger
    }

    /// Generates a unique key id that does not collide with any existing key ids.
    func generateKeyId() throws -> String {
        return try self.sudoKeyManager.generateKeyId()
    }

    func generateKeyPair(_ name: String) throws {
        return try self.sudoKeyManager.generateKeyPair(name)
    }

    func addPassword(_ password: Data, name: String) throws {
        return try self.sudoKeyManager.addPassword(password, name: name)
    }

    internal func removeAllKeys() throws {
        try sudoKeyManager.removeAllKeys()
    }



    internal func getKeyPair() -> KeyPair? {
        do {
            guard let identityId = sudoUserClient.getIdentityId() else { return nil }
            guard let privateKey = try self.sudoKeyManager.getPrivateKey(identityId),
                  let publicKey = try self.sudoKeyManager.getPublicKey(identityId) else {
                      return nil
                  }

            return KeyPair(publicKey: publicKey, privateKey: privateKey)
        } catch {
            return nil
        }
    }

    internal func getKeyId() -> String? {
        do {
            guard let identityId = sudoUserClient.getIdentityId() else { return nil }
            let keyIdData = try self.sudoKeyManager.getPassword(Constants.keyIdName + identityId)
            guard let keyId = keyIdData else { return nil }
            return String(data: keyId, encoding: .utf8)
        } catch {
            return nil
        }
    }

    internal func setKeyId(value: String) throws {
        guard let identityId = sudoUserClient.getIdentityId(),
              let data = value.data(using: .utf8)
        else {
            throw SudoTelephonyClientError.keyGenerationFailed
        }
        try self.addPassword(data, name: Constants.keyIdName + identityId)
    }

    internal func getKeyRingId() -> String? {
        do {
            guard let identityId = sudoUserClient.getIdentityId() else { return nil }
            let keyRingIdData = try self.sudoKeyManager.getPassword(Constants.keyRingIdName + identityId)
            guard let keyRingId = keyRingIdData else { return nil }
            return String(data: keyRingId, encoding: .utf8)
        } catch {
            return nil
        }
    }

    internal func setKeyRingId(value: String) throws {
        guard let identityId = sudoUserClient.getIdentityId(),
              let data = value.data(using: .utf8)
        else {
            throw SudoTelephonyClientError.keyGenerationFailed
        }
        try self.addPassword(data, name: Constants.keyRingIdName + identityId)
    }

    internal func decryptSealedData(data: Data) throws -> Data {
        if data.count < 1 { return data }

        guard let identityId = self.sudoUserClient.getIdentityId() else { throw SudoTelephonyClientError.sealedDataDecryptionFailed }
        do {
            let encryptedCipherKey = data[0...255]
            let cipherKey = try sudoKeyManager.decryptWithPrivateKey(identityId, data: encryptedCipherKey, algorithm: PublicKeyEncryptionAlgorithm.rsaEncryptionOAEPSHA1)
            let symmetricKey = cipherKey[0...31]
            let iv = Data(repeating: 0, count: 16)
            let encryptedBody = data[256...data.count - 1]

            let decryptedData = try sudoKeyManager.decryptWithSymmetricKey(symmetricKey, data: encryptedBody, iv: iv)
            return decryptedData
        } catch {
            throw SudoTelephonyClientError.sealedDataDecryptionFailed
        }
    }

    private func deleteKeyPair() throws {
        do {
            guard let identityId = sudoUserClient.getIdentityId() else { throw SudoTelephonyClientError.keyDeletionFailed }
            try sudoKeyManager.deleteKeyPair(identityId)
        } catch {
            throw SudoTelephonyClientError.keyDeletionFailed
        }
    }

}

extension TelephonyKeyManager {
    /// Decrypts a string from the service containing a sealed string.
    ///
    /// - Parameter string: Base64-encoded sealed string.
    /// - Throws: `SudoTelephonyClientError.sealedDataDecryptionFailed`
    /// - Returns: Unsealed value.
    func decrypt(_ string: String) throws -> String {
        guard let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else {
            throw SudoTelephonyClientError.sealedDataDecryptionFailed
        }
        let decrypted = try decryptSealedData(data: data)
        return String(decoding: decrypted, as: UTF8.self)
    }

    /// Decrypts a string from the service containing a sealed 32-bit unsigned integer.
    ///
    /// - Parameter string: Base64-encoded sealed 32-bit unsigned integer..
    /// - Throws: `SudoTelephonyClientError.sealedDataDecryptionFailed`
    /// - Returns: Unsealed value.
    func decrypt(_ string: String) throws -> UInt32 {
        guard let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else {
            throw SudoTelephonyClientError.sealedDataDecryptionFailed
        }
        let decrypted = try decryptSealedData(data: data)
        return UInt32(bigEndian: decrypted.withUnsafeBytes { $0.load(as: UInt32.self) })
    }
}
