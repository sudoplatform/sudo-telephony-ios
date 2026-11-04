//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Business operation: read the telephony service's supported countries.
///
/// A thin pass-through to `SupportedCountriesRepository` today; any future domain
/// logic (validation, composition) belongs here, never in the client or repository.
final class GetSupportedCountriesUseCase {

    // MARK: - Properties

    private let repository: SupportedCountriesRepository

    // MARK: - Lifecycle

    /// Create the use case.
    ///
    /// - Parameter repository: The supported-countries repository port.
    init(repository: SupportedCountriesRepository) {
        self.repository = repository
    }

    // MARK: - Methods

    /// Execute the operation.
    ///
    /// - Returns: The ISO country codes supported by the service.
    /// - Throws: `SudoTelephonyError` if the operation fails.
    func execute() async throws -> [String] {
        try await repository.getSupportedCountries()
    }
}
