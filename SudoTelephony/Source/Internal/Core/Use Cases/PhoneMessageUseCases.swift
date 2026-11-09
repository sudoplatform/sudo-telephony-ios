//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Business operation: fetch and unseal a single message.
final class GetPhoneMessageUseCase {

    private let repository: PhoneMessageRepository

    init(repository: PhoneMessageRepository) {
        self.repository = repository
    }

    /// Execute the fetch.
    func execute(id: String) async throws -> PhoneMessage? {
        try await repository.getPhoneMessage(id: id)
    }
}

/// Business operation: list and unseal a phone number's messages.
final class ListPhoneMessagesForPhoneNumberIdUseCase {

    private let repository: PhoneMessageRepository

    init(repository: PhoneMessageRepository) {
        self.repository = repository
    }

    /// Execute the list.
    func execute(_ input: ListPhoneMessagesForPhoneNumberIdInput) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage> {
        try await repository.listPhoneMessagesForPhoneNumberId(input)
    }
}

/// Business operation: list and unseal a conversation's messages.
final class ListPhoneMessagesForConversationIdUseCase {

    private let repository: PhoneMessageRepository

    init(repository: PhoneMessageRepository) {
        self.repository = repository
    }

    /// Execute the list.
    func execute(_ input: ListPhoneMessagesForConversationIdInput) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage> {
        try await repository.listPhoneMessagesForConversationId(input)
    }
}

/// Business operation: delete messages.
final class DeletePhoneMessagesUseCase {

    private let repository: PhoneMessageRepository

    init(repository: PhoneMessageRepository) {
        self.repository = repository
    }

    /// Execute the delete.
    func execute(_ input: DeletePhoneMessagesInput) async throws -> PhoneMessageBatchResult {
        try await repository.deletePhoneMessages(input)
    }
}

/// Business operation: set the read state of messages.
final class UpdatePhoneMessagesUseCase {

    private let repository: PhoneMessageRepository

    init(repository: PhoneMessageRepository) {
        self.repository = repository
    }

    /// Execute the update.
    func execute(_ input: UpdatePhoneMessagesInput) async throws -> PhoneMessageBatchResult {
        try await repository.updatePhoneMessages(input)
    }
}
