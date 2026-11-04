//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoKeyManager
import SudoTelephonyCommon

/// The default `SudoTelephonyClient` implementation and composition root.
///
/// Each public method is a thin adapter: it generates the relevant use case from the
/// `UseCaseFactory` and awaits its result. No business logic lives in the client.
public final class DefaultSudoTelephonyClient: SudoTelephonyClient {

    // MARK: - Properties

    private let useCaseFactory: UseCaseFactory
    private let deviceKeyManager: DeviceKeyManager

    // MARK: - Lifecycle

    /// Create the client with a configured `SudoApiClient`.
    ///
    /// - Parameters:
    ///   - sudoApiClient: The client used to reach the telephony service's AppSync
    ///     GraphQL endpoint, resolved from the `telephonyService` configuration.
    ///   - keyNamespace: Namespace isolating this SDK's keys in the keychain. Used only
    ///     when `keyManager` is `nil`, to build the SDK's own key manager. Defaults to
    ///     `"sudo-telephony"`.
    ///   - keyManager: An optional caller-supplied `SudoKeyManager` to back on-device
    ///     key generation, storage, and unsealing. Leave `nil` (the default) to let the
    ///     SDK build a `DefaultSudoKeyManager` from `keyNamespace`.
    ///
    ///     - Important: A supplied key manager must perform AES-GCM for
    ///       `decryptWithSymmetricKey` (as `DefaultSudoKeyManager` does), to match the
    ///       service's `RSAEncryptionOAEPAESGCM` envelope. `LegacySudoKeyManager`
    ///       performs AES-CBC and would fail to unseal every message. Supplying a key
    ///       manager is opt-in for callers who need to control the keychain
    ///       configuration (service name, key tag, access group); the default path
    ///       remains unchanged for everyone else.
    public init(
        sudoApiClient: SudoApiClient,
        keyNamespace: String = "sudo-telephony",
        keyManager: SudoKeyManager? = nil
    ) {
        let deviceKeyManager: DeviceKeyManager = keyManager.map(DefaultDeviceKeyManager.init(keyManager:))
            ?? DefaultDeviceKeyManager(keyNamespace: keyNamespace)
        let supportedCountriesRepository = DefaultSupportedCountriesRepository(sudoApiClient: sudoApiClient)
        let phoneNumberRepository = DefaultPhoneNumberRepository(
            sudoApiClient: sudoApiClient,
            deviceKeyManager: deviceKeyManager
        )
        let phoneMessageRepository = DefaultPhoneMessageRepository(
            sudoApiClient: sudoApiClient,
            deviceKeyManager: deviceKeyManager,
            phoneNumberRepository: phoneNumberRepository
        )
        let subscriptionRepository = DefaultSubscriptionRepository(sudoApiClient: sudoApiClient)
        self.deviceKeyManager = deviceKeyManager
        useCaseFactory = UseCaseFactory(
            supportedCountriesRepository: supportedCountriesRepository,
            phoneNumberRepository: phoneNumberRepository,
            phoneMessageRepository: phoneMessageRepository,
            subscriptionRepository: subscriptionRepository
        )
    }

    /// Create the client with a pre-built `UseCaseFactory` and device key manager.
    ///
    /// Used by unit tests to inject mock repositories without touching the data layer.
    init(useCaseFactory: UseCaseFactory, deviceKeyManager: DeviceKeyManager) {
        self.useCaseFactory = useCaseFactory
        self.deviceKeyManager = deviceKeyManager
    }

    // MARK: - Supported Countries

    public func getSupportedCountries() async throws -> [String] {
        let useCase = useCaseFactory.generateGetSupportedCountriesUseCase()
        return try await useCase.execute()
    }

    // MARK: - Phone Number Management

    public func searchAvailablePhoneNumbers(
        _ input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult {
        try await useCaseFactory.generateSearchAvailablePhoneNumbersUseCase().execute(input)
    }

    public func provisionPhoneNumber(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber {
        try await useCaseFactory.generateProvisionPhoneNumberUseCase().execute(input)
    }

    public func deprovisionPhoneNumber(id: String) async throws -> PhoneNumber {
        try await useCaseFactory.generateDeprovisionPhoneNumberUseCase().execute(id: id)
    }

    public func getPhoneNumber(id: String) async throws -> PhoneNumber? {
        try await useCaseFactory.generateGetPhoneNumberUseCase().execute(id: id)
    }

    public func listPhoneNumbers(_ input: ListPhoneNumbersInput) async throws -> PhoneNumberListToken {
        try await useCaseFactory.generateListPhoneNumbersUseCase().execute(input)
    }

    // MARK: - SMS

    public func getPhoneMessage(id: String) async throws -> PhoneMessage? {
        try await useCaseFactory.generateGetPhoneMessageUseCase().execute(id: id)
    }

    public func listPhoneMessages(_ input: ListPhoneMessagesInput) async throws -> PhoneMessageListToken {
        try await useCaseFactory.generateListPhoneMessagesUseCase().execute(input)
    }

    public func deletePhoneMessages(ids: [String]) async throws -> PhoneMessageBatchResult {
        try await useCaseFactory.generateDeletePhoneMessagesUseCase().execute(ids: ids)
    }

    public func updatePhoneMessages(ids: [String], seen: Bool) async throws -> PhoneMessageBatchResult {
        try await useCaseFactory.generateUpdatePhoneMessagesUseCase().execute(ids: ids, seen: seen)
    }

    // MARK: - Subscriptions

    public func subscribeToPhoneNumberUpdates(
        owner: String,
        onUpdate: @escaping @Sendable (Result<PhoneNumber, Error>) -> Void
    ) async throws -> SubscriptionToken {
        try await useCaseFactory.generateSubscribeToPhoneNumberUpdatesUseCase()
            .execute(owner: owner, onUpdate: onUpdate)
    }

    public func subscribeToPhoneMessageEvents(
        owner: String,
        onEvent: @escaping @Sendable (Result<PhoneMessageEvent, Error>) -> Void
    ) async throws -> SubscriptionToken {
        try await useCaseFactory.generateSubscribeToPhoneMessageEventsUseCase()
            .execute(owner: owner, onEvent: onEvent)
    }

    // MARK: - Lifecycle

    public func reset() throws {
        try deviceKeyManager.removeAllKeys()
    }

    public func exportKeys() throws -> Data {
        try deviceKeyManager.exportKeys()
    }

    public func importKeys(archiveData: Data) throws {
        try deviceKeyManager.importKeys(archiveData: archiveData)
    }
}
