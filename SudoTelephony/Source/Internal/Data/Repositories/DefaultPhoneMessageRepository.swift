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
        guard let message = data.getPhoneMessage else { return nil }
        let keyId = try await requireSealingKeyId(for: message.phoneNumberId)
        return try PhoneMessageTransformer.transform(
            message.fragments.sealedPhoneMessageFields,
            keyId: keyId,
            deviceKeyManager: deviceKeyManager
        )
    }

    func listPhoneMessagesForPhoneNumberId(
        _ input: ListPhoneMessagesForPhoneNumberIdInput
    ) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage> {
        let query = GraphQL.ListPhoneMessagesForPhoneNumberIdQuery(
            input: GraphQL.ListPhoneMessagesForPhoneNumberIdInput(
                limit: input.limit,
                nextToken: input.nextToken,
                phoneNumberId: input.phoneNumberId,
                sortOrder: input.sortOrder.map { GraphQL.SortOrder(rawValue: $0.rawValue) } ?? nil
            )
        )
        let page = try await fetch(query).listPhoneMessagesForPhoneNumberId
        // Every message in the page belongs to the same phone number, so the sealing
        // key is resolved once.
        let keyId = try await requireSealingKeyId(for: input.phoneNumberId)
        return try PhoneMessageTransformer.transform(
            items: page.items.map(\.fragments.sealedPhoneMessageFields),
            nextToken: page.nextToken,
            keyId: keyId,
            deviceKeyManager: deviceKeyManager
        )
    }

    func listPhoneMessagesForConversationId(
        _ input: ListPhoneMessagesForConversationIdInput
    ) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage> {
        let query = GraphQL.ListPhoneMessagesForConversationIdQuery(
            input: GraphQL.ListPhoneMessagesForConversationIdInput(
                conversationId: input.conversationId,
                limit: input.limit,
                nextToken: input.nextToken,
                sortOrder: input.sortOrder.map { GraphQL.SortOrder(rawValue: $0.rawValue) } ?? nil
            )
        )
        let page = try await fetch(query).listPhoneMessagesForConversationId
        // A conversation belongs to one phone number, which the input doesn't name, so
        // the sealing key is resolved from the messages themselves.
        guard let phoneNumberId = page.items.first?.phoneNumberId else {
            return .success(.init(items: [], nextToken: page.nextToken))
        }
        let keyId = try await requireSealingKeyId(for: phoneNumberId)
        return try PhoneMessageTransformer.transform(
            items: page.items.map(\.fragments.sealedPhoneMessageFields),
            nextToken: page.nextToken,
            keyId: keyId,
            deviceKeyManager: deviceKeyManager
        )
    }

    func deletePhoneMessages(_ input: DeletePhoneMessagesInput) async throws -> PhoneMessageBatchResult {
        let mutation = GraphQL.DeletePhoneMessagesMutation(
            input: GraphQL.DeletePhoneMessagesInput(ids: input.ids)
        )
        let data = try await perform(mutation)
        return PhoneMessageTransformer.transform(data.deletePhoneMessages.fragments.phoneMessageBatchResultFields)
    }

    func updatePhoneMessages(_ input: UpdatePhoneMessagesInput) async throws -> PhoneMessageBatchResult {
        let mutation = GraphQL.UpdatePhoneMessagesMutation(
            input: GraphQL.UpdatePhoneMessagesInput(ids: input.ids, seen: input.seen)
        )
        let data = try await perform(mutation)
        return PhoneMessageTransformer.transform(data.updatePhoneMessages.fragments.phoneMessageBatchResultFields)
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
