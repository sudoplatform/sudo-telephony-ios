//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Business operation: search the carrier for available phone numbers.
///
/// A thin pass-through to `PhoneNumberRepository` today; any future domain logic
/// (input validation, result filtering) belongs here, never in the client or
/// repository.
final class SearchAvailablePhoneNumbersUseCase {

    private let repository: PhoneNumberRepository

    init(repository: PhoneNumberRepository) {
        self.repository = repository
    }

    /// Execute the search.
    func execute(
        _ input: SearchAvailablePhoneNumbersInput
    ) async throws -> PhoneNumberSearchResult {
        try await repository.searchAvailablePhoneNumbers(input)
    }
}

/// Business operation: provision a number from a prior search.
final class ProvisionPhoneNumberUseCase {

    private let repository: PhoneNumberRepository

    init(repository: PhoneNumberRepository) {
        self.repository = repository
    }

    /// Execute the provisioning request.
    func execute(_ input: ProvisionPhoneNumberInput) async throws -> PhoneNumber {
        try await repository.provisionPhoneNumber(input)
    }
}

/// Business operation: release a provisioned number.
final class DeprovisionPhoneNumberUseCase {

    private let repository: PhoneNumberRepository

    init(repository: PhoneNumberRepository) {
        self.repository = repository
    }

    /// Execute the release.
    func execute(id: String) async throws -> PhoneNumber {
        try await repository.deprovisionPhoneNumber(id: id)
    }
}

/// Business operation: fetch a single provisioned number.
final class GetPhoneNumberUseCase {

    private let repository: PhoneNumberRepository

    init(repository: PhoneNumberRepository) {
        self.repository = repository
    }

    /// Execute the fetch.
    func execute(id: String) async throws -> PhoneNumber? {
        try await repository.getPhoneNumber(id: id)
    }
}

/// Business operation: list the caller's provisioned numbers.
final class ListPhoneNumbersUseCase {

    private let repository: PhoneNumberRepository

    init(repository: PhoneNumberRepository) {
        self.repository = repository
    }

    /// Execute the list.
    func execute(_ input: ListPhoneNumbersInput) async throws -> ListOutput<PhoneNumber> {
        try await repository.listPhoneNumbers(input)
    }
}

/// Business operation: list the numbers a Sudo owns.
final class ListPhoneNumbersForSudoIdUseCase {

    private let repository: PhoneNumberRepository

    init(repository: PhoneNumberRepository) {
        self.repository = repository
    }

    /// Execute the list.
    func execute(_ input: ListPhoneNumbersForSudoIdInput) async throws -> ListOutput<PhoneNumber> {
        try await repository.listPhoneNumbersForSudoId(input)
    }
}
