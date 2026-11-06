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
                areaCode: input.areaCode,
                countryCode: input.countryCode,
                limit: input.limit
            )
        )
        let data = try await fetch(query)
        return try PhoneNumberTransformer.transform(data.searchAvailablePhoneNumbers.fragments.phoneNumberSearchFields)
    }

    func provisionPhoneNumber(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber {
        // Generate the key pair the number's inbound messages will be sealed to and
        // register its public half. The private half stays on device for unsealing.
        let key = try deviceKeyManager.generateKeyPair()
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
        let data = try await perform(mutation)
        return try PhoneNumberTransformer.transform(data.provisionPhoneNumber.fragments.phoneNumberFields)
    }

    func deprovisionPhoneNumber(id: String) async throws -> PhoneNumber {
        let mutation = GraphQL.DeprovisionPhoneNumberMutation(id: id)
        let data = try await perform(mutation)
        return try PhoneNumberTransformer.transform(data.deprovisionPhoneNumber.fragments.phoneNumberFields)
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

    func sealingKeyId(forPhoneNumberId phoneNumberId: String) async throws -> String? {
        let query = GraphQL.GetPhoneNumberQuery(id: phoneNumberId)
        let data = try await fetch(query)
        return data.getPhoneNumber?.keyIds.first
    }
}
