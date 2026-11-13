//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoKeyManager
import SudoTelephonyCommon
import SudoUser

/// The default `SudoTelephonyClient` implementation and composition root.
///
/// Each public method is a thin adapter: it generates the relevant use case from the
/// `UseCaseFactory` and awaits its result. No business logic lives in the client.
public final class DefaultSudoTelephonyClient: SudoTelephonyClient {

    // MARK: - Properties

    private let useCaseFactory: UseCaseFactory
    private let deviceKeyManager: DeviceKeyManager

    /// The signed-in user's subject, which subscriptions are scoped to.
    private let subject: @Sendable () async throws -> String?

    /// Signs the user in through the app's sign-in delegate, if it has set one, before an operation that needs it.
    private let signInGuard: SignInGuard?

    // MARK: - Lifecycle

    /// Create the client for the signed-in user of `userClient`, using the
    /// `telephonyService` section of `sudoplatformconfig.json`, with the default
    /// `SudoTelephonyClientConfig`.
    ///
    /// - Parameters: As for `init(keyNamespace:userClient:keyManager:config:)`.
    /// - Throws: As for `init(keyNamespace:userClient:keyManager:config:)`.
    public convenience init(
        keyNamespace: String = Constants.defaultKeyNamespace,
        userClient: SudoUserClient,
        keyManager: SudoKeyManager? = nil
    ) throws {
        try self.init(
            keyNamespace: keyNamespace,
            userClient: userClient,
            keyManager: keyManager,
            config: SudoTelephonyClientConfig()
        )
    }

    /// Create the client for the signed-in user of `userClient`, using the
    /// `telephonyService` section of `sudoplatformconfig.json`.
    ///
    /// - Parameters:
    ///   - keyNamespace: Namespace isolating this SDK's keys in the keychain. Used only
    ///     when `keyManager` is `nil`, to build the SDK's own key manager. Defaults to
    ///     `Constants.defaultKeyNamespace`.
    ///   - userClient: The user client the app signs in with.
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
    ///   - config: Options for the client's behaviour, such as whether every phone
    ///     number shares one key pair.
    /// - Throws: `SudoTelephonyError.invalidConfig` if the configuration has no
    ///   `telephonyService` section.
    public convenience init(
        keyNamespace: String = Constants.defaultKeyNamespace,
        userClient: SudoUserClient,
        keyManager: SudoKeyManager? = nil,
        config: SudoTelephonyClientConfig
    ) throws {
        let sudoApiClient: SudoApiClient?
        do {
            sudoApiClient = try SudoApiClientManager.instance?.getClient(sudoUserClient: userClient, configNamespace: Self.configNamespace)
        } catch ApiOperationError.invalidArgument {
            // The client manager reports a missing configuration section this way.
            throw SudoTelephonyError.invalidConfig
        }
        guard let sudoApiClient else {
            throw SudoTelephonyError.invalidConfig
        }
        self.init(
            sudoApiClient: sudoApiClient,
            userClient: userClient,
            keyNamespace: keyNamespace,
            keyManager: keyManager,
            config: config
        )
    }

    /// Create the client with an already configured `SudoApiClient` and the default
    /// `SudoTelephonyClientConfig`.
    ///
    /// - Parameters: As for `init(sudoApiClient:userClient:keyNamespace:keyManager:config:)`.
    public convenience init(
        sudoApiClient: SudoApiClient,
        userClient: SudoUserClient,
        keyNamespace: String = Constants.defaultKeyNamespace,
        keyManager: SudoKeyManager? = nil
    ) {
        self.init(
            sudoApiClient: sudoApiClient,
            userClient: userClient,
            keyNamespace: keyNamespace,
            keyManager: keyManager,
            config: SudoTelephonyClientConfig()
        )
    }

    /// Create the client with an already configured `SudoApiClient`, for apps that
    /// build their own, for example to point at a different endpoint. Most apps use
    /// `init(keyNamespace:userClient:keyManager:config:)`.
    ///
    /// - Parameters:
    ///   - sudoApiClient: The client used to reach the telephony service's AppSync
    ///     GraphQL endpoint.
    ///   - userClient: The user client the app signs in with.
    ///   - keyNamespace: As for `init(keyNamespace:userClient:keyManager:config:)`.
    ///   - keyManager: As for `init(keyNamespace:userClient:keyManager:config:)`.
    ///   - config: As for `init(keyNamespace:userClient:keyManager:config:)`.
    public init(
        sudoApiClient: SudoApiClient,
        userClient: SudoUserClient,
        keyNamespace: String = Constants.defaultKeyNamespace,
        keyManager: SudoKeyManager? = nil,
        config: SudoTelephonyClientConfig
    ) {
        let deviceKeyManager: DeviceKeyManager = keyManager.map(DefaultDeviceKeyManager.init(keyManager:))
            ?? DefaultDeviceKeyManager(keyNamespace: keyNamespace)
        let supportedCountriesRepository = DefaultSupportedCountriesRepository(sudoApiClient: sudoApiClient)
        let configurationRepository = DefaultConfigurationRepository(sudoApiClient: sudoApiClient)
        let phoneNumberRepository = DefaultPhoneNumberRepository(
            sudoApiClient: sudoApiClient,
            deviceKeyManager: deviceKeyManager,
            enforceSingletonKeyPair: config.enforceSingletonKeyPair
        )
        let phoneMessageRepository = DefaultPhoneMessageRepository(
            sudoApiClient: sudoApiClient,
            deviceKeyManager: deviceKeyManager,
            phoneNumberRepository: phoneNumberRepository
        )
        let subscriptionRepository = DefaultSubscriptionRepository(sudoApiClient: sudoApiClient)
        self.deviceKeyManager = deviceKeyManager
        subject = { [weak userClient] in try await userClient?.getSubject() }
        signInGuard = SignInGuard(userClient: userClient)
        useCaseFactory = UseCaseFactory(
            supportedCountriesRepository: supportedCountriesRepository,
            configurationRepository: configurationRepository,
            phoneNumberRepository: phoneNumberRepository,
            phoneMessageRepository: phoneMessageRepository,
            subscriptionRepository: subscriptionRepository,
            deviceKeyManager: deviceKeyManager,
            enforceSingletonKeyPair: config.enforceSingletonKeyPair
        )
    }

    /// Create the client with a pre-built `UseCaseFactory` and device key manager.
    ///
    /// Used by unit tests to inject mock repositories without touching the data layer.
    init(
        useCaseFactory: UseCaseFactory,
        deviceKeyManager: DeviceKeyManager,
        signInGuard: SignInGuard? = nil,
        subject: @escaping @Sendable () async throws -> String? = { nil }
    ) {
        self.useCaseFactory = useCaseFactory
        self.deviceKeyManager = deviceKeyManager
        self.signInGuard = signInGuard
        self.subject = subject
    }

    // MARK: - Supported Countries

    public func getSupportedCountries() async throws -> [String] {
        try await ensureSignedIn()
        let useCase = useCaseFactory.generateGetSupportedCountriesUseCase()
        return try await useCase.execute()
    }

    // MARK: - Configuration

    public func getConfigurationData() async throws -> TelephonyConfigurationData {
        try await ensureSignedIn()
        return try await useCaseFactory.generateGetConfigurationDataUseCase().execute()
    }

    // MARK: - Phone Number Management

    public func searchAvailablePhoneNumbers(
        withInput input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult {
        try await ensureSignedIn()
        return try await useCaseFactory.generateSearchAvailablePhoneNumbersUseCase().execute(input)
    }

    public func provisionPhoneNumber(withInput input: ProvisionPhoneNumberInput) async throws -> PhoneNumber {
        try await ensureSignedIn()
        return try await useCaseFactory.generateProvisionPhoneNumberUseCase().execute(input)
    }

    public func deprovisionPhoneNumber(withId id: String) async throws -> PhoneNumber {
        try await ensureSignedIn()
        return try await useCaseFactory.generateDeprovisionPhoneNumberUseCase().execute(id: id)
    }

    public func getPhoneNumber(withId id: String) async throws -> PhoneNumber? {
        try await ensureSignedIn()
        return try await useCaseFactory.generateGetPhoneNumberUseCase().execute(id: id)
    }

    public func listPhoneNumbers(withInput input: ListPhoneNumbersInput) async throws -> ListOutput<PhoneNumber> {
        try await ensureSignedIn()
        return try await useCaseFactory.generateListPhoneNumbersUseCase().execute(input)
    }

    public func listPhoneNumbersForSudoId(withInput input: ListPhoneNumbersForSudoIdInput) async throws -> ListOutput<PhoneNumber> {
        try await ensureSignedIn()
        return try await useCaseFactory.generateListPhoneNumbersForSudoIdUseCase().execute(input)
    }

    // MARK: - SMS

    public func getPhoneMessage(withId id: String) async throws -> PhoneMessage? {
        try await ensureSignedIn()
        return try await useCaseFactory.generateGetPhoneMessageUseCase().execute(id: id)
    }

    public func listPhoneMessagesForPhoneNumberId(
        withInput input: ListPhoneMessagesForPhoneNumberIdInput
    ) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage> {
        try await ensureSignedIn()
        return try await useCaseFactory.generateListPhoneMessagesForPhoneNumberIdUseCase().execute(input)
    }

    public func listPhoneMessagesForConversationId(
        withInput input: ListPhoneMessagesForConversationIdInput
    ) async throws -> ListAPIResult<PhoneMessage, PartialPhoneMessage> {
        try await ensureSignedIn()
        return try await useCaseFactory.generateListPhoneMessagesForConversationIdUseCase().execute(input)
    }

    public func deletePhoneMessages(withInput input: DeletePhoneMessagesInput) async throws -> PhoneMessageBatchResult {
        try await ensureSignedIn()
        return try await useCaseFactory.generateDeletePhoneMessagesUseCase().execute(input)
    }

    public func updatePhoneMessages(withInput input: UpdatePhoneMessagesInput) async throws -> PhoneMessageBatchResult {
        try await ensureSignedIn()
        return try await useCaseFactory.generateUpdatePhoneMessagesUseCase().execute(input)
    }

    // MARK: - Subscriptions

    public func subscribeToPhoneNumbers(subscriber: PhoneNumberSubscriber) async throws -> SubscriptionToken {
        try await useCaseFactory.generateSubscribeToPhoneNumbersUseCase()
            .execute(owner: requireSubject(), subscriber: subscriber)
    }

    public func subscribeToPhoneMessages(subscriber: PhoneMessageSubscriber) async throws -> SubscriptionToken {
        try await useCaseFactory.generateSubscribeToPhoneMessagesUseCase()
            .execute(owner: requireSubject(), subscriber: subscriber)
    }

    // MARK: - Sign-In Delegate

    public func setSignInDelegate(_ delegate: SudoPlatformSignInDelegate?) async {
        await signInGuard?.setDelegate(delegate)
    }

    // MARK: - Lifecycle

    public func createSingletonKeysIfAbsent() async throws -> CreateSingletonKeysIfAbsentResult {
        try await useCaseFactory.generateCreateSingletonKeysIfAbsentUseCase().execute()
    }

    public func reset() throws {
        try deviceKeyManager.removeAllKeys()
    }

    public func exportKeys() throws -> Data {
        try deviceKeyManager.exportKeys()
    }

    public func importKeys(archiveData: Data) throws {
        try deviceKeyManager.importKeys(archiveData: archiveData)
    }

    // MARK: - Helpers

    /// The stanza in `sudoplatformconfig.json` holding the telephony service's configuration.
    private static let configNamespace = "telephonyService"

    /// Signs the user in through the app's sign-in delegate first, if it has set one and the user isn't signed in.
    private func ensureSignedIn() async throws {
        try await signInGuard?.ensureSignedIn()
    }

    /// The signed-in user's subject, which subscriptions are scoped to.
    private func requireSubject() async throws -> String {
        guard let subject = try await subject() else {
            throw SudoTelephonyError.notSignedIn
        }
        return subject
    }
}
