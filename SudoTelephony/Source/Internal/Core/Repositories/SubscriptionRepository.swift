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
    ///   - onUpdate: Called with each phone-number change, or a failure.
    /// - Returns: A token that ends the subscription when cancelled or released.
    /// - Throws: `SudoTelephonyError` if the subscription cannot be established.
    func subscribeToPhoneNumberUpdates(
        owner: String,
        onUpdate: @escaping @Sendable (Result<PhoneNumber, Error>) -> Void
    ) async throws -> SubscriptionToken

    /// Subscribe to changes to the caller's messages.
    ///
    /// - Parameters:
    ///   - owner: The owner subject the subscription is scoped to.
    ///   - onEvent: Called with each message event, or a failure. The event carries
    ///     metadata only; fetch content with `getPhoneMessage(id:)`.
    /// - Returns: A token that ends the subscription when cancelled or released.
    /// - Throws: `SudoTelephonyError` if the subscription cannot be established.
    func subscribeToPhoneMessageEvents(
        owner: String,
        onEvent: @escaping @Sendable (Result<PhoneMessageEvent, Error>) -> Void
    ) async throws -> SubscriptionToken
}
