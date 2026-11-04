//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Business operation: subscribe to phone-number changes.
final class SubscribeToPhoneNumberUpdatesUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    /// Open the subscription.
    func execute(
        owner: String,
        onUpdate: @escaping @Sendable (Result<PhoneNumber, Error>) -> Void
    ) async throws -> SubscriptionToken {
        try await repository.subscribeToPhoneNumberUpdates(owner: owner, onUpdate: onUpdate)
    }
}

/// Business operation: subscribe to message events.
final class SubscribeToPhoneMessageEventsUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    /// Open the subscription.
    func execute(
        owner: String,
        onEvent: @escaping @Sendable (Result<PhoneMessageEvent, Error>) -> Void
    ) async throws -> SubscriptionToken {
        try await repository.subscribeToPhoneMessageEvents(owner: owner, onEvent: onEvent)
    }
}
