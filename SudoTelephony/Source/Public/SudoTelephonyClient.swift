//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// The consumer-facing API for the Sudo Telephony SDK.
///
/// Consumers should code to this protocol, not to the concrete
/// `DefaultSudoTelephonyClient`.
public protocol SudoTelephonyClient: AnyObject {

    // MARK: - Supported Countries

    /// Fetch the countries the telephony service currently supports.
    ///
    /// - Returns: The supported countries as ISO 3166-1 alpha-2 country codes.
    /// - Throws: `SudoTelephonyError` if the operation fails.
    func getSupportedCountries() async throws -> [String]

    // MARK: - Phone Number Management

    /// Search the carrier for phone numbers available to provision.
    func searchAvailablePhoneNumbers(
        _ input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult

    /// Provision a number returned by a prior search. The SDK generates and registers
    /// the key its inbound messages are sealed to.
    func provisionPhoneNumber(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber

    /// Release a provisioned number back to the carrier.
    func deprovisionPhoneNumber(id: String) async throws -> PhoneNumber

    /// Fetch a single provisioned number by ID (`nil` if absent or not the caller's).
    func getPhoneNumber(id: String) async throws -> PhoneNumber?

    /// List the caller's provisioned numbers.
    func listPhoneNumbers(_ input: ListPhoneNumbersInput) async throws -> PhoneNumberListToken

    // MARK: - SMS

    /// Fetch and unseal a single message by ID (`nil` if absent or not the caller's).
    func getPhoneMessage(id: String) async throws -> PhoneMessage?

    /// List and unseal a phone number's inbox.
    func listPhoneMessages(_ input: ListPhoneMessagesInput) async throws -> PhoneMessageListToken

    /// Delete up to 100 of the caller's messages.
    func deletePhoneMessages(ids: [String]) async throws -> PhoneMessageBatchResult

    /// Set the read state of up to 100 of the caller's messages.
    func updatePhoneMessages(ids: [String], seen: Bool) async throws -> PhoneMessageBatchResult

    // MARK: - Subscriptions

    /// Subscribe to real-time changes to the caller's phone numbers. Retain the token
    /// while updates are wanted; cancel or release it to stop.
    func subscribeToPhoneNumberUpdates(
        owner: String,
        onUpdate: @escaping @Sendable (Result<PhoneNumber, Error>) -> Void
    ) async throws -> SubscriptionToken

    /// Subscribe to real-time message events (metadata only; fetch content with
    /// `getPhoneMessage(id:)`). Retain the token while events are wanted.
    func subscribeToPhoneMessageEvents(
        owner: String,
        onEvent: @escaping @Sendable (Result<PhoneMessageEvent, Error>) -> Void
    ) async throws -> SubscriptionToken

    // MARK: - Lifecycle

    /// Remove all on-device key material held by the SDK.
    ///
    /// Call when the user signs out or resets, to tear down local keys. Per-number
    /// keys are not deleted on deprovision; key lifetime is tied to this reset, in
    /// line with the platform convention.
    ///
    /// - Throws: `SudoTelephonyError` if the removal fails.
    func reset() throws

    /// Export the SDK's cryptographic keys to a portable key archive.
    ///
    /// Use this to move a user's message-sealing keys to another device or to back
    /// them up before a reinstall, so retained sealed messages remain readable. The
    /// returned data contains private key material and must be stored securely.
    ///
    /// - Returns: The serialized key archive.
    /// - Throws: `SudoTelephonyError` if the export fails.
    func exportKeys() throws -> Data

    /// Import cryptographic keys from an archive produced by `exportKeys()`.
    ///
    /// Existing on-device keys are removed before the archive is restored.
    ///
    /// - Parameter archiveData: The key archive to import.
    /// - Throws: `SudoTelephonyError` if the archive is invalid or the import fails.
    func importKeys(archiveData: Data) throws
}
