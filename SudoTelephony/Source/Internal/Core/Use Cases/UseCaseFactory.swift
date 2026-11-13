//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// The single place use cases are constructed.
///
/// Holds every repository port and exposes one `generate<Operation>UseCase()` per
/// use case.
final class UseCaseFactory {

    // MARK: - Properties

    private let supportedCountriesRepository: SupportedCountriesRepository
    private let configurationRepository: ConfigurationRepository
    private let phoneNumberRepository: PhoneNumberRepository
    private let phoneMessageRepository: PhoneMessageRepository
    private let subscriptionRepository: SubscriptionRepository
    private let deviceKeyManager: DeviceKeyManager
    private let enforceSingletonKeyPair: Bool

    // MARK: - Lifecycle

    init(
        supportedCountriesRepository: SupportedCountriesRepository,
        configurationRepository: ConfigurationRepository,
        phoneNumberRepository: PhoneNumberRepository,
        phoneMessageRepository: PhoneMessageRepository,
        subscriptionRepository: SubscriptionRepository,
        deviceKeyManager: DeviceKeyManager,
        enforceSingletonKeyPair: Bool
    ) {
        self.supportedCountriesRepository = supportedCountriesRepository
        self.configurationRepository = configurationRepository
        self.phoneNumberRepository = phoneNumberRepository
        self.phoneMessageRepository = phoneMessageRepository
        self.subscriptionRepository = subscriptionRepository
        self.deviceKeyManager = deviceKeyManager
        self.enforceSingletonKeyPair = enforceSingletonKeyPair
    }

    // MARK: - Keys

    func generateCreateSingletonKeysIfAbsentUseCase() -> CreateSingletonKeysIfAbsentUseCase {
        CreateSingletonKeysIfAbsentUseCase(deviceKeyManager: deviceKeyManager, enforceSingletonKeyPair: enforceSingletonKeyPair)
    }

    // MARK: - Supported Countries

    func generateGetSupportedCountriesUseCase() -> GetSupportedCountriesUseCase {
        GetSupportedCountriesUseCase(repository: supportedCountriesRepository)
    }

    // MARK: - Configuration

    func generateGetConfigurationDataUseCase() -> GetConfigurationDataUseCase {
        GetConfigurationDataUseCase(repository: configurationRepository)
    }

    // MARK: - Phone Numbers

    func generateSearchAvailablePhoneNumbersUseCase() -> SearchAvailablePhoneNumbersUseCase {
        SearchAvailablePhoneNumbersUseCase(repository: phoneNumberRepository)
    }

    func generateProvisionPhoneNumberUseCase() -> ProvisionPhoneNumberUseCase {
        ProvisionPhoneNumberUseCase(repository: phoneNumberRepository)
    }

    func generateDeprovisionPhoneNumberUseCase() -> DeprovisionPhoneNumberUseCase {
        DeprovisionPhoneNumberUseCase(repository: phoneNumberRepository)
    }

    func generateGetPhoneNumberUseCase() -> GetPhoneNumberUseCase {
        GetPhoneNumberUseCase(repository: phoneNumberRepository)
    }

    func generateListPhoneNumbersUseCase() -> ListPhoneNumbersUseCase {
        ListPhoneNumbersUseCase(repository: phoneNumberRepository)
    }

    func generateListPhoneNumbersForSudoIdUseCase() -> ListPhoneNumbersForSudoIdUseCase {
        ListPhoneNumbersForSudoIdUseCase(repository: phoneNumberRepository)
    }

    // MARK: - Phone Messages

    func generateGetPhoneMessageUseCase() -> GetPhoneMessageUseCase {
        GetPhoneMessageUseCase(repository: phoneMessageRepository)
    }

    func generateListPhoneMessagesForPhoneNumberIdUseCase() -> ListPhoneMessagesForPhoneNumberIdUseCase {
        ListPhoneMessagesForPhoneNumberIdUseCase(repository: phoneMessageRepository)
    }

    func generateListPhoneMessagesForConversationIdUseCase() -> ListPhoneMessagesForConversationIdUseCase {
        ListPhoneMessagesForConversationIdUseCase(repository: phoneMessageRepository)
    }

    func generateDeletePhoneMessagesUseCase() -> DeletePhoneMessagesUseCase {
        DeletePhoneMessagesUseCase(repository: phoneMessageRepository)
    }

    func generateUpdatePhoneMessagesUseCase() -> UpdatePhoneMessagesUseCase {
        UpdatePhoneMessagesUseCase(repository: phoneMessageRepository)
    }

    // MARK: - Subscriptions

    func generateSubscribeToPhoneNumbersUseCase() -> SubscribeToPhoneNumbersUseCase {
        SubscribeToPhoneNumbersUseCase(repository: subscriptionRepository)
    }

    func generateSubscribeToPhoneMessagesUseCase() -> SubscribeToPhoneMessagesUseCase {
        SubscribeToPhoneMessagesUseCase(repository: subscriptionRepository)
    }
}
