//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoTelephonyCommon

/// GraphQL-backed implementation of `SubscriptionRepository`.
///
/// Opens AppSync subscriptions through `SudoApiClient` and maps each decoded payload
/// to a public type before invoking the caller's handler. The returned
/// `GraphQLClientSubscription` is wrapped in a `SubscriptionToken` the caller cancels.
final class DefaultSubscriptionRepository: SubscriptionRepository {

    // MARK: - Properties

    private let sudoApiClient: SudoApiClient

    // MARK: - Lifecycle

    init(sudoApiClient: SudoApiClient) {
        self.sudoApiClient = sudoApiClient
    }

    // MARK: - SubscriptionRepository

    func subscribeToPhoneNumberUpdates(
        owner: String,
        onUpdate: @escaping @Sendable (Result<PhoneNumber, Error>) -> Void
    ) async throws -> SubscriptionToken {
        let subscription = sudoApiClient.subscribe(
            subscription: GraphQL.OnPhoneNumberUpdateSubscription(owner: owner)
        ) { result in
            onUpdate(Self.mapResult(result) { data in
                guard let fragment = data.onPhoneNumberUpdate else { return nil }
                return try PhoneNumberTransformer.transform(fragment)
            })
        }
        return ApiSubscriptionToken(subscription: subscription)
    }

    func subscribeToPhoneMessageEvents(
        owner: String,
        onEvent: @escaping @Sendable (Result<PhoneMessageEvent, Error>) -> Void
    ) async throws -> SubscriptionToken {
        let subscription = sudoApiClient.subscribe(
            subscription: GraphQL.OnPhoneMessageEventSubscription(owner: owner)
        ) { result in
            onEvent(Self.mapResult(result) { data in
                guard let event = data.onPhoneMessageEvent else { return nil }
                return try PhoneMessageTransformer.transform(event)
            })
        }
        return ApiSubscriptionToken(subscription: subscription)
    }

    // MARK: - Helpers

    private static func mapResult<Data, Value>(
        _ result: Result<Data, Error>,
        _ transform: (Data) throws -> Value?
    ) -> Result<Value, Error> {
        switch result {
        case .success(let data):
            do {
                guard let value = try transform(data) else {
                    return .failure(SudoTelephonyError.noResultError)
                }
                return .success(value)
            } catch {
                return .failure(SudoTelephonyError.fromApiOperationError(error))
            }
        case .failure(let error):
            return .failure(SudoTelephonyError.fromApiOperationError(error))
        }
    }
}

/// `SubscriptionToken` backed by a `SudoApiClient` subscription.
private final class ApiSubscriptionToken: SubscriptionToken, @unchecked Sendable {

    private var subscription: GraphQLClientSubscription?

    init(subscription: GraphQLClientSubscription) {
        self.subscription = subscription
    }

    func cancel() {
        subscription?.cancel()
        subscription = nil
    }

    deinit {
        subscription?.cancel()
    }
}
