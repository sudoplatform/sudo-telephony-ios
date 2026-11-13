//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoLogging
import SudoTelephonyCommon

/// GraphQL-backed implementation of `PhoneNumberRepository`.
///
/// Builds the generated operations, executes them through `SudoApiGraphQLExecutor`
/// (which centralises error translation), and maps responses through
/// `PhoneNumberTransformer`.
final class DefaultPhoneNumberRepository: PhoneNumberRepository, SudoApiGraphQLExecutor {

    // MARK: - Properties

    let sudoApiClient: SudoApiClient
    private let deviceKeyManager: DeviceKeyManager
    private let enforceSingletonKeyPair: Bool
    private let logger: Logger

    // MARK: - Lifecycle

    init(
        sudoApiClient: SudoApiClient,
        deviceKeyManager: DeviceKeyManager,
        enforceSingletonKeyPair: Bool = false,
        logger: Logger = .telephonySDKLogger
    ) {
        self.sudoApiClient = sudoApiClient
        self.deviceKeyManager = deviceKeyManager
        self.enforceSingletonKeyPair = enforceSingletonKeyPair
        self.logger = logger
    }

    // MARK: - PhoneNumberRepository

    func searchAvailablePhoneNumbers(
        _ input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult {
        let query = GraphQL.SearchAvailablePhoneNumbersQuery(
            input: GraphQL.SearchAvailablePhoneNumbersInput(
                areaCode: input.areaCode,
                countryCode: input.countryCode,
                limit: input.limit
            )
        )
        let data = try await fetch(query)
        return try PhoneNumberTransformer.transform(data.searchAvailablePhoneNumbers.fragments.phoneNumberSearchFields)
    }

    func provisionPhoneNumber(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber {
        // Get the key pair the number's inbound messages will be sealed to and register
        // its public half. The private half stays on device for unsealing.
        let key = try enforceSingletonKeyPair ? requireSingletonKeyPair() : deviceKeyManager.generateKeyPair()
        let mutation = GraphQL.ProvisionPhoneNumberMutation(
            input: GraphQL.ProvisionPhoneNumberInput(
                clientRefId: input.clientRefId,
                key: GraphQL.ProvisionPhoneNumberPublicKeyInput(
                    algorithm: key.algorithm,
                    keyFormat: GraphQL.KeyFormat(rawValue: key.keyFormat.rawValue),
                    keyId: key.keyId,
                    publicKey: key.publicKey
                ),
                // The service takes a list, but accepts exactly one Sudo proof.
                ownershipProofTokens: input.ownershipProofToken.map { [$0] },
                phoneNumber: input.phoneNumber,
                searchId: input.searchId
            )
        )
        // Remove a per-number key only when the service definitely didn't register it.
        // After any other failure the number may exist, and its key is the only way to
        // read its messages. `removeKeyPair` would skip the singleton key anyway.
        let data = try await perform(mutation, onDefinitiveRejection: {
            guard !enforceSingletonKeyPair else { return }
            // Best effort: the provisioning error is the one to report.
            removeKeyPair(keyId: key.keyId, after: "a rejected provision")
        })
        return try PhoneNumberTransformer.transform(data.provisionPhoneNumber.fragments.phoneNumberFields)
    }

    func deprovisionPhoneNumber(id: String) async throws -> PhoneNumber {
        let mutation = GraphQL.DeprovisionPhoneNumberMutation(id: id)
        let data = try await perform(mutation)
        let fields = data.deprovisionPhoneNumber.fragments.phoneNumberFields
        let number = try PhoneNumberTransformer.transform(fields)
        if !enforceSingletonKeyPair {
            // `removeKeyPair` skips the singleton key in case the app changed modes with
            // numbers live.
            try removeKeyPairs(fields.keyIds, ofDeprovisioned: number)
        }
        return number
    }

    func getPhoneNumber(id: String) async throws -> PhoneNumber? {
        let query = GraphQL.GetPhoneNumberQuery(id: id)
        let data = try await fetch(query)
        guard let number = data.getPhoneNumber else { return nil }
        return try PhoneNumberTransformer.transform(number.fragments.phoneNumberFields)
    }

    func listPhoneNumbers(_ input: ListPhoneNumbersInput) async throws -> ListOutput<PhoneNumber> {
        let query = GraphQL.ListPhoneNumbersQuery(
            input: GraphQL.ListPhoneNumbersInput(limit: input.limit, nextToken: input.nextToken)
        )
        let data = try await fetch(query)
        return try PhoneNumberTransformer.transform(
            items: data.listPhoneNumbers.items.map(\.fragments.phoneNumberFields),
            nextToken: data.listPhoneNumbers.nextToken
        )
    }

    func listPhoneNumbersForSudoId(_ input: ListPhoneNumbersForSudoIdInput) async throws -> ListOutput<PhoneNumber> {
        let query = GraphQL.ListPhoneNumbersForSudoIdQuery(
            input: GraphQL.ListPhoneNumbersForSudoIdInput(limit: input.limit, nextToken: input.nextToken, sudoId: input.sudoId)
        )
        let data = try await fetch(query)
        return try PhoneNumberTransformer.transform(
            items: data.listPhoneNumbersForSudoId.items.map(\.fragments.phoneNumberFields),
            nextToken: data.listPhoneNumbersForSudoId.nextToken
        )
    }

    /// The singleton key pair, which `createSingletonKeysIfAbsent()` creates. Provisioning never
    /// creates it, so the app always knows when the device's key material changes.
    private func requireSingletonKeyPair() throws -> RegisteredPublicKey {
        guard let key = try deviceKeyManager.getSingletonKeyPair() else {
            throw SudoTelephonyError.singletonKeyPairNotFound
        }
        return key
    }

    /// Removes a key pair that is no longer needed, logging rather than throwing if
    /// that fails, since the operation that made it unneeded has already completed.
    private func removeKeyPair(keyId: String, after operation: String) {
        do {
            try deviceKeyManager.removeKeyPair(keyId: keyId)
        } catch {
            logger.warning("Couldn't remove key pair \(keyId) after \(operation); it stays on this device: \(error)")
        }
    }

    /// Removes a deprovisioned number's key pairs. Every key is attempted, then the first
    /// failure is thrown as `keyPairRemovalFailed` carrying the released number, so the
    /// caller learns the keychain failed without being told the number still exists.
    private func removeKeyPairs(_ keyIds: [String], ofDeprovisioned number: PhoneNumber) throws {
        var firstError: Error?
        for keyId in keyIds {
            do {
                try deviceKeyManager.removeKeyPair(keyId: keyId)
            } catch {
                logger.error("Couldn't remove key pair \(keyId) after deprovisioning phone number \(number.id); it stays on this device: \(error)")
                firstError = firstError ?? error
            }
        }
        if let firstError {
            throw SudoTelephonyError.keyPairRemovalFailed(deprovisioned: number, cause: firstError.localizedDescription)
        }
    }

    func sealingKeyId(forPhoneNumberId phoneNumberId: String) async throws -> String? {
        let query = GraphQL.GetPhoneNumberQuery(id: phoneNumberId)
        let data = try await fetch(query)
        return data.getPhoneNumber?.keyIds.first
    }
}
