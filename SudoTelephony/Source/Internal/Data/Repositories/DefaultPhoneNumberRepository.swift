//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
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

    // MARK: - Lifecycle

    init(sudoApiClient: SudoApiClient, deviceKeyManager: DeviceKeyManager) {
        self.sudoApiClient = sudoApiClient
        self.deviceKeyManager = deviceKeyManager
    }

    // MARK: - PhoneNumberRepository

    func searchAvailablePhoneNumbers(
        _ input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult {
        let query = GraphQL.SearchAvailablePhoneNumbersQuery(
            input: GraphQL.SearchAvailablePhoneNumbersInput(
                countryCode: input.countryCode,
                areaCode: input.areaCode,
                limit: input.limit
            )
        )
        let data = try await fetch(query)
        return try PhoneNumberTransformer.transform(data.searchAvailablePhoneNumbers)
    }

    func provisionPhoneNumber(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber {
        // Generate the key pair the number's inbound messages will be sealed to and
        // register its public half. The private half stays on device for unsealing.
        let key = try deviceKeyManager.generateKeyPair()
        let mutation = GraphQL.ProvisionPhoneNumberMutation(
            input: GraphQL.ProvisionPhoneNumberInput(
                searchId: input.searchId,
                phoneNumber: input.phoneNumber,
                key: GraphQL.ProvisionPhoneNumberPublicKeyInput(
                    keyId: key.keyId,
                    algorithm: key.algorithm,
                    keyFormat: GraphQL.KeyFormat(rawValue: key.keyFormat.rawValue),
                    publicKey: key.publicKey
                ),
                ownershipProofTokens: input.ownershipProofTokens,
                clientRefId: input.clientRefId
            )
        )
        let data = try await perform(mutation)
        return try PhoneNumberTransformer.transform(data.provisionPhoneNumber)
    }

    func deprovisionPhoneNumber(id: String) async throws -> PhoneNumber {
        let mutation = GraphQL.DeprovisionPhoneNumberMutation(id: id)
        let data = try await perform(mutation)
        return try PhoneNumberTransformer.transform(data.deprovisionPhoneNumber)
    }

    func getPhoneNumber(id: String) async throws -> PhoneNumber? {
        let query = GraphQL.GetPhoneNumberQuery(id: id)
        let data = try await fetch(query)
        guard let fragment = data.getPhoneNumber else { return nil }
        return try PhoneNumberTransformer.transform(fragment)
    }

    func listPhoneNumbers(_ input: ListPhoneNumbersInput) async throws -> PhoneNumberListToken {
        let query = GraphQL.ListPhoneNumbersQuery(
            input: GraphQL.ListPhoneNumbersInput(limit: input.limit, nextToken: input.nextToken)
        )
        let data = try await fetch(query)
        return try PhoneNumberTransformer.transform(
            items: data.listPhoneNumbers.items,
            nextToken: data.listPhoneNumbers.nextToken
        )
    }

    func sealingKeyId(forPhoneNumberId phoneNumberId: String) async throws -> String? {
        let query = GraphQL.GetPhoneNumberQuery(id: phoneNumberId)
        let data = try await fetch(query)
        return data.getPhoneNumber?.keyIds?.first
    }
}
