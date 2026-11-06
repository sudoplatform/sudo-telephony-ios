//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Port for provisioning and managing phone numbers.
///
/// Declares *what* the core needs, not *how* it is fetched. Implemented in the data
/// layer by `DefaultPhoneNumberRepository`.
protocol PhoneNumberRepository {

    /// Search the carrier for available phone numbers.
    ///
    /// - Parameter input: The country, optional area code, and limit to search with.
    /// - Returns: The search result, including the numbers found and its expiry.
    /// - Throws: `SudoTelephonyError` if the search fails.
    func searchAvailablePhoneNumbers(
        _ input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult

    /// Provision a number returned by a prior search.
    ///
    /// - Parameter input: The search ID, number, and optional ownership proof.
    /// - Returns: The number in `PROVISIONING`. Completion is reported out of band.
    /// - Throws: `SudoTelephonyError` if the request fails.
    func provisionPhoneNumber(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber

    /// Release a provisioned number back to the carrier.
    ///
    /// - Parameter id: The ID of the number to release.
    /// - Returns: The number in its post-release state.
    /// - Throws: `SudoTelephonyError` if the request fails.
    func deprovisionPhoneNumber(id: String) async throws -> PhoneNumber

    /// Fetch a single provisioned number by ID.
    ///
    /// - Parameter id: The ID of the number.
    /// - Returns: The number, or `nil` if it does not exist or is not the caller's.
    /// - Throws: `SudoTelephonyError` if the fetch fails.
    func getPhoneNumber(id: String) async throws -> PhoneNumber?

    /// List the caller's provisioned numbers.
    ///
    /// - Parameter input: Optional paging controls.
    /// - Returns: A page of numbers with an optional continuation token.
    /// - Throws: `SudoTelephonyError` if the fetch fails.
    func listPhoneNumbers(_ input: ListPhoneNumbersInput) async throws -> ListOutput<PhoneNumber>

    /// List the numbers a Sudo owns.
    ///
    /// - Parameter input: The Sudo, and optional paging controls.
    /// - Returns: A page of numbers with an optional continuation token.
    /// - Throws: `SudoTelephonyError` if the fetch fails.
    func listPhoneNumbersForSudoId(_ input: ListPhoneNumbersForSudoIdInput) async throws -> ListOutput<PhoneNumber>

    /// Resolve the key the given phone number's messages are sealed to.
    ///
    /// Used by the message layer to unseal content. Returns the first key in the
    /// number's key ring, which is the key pair the SDK generated when provisioning.
    ///
    /// - Parameter phoneNumberId: The phone number whose sealing key is needed.
    /// - Returns: The key ID, or `nil` if the number or its key ring cannot be found.
    /// - Throws: `SudoTelephonyError` if the lookup fails.
    func sealingKeyId(forPhoneNumberId phoneNumberId: String) async throws -> String?
}
