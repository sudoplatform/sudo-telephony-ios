//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSAppSync
import Foundation
import SudoApiClient
import SudoLogging
import SudoOperations

protocol PublicKeyGenerating {
    func generateKeyPair(identityId: String,
                         completion: @escaping ClientCompletion<(key: PublicKey, keyRingId: String)>)
}

class PublicKeyGenerator: PublicKeyGenerating {
    // MARK: - Properties

    /// App sync client for performing operations against the telephony service.
    var graphQLClient: SudoApiClient

    /// Used to log diagnostic and error information.
    var logger: Logger

    /// Utility factory class to generate mutation and query operations.
    var operationFactory = OperationFactory()

    /// Key manager to assist with generating/storing keys
    var keyManager: TelephonyKeyManager

    /// Operation queue for enqueuing asynchronous tasks.
    var queue: PlatformOperationQueue

    // MARK: - Lifecycle

    /// Initialize an instance of `AvailableNumberProvider`.
    init(keyManager: TelephonyKeyManager,
         graphQLClient: SudoApiClient,
         queue: PlatformOperationQueue = PlatformOperationQueue(),
         logger: Logger = .telephony)
    {
        self.keyManager = keyManager
        self.graphQLClient = graphQLClient
        self.queue = queue
        self.logger = logger
    }

    // Generates a public/private key pair
    func generateKeyPair(identityId: String,
                         completion: @escaping ClientCompletion<(key: PublicKey, keyRingId: String)>)
    {
        self.logger.info("Generating public/private keypair")

        // TODO: This function could use a refactor to make it shorter and simpler to parse.
        // It was moved here almost in bulk from TelephonyKeyManager.
        // Most of the changes were removing references to internal KeyManager details
        // and small changes to use the operation factory pattern rather than the graphQL client directly.

        let keyRingId = UUID().uuidString
        let keyId: String

        do {
            // Generates a unique key id that does not collide with any existing key ids.
            keyId = try self.keyManager.generateKeyId()

            /// Generate and securely store a key pair for public key cryptography.
            try self.keyManager.generateKeyPair(identityId)
        } catch {
            completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            return
        }

        guard let keyPair = self.keyManager.getKeyPair() else {
            completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            return
        }

        let publicKey = keyPair.publicKey.base64EncodedString()

        // Prepare the mutation
        let publicKeyInput = CreatePublicKeyInput(keyId: keyId, keyRingId: keyRingId, algorithm: "RSAEncryptionOAEPAESCBC", publicKey: publicKey)

        let mutation = CreatePublicKeyMutation(input: publicKeyInput)

        // fetch an operation from the factory.
        let createKeyOperation = self.operationFactory.generateMutationOperation(mutation: mutation,
                                                                                 graphQLClient: self.graphQLClient,
                                                                                 logger: self.logger)

        // Generate the finish handler
        let finishObserver = PlatformBlockObserver(finishHandler: { [weak createKeyOperation] _, errors in
            if let error = errors.first {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }

            // Extract results from the operation
            guard let publicKey = createKeyOperation?.result?.createPublicKeyForTelephony else {
                self.logger.error("Public key not registered with service")
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
                return
            }

            // Save the key ID as a password in the key manager
            do {
                try self.keyManager.setKeyId(value: keyId)
            } catch {
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            }

            // Save the key ring ID as a password in the key manager
            do {
                try self.keyManager.setKeyRingId(value: keyRingId)
            } catch {
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
            }

            completion(.success((publicKey.fragments.publicKey, keyRingId)))
        })

        createKeyOperation.addObserver(finishObserver)
        self.queue.addOperation(createKeyOperation)
    }
}
