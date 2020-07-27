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

protocol TelephonyKeyManager {
    func removeAllKeys() throws
    func generateKeyPair(apiResultQueue: DispatchQueue, completion: @escaping (Swift.Result<PublicKey, SudoTelephonyClientError>) -> Void) throws
    func getKeyPair() -> KeyPair?
    func getKeyId() -> String?
    func getKeyRingId() -> String?
    func decryptSealedData(data: Data) throws -> Data
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
    private let graphQLClient: AWSAppSyncClient
    private let logger: Logger

    init(keyNamespace: String,
         sudoUserClient: SudoUserClient,
         graphQLClient: AWSAppSyncClient,
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

    internal func removeAllKeys() throws {
        try sudoKeyManager.removeAllKeys()
    }

    internal func generateKeyPair(apiResultQueue: DispatchQueue, completion: @escaping (Swift.Result<PublicKey, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Generating public/private keypair")

        guard let identityId = self.sudoUserClient.getIdentityId() else {
            completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            return
        }
        let keyRingId = UUID().uuidString
        let keyId = try self.sudoKeyManager.generateKeyId()

        do {
            try self.sudoKeyManager.generateKeyPair(identityId)
        } catch {
            throw SudoTelephonyClientError.keyGenerationFailed
        }

        guard let keyPair = getKeyPair() else {
            completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            return
        }

        let publicKey = keyPair.publicKey.base64EncodedString()

        let publicKeyInput = CreatePublicKeyInput.init(keyId: keyId, keyRingId: keyRingId, algorithm: "RSAEncryptionOAEPAESCBC", publicKey: publicKey)

        let mutation = CreatePublicKeyMutation(input: publicKeyInput)

        graphQLClient.perform(mutation: mutation, queue: apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }

            guard let publicKey = result?.data?.createPublicKeyForTelephony else {
                self.logger.error("Public key not registered with service")
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
                return
            }

            // Save the key ID as a password in the key manager
            guard let keyIdData = keyId.data(using: String.Encoding.utf8) else {
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
                return
            }
            do {
                try self.sudoKeyManager.addPassword(keyIdData, name: Constants.keyIdName + identityId)
            } catch {
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            }

            // Save the key ring ID as a password in the key manager
            guard let keyRingIdData = keyRingId.data(using: String.Encoding.utf8) else {
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
                return
            }
            do {
                try self.sudoKeyManager.addPassword(keyRingIdData, name: Constants.keyRingIdName + identityId)
            } catch {
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            }


            completion(.success(publicKey.fragments.publicKey))
        }
    }

    internal func getKeyPair() -> KeyPair? {
        do {
            guard let identityId = sudoUserClient.getIdentityId() else { return nil }
            guard let privateKey = try self.sudoKeyManager.getPrivateKey(identityId), let publicKey = try self.sudoKeyManager.getPublicKey(identityId) else {
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
