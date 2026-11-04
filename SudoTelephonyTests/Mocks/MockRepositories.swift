//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import SudoTelephony
import SudoTelephonyCommon

/// Mock `SupportedCountriesRepository` returning a canned result.
final class MockSupportedCountriesRepository: SupportedCountriesRepository {
    var result: Result<[String], Error> = .success([])
    func getSupportedCountries() async throws -> [String] { try result.get() }
}

/// Mock `PhoneNumberRepository` recording calls and returning canned results.
final class MockPhoneNumberRepository: PhoneNumberRepository {
    var searchResult: Result<PhoneNumberSearchResult, Error> = .failure(AnyError.unexpected)
    var provisionResult: Result<PhoneNumber, Error> = .failure(AnyError.unexpected)
    var deprovisionResult: Result<PhoneNumber, Error> = .failure(AnyError.unexpected)
    var getResult: Result<PhoneNumber?, Error> = .success(nil)
    var listResult: Result<PhoneNumberListToken, Error> = .failure(AnyError.unexpected)
    var sealingKeyIdResult: Result<String?, Error> = .success("key-1")

    private(set) var sealingKeyIdRequestedFor: [String] = []

    func searchAvailablePhoneNumbers(
        _ input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult { try searchResult.get() }

    func provisionPhoneNumber(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber {
        try provisionResult.get()
    }

    func deprovisionPhoneNumber(id: String) async throws -> PhoneNumber { try deprovisionResult.get() }

    func getPhoneNumber(id: String) async throws -> PhoneNumber? { try getResult.get() }

    func listPhoneNumbers(_ input: ListPhoneNumbersInput) async throws -> PhoneNumberListToken {
        try listResult.get()
    }

    func sealingKeyId(forPhoneNumberId phoneNumberId: String) async throws -> String? {
        sealingKeyIdRequestedFor.append(phoneNumberId)
        return try sealingKeyIdResult.get()
    }
}

/// Mock `PhoneMessageRepository`.
final class MockPhoneMessageRepository: PhoneMessageRepository {
    var getResult: Result<PhoneMessage?, Error> = .success(nil)
    var listResult: Result<PhoneMessageListToken, Error> = .failure(AnyError.unexpected)
    var deleteResult: Result<PhoneMessageBatchResult, Error> = .failure(AnyError.unexpected)
    var updateResult: Result<PhoneMessageBatchResult, Error> = .failure(AnyError.unexpected)

    func getPhoneMessage(id: String) async throws -> PhoneMessage? { try getResult.get() }

    func listPhoneMessages(_ input: ListPhoneMessagesInput) async throws -> PhoneMessageListToken {
        try listResult.get()
    }

    func deletePhoneMessages(ids: [String]) async throws -> PhoneMessageBatchResult {
        try deleteResult.get()
    }

    func updatePhoneMessages(ids: [String], seen: Bool) async throws -> PhoneMessageBatchResult {
        try updateResult.get()
    }
}

/// Mock `SubscriptionRepository` capturing handlers so a test can emit events.
final class MockSubscriptionRepository: SubscriptionRepository {
    private(set) var numberHandler: ((Result<PhoneNumber, Error>) -> Void)?
    private(set) var eventHandler: ((Result<PhoneMessageEvent, Error>) -> Void)?
    private(set) var lastToken: MockSubscriptionToken?
    var subscribeError: Error?

    func subscribeToPhoneNumberUpdates(
        owner: String,
        onUpdate: @escaping @Sendable (Result<PhoneNumber, Error>) -> Void
    ) async throws -> SubscriptionToken {
        if let subscribeError { throw subscribeError }
        numberHandler = onUpdate
        let token = MockSubscriptionToken()
        lastToken = token
        return token
    }

    func subscribeToPhoneMessageEvents(
        owner: String,
        onEvent: @escaping @Sendable (Result<PhoneMessageEvent, Error>) -> Void
    ) async throws -> SubscriptionToken {
        if let subscribeError { throw subscribeError }
        eventHandler = onEvent
        let token = MockSubscriptionToken()
        lastToken = token
        return token
    }
}

/// A `SubscriptionToken` mock recording cancellation.
final class MockSubscriptionToken: SubscriptionToken, @unchecked Sendable {
    private(set) var cancelCallCount = 0
    func cancel() { cancelCallCount += 1 }
}

extension UseCaseFactory {
    /// Build a factory from individual mock repositories for client/use-case tests.
    static func mock(
        supportedCountries: SupportedCountriesRepository = MockSupportedCountriesRepository(),
        phoneNumber: PhoneNumberRepository = MockPhoneNumberRepository(),
        phoneMessage: PhoneMessageRepository = MockPhoneMessageRepository(),
        subscription: SubscriptionRepository = MockSubscriptionRepository()
    ) -> UseCaseFactory {
        UseCaseFactory(
            supportedCountriesRepository: supportedCountries,
            phoneNumberRepository: phoneNumber,
            phoneMessageRepository: phoneMessage,
            subscriptionRepository: subscription
        )
    }
}
