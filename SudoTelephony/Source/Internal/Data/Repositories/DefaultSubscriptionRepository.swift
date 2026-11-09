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
/// Opens one AppSync subscription per call through `SudoApiClient`, maps each decoded
/// payload to a public type, and tells the subscriber when the subscription connects
/// and when it ends. A payload that can't be read is dropped, as the email SDK and the
/// Android telephony SDK do, rather than ending the subscription.
final class DefaultSubscriptionRepository: SubscriptionRepository {

    // MARK: - Properties

    private let sudoApiClient: SudoApiClient

    // MARK: - Lifecycle

    init(sudoApiClient: SudoApiClient) {
        self.sudoApiClient = sudoApiClient
    }

    // MARK: - SubscriptionRepository

    func subscribeToPhoneNumbers(owner: String, subscriber: PhoneNumberSubscriber) async throws -> SubscriptionToken {
        // The notification closure takes the subscriber as an argument rather than capturing it, so the SDK holds it
        // only weakly, through the relay.
        subscribe(GraphQL.OnPhoneNumberUpdateSubscription(owner: owner), subscriber: subscriber, as: PhoneNumberSubscriber.self) { data in
            guard let number = data.onPhoneNumberUpdate else { return nil }
            let phoneNumber = try PhoneNumberTransformer.transform(number.fragments.phoneNumberFields)
            return { target in target.phoneNumberUpdated(phoneNumber) }
        }
    }

    func subscribeToPhoneMessages(owner: String, subscriber: PhoneMessageSubscriber) async throws -> SubscriptionToken {
        subscribe(GraphQL.OnPhoneMessageEventSubscription(owner: owner), subscriber: subscriber, as: PhoneMessageSubscriber.self) { data in
            guard let payload = data.onPhoneMessageEvent else { return nil }
            let event = try PhoneMessageTransformer.transform(payload)
            return { target in target.phoneMessageEvent(event) }
        }
    }

    // MARK: - Helpers

    /// Open `subscription`, relaying its connection state and each readable payload to `subscriber`.
    ///
    /// - Parameters:
    ///   - subscriberType: The subscriber protocol the notifications are for.
    ///   - notification: Reads a payload and returns the call to make on the subscriber, or `nil` if the payload is
    ///     empty.
    private func subscribe<Subscription: GraphQLSubscription, Target>(
        _ subscription: Subscription,
        subscriber: Subscriber,
        as subscriberType: Target.Type,
        notification: @escaping @Sendable (Subscription.Data) throws -> ((Target) -> Void)?
    ) -> SubscriptionToken {
        // The handlers hold the relay weakly: the caller's token is the only strong reference, so releasing it ends the
        // subscription.
        let relay = SubscriptionRelay(subscriber: subscriber)
        let apiSubscription = sudoApiClient.subscribe(
            subscription: subscription,
            statusChangeHandler: { [weak relay] state in
                if state == .connected {
                    relay?.connected()
                }
            },
            completionHandler: { [weak relay] result in
                relay?.ended(result)
            },
            resultHandler: { [weak relay] result in
                guard case .success(let data) = result, let notify = try? notification(data) else { return }
                relay?.deliver(to: subscriberType, notify)
            }
        )
        relay.attach(apiSubscription)
        return relay
    }
}

/// Relays one subscription's callbacks to its subscriber until the subscription ends, and is the token that ends it.
///
/// The subscriber is held weakly; once it's released, the transport subscription is cancelled. Callbacks run under a lock, so
/// none reaches the subscriber once `cancel()` returns; the lock is recursive so a subscriber can cancel from inside a
/// callback.
final class SubscriptionRelay: SubscriptionToken, @unchecked Sendable {

    // MARK: - Properties

    private let lock = NSRecursiveLock()
    private weak var subscriber: Subscriber?
    private var subscription: GraphQLClientSubscription?
    private var hasEnded = false
    private var hasConnected = false

    // MARK: - Lifecycle

    init(subscriber: Subscriber?) {
        self.subscriber = subscriber
    }

    deinit {
        subscription?.cancel()
    }

    // MARK: - Relay

    /// Keep the transport subscription, cancelling it straight away if the subscription has already ended.
    func attach(_ subscription: GraphQLClientSubscription) {
        lock.withLock {
            if hasEnded {
                subscription.cancel()
            } else {
                self.subscription = subscription
            }
        }
    }

    /// Tell the subscriber the service acknowledged the subscription. Reported once, even if the transport reconnects.
    func connected() {
        lock.withLock {
            guard !hasEnded, !hasConnected, let subscriber = activeSubscriber() else { return }
            hasConnected = true
            subscriber.connectionStatusChanged(.connected)
        }
    }

    /// Pass a notification to the subscriber, if it's still subscribed and of the expected type.
    func deliver<Target>(to type: Target.Type, _ notify: (Target) -> Void) {
        lock.withLock {
            guard !hasEnded, let subscriber = activeSubscriber() as? Target else { return }
            notify(subscriber)
        }
    }

    /// End the subscription because the service closed it, telling the subscriber why.
    func ended(_ result: Result<Void, Error>) {
        lock.withLock {
            guard !hasEnded else { return }
            end()
            let cause: SudoTelephonyError? = switch result {
            case .success: nil
            case .failure(let error): SudoTelephonyError.fromApiOperationError(error)
            }
            subscriber?.connectionStatusChanged(.disconnected(cause: cause))
        }
    }

    // MARK: - SubscriptionToken

    func cancel() {
        lock.withLock(end)
    }

    // MARK: - Helpers

    /// The subscriber, or `nil` after ending the subscription if it has been released. Call with the lock held.
    private func activeSubscriber() -> Subscriber? {
        guard let subscriber else {
            end()
            return nil
        }
        return subscriber
    }

    /// Stop relaying and cancel the transport subscription. Call with the lock held.
    private func end() {
        hasEnded = true
        subscription?.cancel()
        subscription = nil
    }
}
