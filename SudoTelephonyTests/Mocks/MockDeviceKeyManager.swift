//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Hand-written mock of the `DeviceKeyManager` seam used in repository and client
/// tests. Records calls and returns canned values or throws settable errors, so the
/// data layer can be tested without real `SudoKeyManager` crypto.
final class MockDeviceKeyManager: DeviceKeyManager, @unchecked Sendable {

    // MARK: - generateKeyPair

    private(set) var generateKeyPairCalled = false

    /// The key returned from `generateKeyPair`, or an error to throw.
    var generateKeyPairResult: Result<RegisteredPublicKey, Error> = .success(
        RegisteredPublicKey(
            keyId: "key-1",
            algorithm: "RSAEncryptionOAEPAESGCM",
            keyFormat: .rsaPublicKey,
            publicKey: "cHVibGljLWtleQ=="
        )
    )

    func generateKeyPair() throws -> RegisteredPublicKey {
        generateKeyPairCalled = true
        return try generateKeyPairResult.get()
    }

    // MARK: - unsealString

    private(set) var unsealCallCount = 0
    private(set) var lastUnsealKeyId: String?
    private(set) var lastUnsealAlgorithm: String?

    /// Maps a sealed input string to the plaintext it should unseal to. A value not in
    /// the map falls back to `defaultUnsealResult`.
    var unsealResults: [String: String] = [:]

    /// The result returned for any sealed value not present in `unsealResults`.
    var defaultUnsealResult: Result<String, Error> = .success("unsealed")

    func unsealString(_ sealed: String, withKeyId keyId: String, algorithm: String) throws -> String {
        unsealCallCount += 1
        lastUnsealKeyId = keyId
        lastUnsealAlgorithm = algorithm
        if let mapped = unsealResults[sealed] {
            return mapped
        }
        return try defaultUnsealResult.get()
    }

    // MARK: - removeAllKeys

    private(set) var removeAllKeysCallCount = 0
    var removeAllKeysError: Error?

    func removeAllKeys() throws {
        removeAllKeysCallCount += 1
        if let removeAllKeysError {
            throw removeAllKeysError
        }
    }

    // MARK: - exportKeys

    private(set) var exportKeysCallCount = 0
    var exportKeysResult: Result<Data, Error> = .success(Data("archive".utf8))

    func exportKeys() throws -> Data {
        exportKeysCallCount += 1
        return try exportKeysResult.get()
    }

    // MARK: - importKeys

    private(set) var importedArchives: [Data] = []
    var importKeysError: Error?

    func importKeys(archiveData: Data) throws {
        importedArchives.append(archiveData)
        if let importKeysError {
            throw importKeysError
        }
    }
}
