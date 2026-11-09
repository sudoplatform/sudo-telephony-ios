//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Business operation: subscribe to phone-number changes.
final class SubscribeToPhoneNumbersUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    /// Open the subscription.
    func execute(owner: String, subscriber: PhoneNumberSubscriber) async throws -> SubscriptionToken {
        try await repository.subscribeToPhoneNumbers(owner: owner, subscriber: subscriber)
    }
}

/// Business operation: subscribe to message events.
final class SubscribeToPhoneMessagesUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    /// Open the subscription.
    func execute(owner: String, subscriber: PhoneMessageSubscriber) async throws -> SubscriptionToken {
        try await repository.subscribeToPhoneMessages(owner: owner, subscriber: subscriber)
    }
}
