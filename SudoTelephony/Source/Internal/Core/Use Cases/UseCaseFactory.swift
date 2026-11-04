//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The single place use cases are constructed.
///
/// Holds every repository port and exposes one `generate<Operation>UseCase()` per
/// use case.
final class UseCaseFactory {

    // MARK: - Properties

    private let supportedCountriesRepository: SupportedCountriesRepository
    private let phoneNumberRepository: PhoneNumberRepository
    private let phoneMessageRepository: PhoneMessageRepository
    private let subscriptionRepository: SubscriptionRepository

    // MARK: - Lifecycle

    init(
        supportedCountriesRepository: SupportedCountriesRepository,
        phoneNumberRepository: PhoneNumberRepository,
        phoneMessageRepository: PhoneMessageRepository,
        subscriptionRepository: SubscriptionRepository
    ) {
        self.supportedCountriesRepository = supportedCountriesRepository
        self.phoneNumberRepository = phoneNumberRepository
        self.phoneMessageRepository = phoneMessageRepository
        self.subscriptionRepository = subscriptionRepository
    }

    // MARK: - Supported Countries

    func generateGetSupportedCountriesUseCase() -> GetSupportedCountriesUseCase {
        GetSupportedCountriesUseCase(repository: supportedCountriesRepository)
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

    // MARK: - Phone Messages

    func generateGetPhoneMessageUseCase() -> GetPhoneMessageUseCase {
        GetPhoneMessageUseCase(repository: phoneMessageRepository)
    }

    func generateListPhoneMessagesUseCase() -> ListPhoneMessagesUseCase {
        ListPhoneMessagesUseCase(repository: phoneMessageRepository)
    }

    func generateDeletePhoneMessagesUseCase() -> DeletePhoneMessagesUseCase {
        DeletePhoneMessagesUseCase(repository: phoneMessageRepository)
    }

    func generateUpdatePhoneMessagesUseCase() -> UpdatePhoneMessagesUseCase {
        UpdatePhoneMessagesUseCase(repository: phoneMessageRepository)
    }

    // MARK: - Subscriptions

    func generateSubscribeToPhoneNumberUpdatesUseCase() -> SubscribeToPhoneNumberUpdatesUseCase {
        SubscribeToPhoneNumberUpdatesUseCase(repository: subscriptionRepository)
    }

    func generateSubscribeToPhoneMessageEventsUseCase() -> SubscribeToPhoneMessageEventsUseCase {
        SubscribeToPhoneMessageEventsUseCase(repository: subscriptionRepository)
    }
}
