//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSAppSync
import Foundation
import SudoApiClient
import SudoLogging
import SudoOperations

public typealias SubscriptionHandler<T> = (T) -> Void

protocol SubscriptionServices {
    func subscribeToMessages(ownerId: String,
                             statusObserver: SubscriptionHandler<AWSAppSyncSubscriptionWatcherStatus>?,
                             resultHandler: @escaping SubscriptionHandler<SealedMessage>) throws -> SubscriptionToken?

    func clearSubscriptions()
}

class SubscriptionService: SubscriptionServices {

    internal init(graphQLClient: SudoApiClient) {
        self.graphQLClient = graphQLClient
    }

    /// App sync client for performing operations against the telephony service.
    let graphQLClient: SudoApiClient

    /// Weak references to subscribers. Weak references to subscriptions are kept
    /// so that they can be cleared when requested.
    private var subscriptions: [WeakCancellable] = []

    /// Queue for synchronized reading and writing to the `subscriptions` array.
    private let subscriptionsAccessQueue = DispatchQueue(label: "com.sudoplatform.telephony.subscriptionService.subscriptionAccess")

    func subscribe<Subscription: GraphQLSubscription>(subscription: Subscription,
                                                      statusObserver: (SubscriptionHandler<AWSAppSyncSubscriptionWatcherStatus>)?,
                                                      resultHandler: @escaping SubscriptionHandler<Subscription.Data>) throws -> SubscriptionToken? {
        let subToken = try self.graphQLClient.subscribe(subscription: subscription) { watcherStatus in
            statusObserver?(watcherStatus)
        } resultHandler: { result, transaction, error in
            guard let data = result?.data else {
                return
            }
            resultHandler(data)
        }

        // Keep a weak reference to the cancelable so this service can cancel all subscriptions
        // when asked.
        subscriptionsAccessQueue.sync {
            self.subscriptions.append(.init(value: subToken))
        }

        return subToken
    }

    func clearSubscriptions() {
        subscriptionsAccessQueue.sync {
            self.subscriptions.forEach {$0.value?.cancel()}
            self.subscriptions.removeAll()
        }
    }

    func subscribeToMessages(ownerId: String,
                             statusObserver: SubscriptionHandler<AWSAppSyncSubscriptionWatcherStatus>?,
                             resultHandler: @escaping SubscriptionHandler<SealedMessage>) throws -> SubscriptionToken? {
        let messageSubscription = OnMessageReceivedSubscription(owner: ownerId)
        let token = try self.subscribe(subscription: messageSubscription, statusObserver: statusObserver) { data in
            guard let sealedMessage = data.onMessage?.fragments.sealedMessage else {
                return
            }
            resultHandler(sealedMessage)
        }

        return token
    }
}

struct WeakCancellable {
    /// The cancellable resource reference.
    weak var value: Cancellable?
}
