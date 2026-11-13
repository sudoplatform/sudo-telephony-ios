//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon
import SudoUser

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

    // MARK: - Configuration

    /// Fetch how the telephony service is configured, for example whether provisioning
    /// requires a Sudo ownership proof, and the search and list limits.
    func getConfigurationData() async throws -> TelephonyConfigurationData

    // MARK: - Phone Number Management

    /// Search the carrier for phone numbers available to provision.
    func searchAvailablePhoneNumbers(
        withInput input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult

    /// Provision a number returned by a prior search. The SDK generates and registers
    /// the key its inbound messages are sealed to.
    func provisionPhoneNumber(withInput input: ProvisionPhoneNumberInput) async throws -> PhoneNumber

    /// Release a provisioned number back to the carrier. Without a singleton key pair, the
    /// number's key pair is then removed from the device. If that fails, this throws
    /// `SudoTelephonyError.keyPairRemovalFailed`, which carries the released number.
    func deprovisionPhoneNumber(withId id: String) async throws -> PhoneNumber

    /// Fetch a single provisioned number by ID (`nil` if absent or not the caller's).
    func getPhoneNumber(withId id: String) async throws -> PhoneNumber?

    /// List the caller's provisioned numbers, including any belonging to their Sudos.
    /// Use `PhoneNumber.sudoId` to find a Sudo's numbers.
    func listPhoneNumbers(withInput input: ListPhoneNumbersInput) async throws -> ListOutput<PhoneNumber>

    /// List the numbers a Sudo owns, oldest first. Released numbers aren't included,
    /// and another user's Sudo lists nothing.
    func listPhoneNumbersForSudoId(withInput input: ListPhoneNumbersForSudoIdInput) async throws -> ListOutput<PhoneNumber>

    // MARK: - SMS

    /// Fetch and unseal a single message by ID (`nil` if absent or not the caller's).
    func getPhoneMessage(withId id: String) async throws -> PhoneMessage?

    /// List and unseal a phone number's messages, newest first by default.
    ///
    /// - Returns: `success` with the page if every message was unsealed, or `partial`
    ///   with the readable messages and, for each message that couldn't be unsealed
    ///   (for example because this device doesn't have its key), a
    ///   `PartialPhoneMessage` and the reason.
    func listPhoneMessagesForPhoneNumberId(
        withInput input: ListPhoneMessagesForPhoneNumberIdInput
    ) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage>

    /// List and unseal the messages of one conversation, newest first by default,
    /// with partial results as for `listPhoneMessagesForPhoneNumberId(withInput:)`.
    func listPhoneMessagesForConversationId(
        withInput input: ListPhoneMessagesForConversationIdInput
    ) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage>

    /// Delete a batch of the caller's messages, up to
    /// `TelephonyConfigurationData.deletePhoneMessagesLimit`.
    func deletePhoneMessages(withInput input: DeletePhoneMessagesInput) async throws -> PhoneMessageBatchResult

    /// Set the read state of a batch of the caller's messages, up to
    /// `TelephonyConfigurationData.updatePhoneMessagesLimit`.
    func updatePhoneMessages(withInput input: UpdatePhoneMessagesInput) async throws -> PhoneMessageBatchResult

    // MARK: - Subscriptions

    /// Subscribe to real-time changes to the caller's phone numbers, for example a number
    /// being provisioned becoming `active` or `failed`.
    ///
    /// The subscriber is told when the subscription connects, and when it disconnects
    /// with the cause. After a disconnect the subscription has ended, and the caller must
    /// subscribe again. Retain the token while updates are wanted; cancel or release it to
    /// stop. The subscriber is held weakly.
    ///
    /// - Throws: `SudoTelephonyError.notSignedIn` if no user is signed in.
    func subscribeToPhoneNumbers(subscriber: PhoneNumberSubscriber) async throws -> SubscriptionToken

    /// Subscribe to real-time changes to the caller's phone messages: received, updated or
    /// deleted. An event carries no message content; fetch the message with
    /// `getPhoneMessage(withId:)` to read its text.
    ///
    /// Connection state and the token behave as for `subscribeToPhoneNumbers(subscriber:)`.
    ///
    /// - Throws: `SudoTelephonyError.notSignedIn` if no user is signed in.
    func subscribeToPhoneMessages(subscriber: PhoneMessageSubscriber) async throws -> SubscriptionToken

    // MARK: - Sign-In Delegate

    /// Set a delegate to sign the user in when an operation is attempted while they
    /// aren't signed in, so an app can launch without waiting to sign in first.
    ///
    /// When set, every operation except subscriptions and the on-device key
    /// operations (`reset()`, `exportKeys()`, `importKeys(archiveData:)`) first checks
    /// whether the user is signed in, and if not calls the delegate's `signIn()`. If
    /// `signIn()` throws, the error is passed to the caller and the operation doesn't
    /// run.
    ///
    /// - Parameter delegate: The delegate, or `nil` to stop checking.
    func setSignInDelegate(_ delegate: SudoPlatformSignInDelegate?) async

    // MARK: - Lifecycle

    /// Create the singleton key pair every phone number is sealed to, if this device
    /// doesn't have it.
    ///
    /// Requires `SudoTelephonyClientConfig.enforceSingletonKeyPair`. Call it once the
    /// user is signed in, before provisioning: provisioning never creates the key, and
    /// fails with `SudoTelephonyError.singletonKeyPairNotFound` without it.
    ///
    /// The result says whether the key had to be created. If it was, the device's key
    /// material has changed, so back the keys up again with `exportKeys()`. If the
    /// user already has phone numbers, a new key also means this device doesn't have
    /// the one they're sealed to (for example a second device, or one whose keys were
    /// removed), so import the user's key backup with `importKeys(archiveData:)`.
    ///
    /// - Returns: Whether the singleton key pair was created, and its ID.
    /// - Throws: `SudoTelephonyError.invalidConfig` if the client doesn't enforce a
    ///   singleton key pair; otherwise `SudoTelephonyError` if the key can't be
    ///   created.
    func createSingletonKeysIfAbsent() async throws -> CreateSingletonKeysIfAbsentResult

    /// Remove all on-device key material held by the SDK.
    ///
    /// Call when the user signs out or resets, to tear down local keys. This includes
    /// the singleton key pair, so call `createSingletonKeysIfAbsent()` again before
    /// provisioning.
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
