//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Port for reading and managing a phone number's messages.
///
/// Implementations are responsible for unsealing the sealed fields (`body`,
/// `remotePhoneNumber`) before returning public `PhoneMessage` values, using the key
/// that seals the owning phone number's messages. Declared in the core; implemented
/// in the data layer by `DefaultPhoneMessageRepository`.
protocol PhoneMessageRepository {

    /// Fetch and unseal a single message by ID.
    ///
    /// - Parameter id: The ID of the message.
    /// - Returns: The unsealed message, or `nil` if it does not exist or is not the
    ///   caller's.
    /// - Throws: `SudoTelephonyError` if the fetch or unsealing fails.
    func getPhoneMessage(id: String) async throws -> PhoneMessage?

    /// List and unseal a phone number's messages.
    ///
    /// - Parameter input: The phone number, optional conversation filter, and paging.
    /// - Returns: A page of unsealed messages with an optional continuation token.
    /// - Throws: `SudoTelephonyError` if the fetch or unsealing fails.
    func listPhoneMessages(_ input: ListPhoneMessagesInput) async throws -> PhoneMessageListToken

    /// Delete up to 100 of the caller's messages.
    ///
    /// - Parameter ids: The IDs to delete.
    /// - Returns: Which IDs were deleted and which were not found or not the caller's.
    /// - Throws: `SudoTelephonyError` if the request fails.
    func deletePhoneMessages(ids: [String]) async throws -> PhoneMessageBatchResult

    /// Set the read state of up to 100 of the caller's messages.
    ///
    /// - Parameters:
    ///   - ids: The IDs to update.
    ///   - seen: The read state to set.
    /// - Returns: Which IDs were updated and which were not found or not the caller's.
    /// - Throws: `SudoTelephonyError` if the request fails.
    func updatePhoneMessages(ids: [String], seen: Bool) async throws -> PhoneMessageBatchResult
}
