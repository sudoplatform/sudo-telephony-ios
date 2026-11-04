//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoTelephonyCommon

/// GraphQL-backed implementation of `PhoneMessageRepository`.
///
/// Fetches sealed messages, resolves the key the owning phone number's messages are
/// sealed to via `PhoneNumberRepository`, and unseals `body`/`remotePhoneNumber`
/// through `PhoneMessageTransformer` before returning public values.
final class DefaultPhoneMessageRepository: PhoneMessageRepository, SudoApiGraphQLExecutor {

    // MARK: - Properties

    let sudoApiClient: SudoApiClient
    private let deviceKeyManager: DeviceKeyManager
    private let phoneNumberRepository: PhoneNumberRepository

    // MARK: - Lifecycle

    init(
        sudoApiClient: SudoApiClient,
        deviceKeyManager: DeviceKeyManager,
        phoneNumberRepository: PhoneNumberRepository
    ) {
        self.sudoApiClient = sudoApiClient
        self.deviceKeyManager = deviceKeyManager
        self.phoneNumberRepository = phoneNumberRepository
    }

    // MARK: - PhoneMessageRepository

    func getPhoneMessage(id: String) async throws -> PhoneMessage? {
        let query = GraphQL.GetPhoneMessageQuery(id: id)
        let data = try await fetch(query)
        guard let fragment = data.getPhoneMessage else { return nil }
        let keyId = try await requireSealingKeyId(for: fragment.phoneNumberId)
        return try PhoneMessageTransformer.transform(
            fragment,
            keyId: keyId,
            deviceKeyManager: deviceKeyManager
        )
    }

    func listPhoneMessages(_ input: ListPhoneMessagesInput) async throws -> PhoneMessageListToken {
        let query = GraphQL.ListPhoneMessagesQuery(
            input: GraphQL.ListPhoneMessagesInput(
                phoneNumberId: input.phoneNumberId,
                conversationId: input.conversationId,
                sortOrder: input.sortOrder.map { GraphQL.SortOrder(rawValue: $0.rawValue) } ?? nil,
                limit: input.limit,
                nextToken: input.nextToken
            )
        )
        let data = try await fetch(query)

        // Every message in the page belongs to the same phone number, so the sealing
        // key is resolved once.
        let keyId = try await requireSealingKeyId(for: input.phoneNumberId)
        let items = try data.listPhoneMessages.items.map {
            try PhoneMessageTransformer.transform($0, keyId: keyId, deviceKeyManager: deviceKeyManager)
        }
        return PhoneMessageListToken(items: items, nextToken: data.listPhoneMessages.nextToken)
    }

    func deletePhoneMessages(ids: [String]) async throws -> PhoneMessageBatchResult {
        let mutation = GraphQL.DeletePhoneMessagesMutation(
            input: GraphQL.DeletePhoneMessagesInput(ids: ids)
        )
        let data = try await perform(mutation)
        return PhoneMessageTransformer.transform(data.deletePhoneMessages)
    }

    func updatePhoneMessages(ids: [String], seen: Bool) async throws -> PhoneMessageBatchResult {
        let mutation = GraphQL.UpdatePhoneMessagesMutation(
            input: GraphQL.UpdatePhoneMessagesInput(ids: ids, seen: seen)
        )
        let data = try await perform(mutation)
        return PhoneMessageTransformer.transform(data.updatePhoneMessages)
    }

    // MARK: - Helpers

    private func requireSealingKeyId(for phoneNumberId: String) async throws -> String {
        guard let keyId = try await phoneNumberRepository.sealingKeyId(forPhoneNumberId: phoneNumberId) else {
            throw SudoTelephonyError.internalError(
                "No sealing key found for phone number \(phoneNumberId)"
            )
        }
        return keyId
    }
}
