//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Port for the telephony service's real-time subscriptions.
///
/// Implemented in the data layer by `DefaultSubscriptionRepository`, which maps
/// decoded subscription payloads to public types (unsealing is not needed: the
/// message-event payload carries no sealed content).
protocol SubscriptionRepository {

    /// Subscribe to changes to the caller's phone numbers.
    ///
    /// - Parameters:
    ///   - owner: The owner subject the subscription is scoped to.
    ///   - subscriber: Told of connection state changes and each phone number change.
    /// - Returns: A token that ends the subscription when cancelled or released.
    /// - Throws: `SudoTelephonyError` if the subscription cannot be established.
    func subscribeToPhoneNumbers(owner: String, subscriber: PhoneNumberSubscriber) async throws -> SubscriptionToken

    /// Subscribe to changes to the caller's messages.
    ///
    /// - Parameters:
    ///   - owner: The owner subject the subscription is scoped to.
    ///   - subscriber: Told of connection state changes and each message event.
    /// - Returns: A token that ends the subscription when cancelled or released.
    /// - Throws: `SudoTelephonyError` if the subscription cannot be established.
    func subscribeToPhoneMessages(owner: String, subscriber: PhoneMessageSubscriber) async throws -> SubscriptionToken
}
