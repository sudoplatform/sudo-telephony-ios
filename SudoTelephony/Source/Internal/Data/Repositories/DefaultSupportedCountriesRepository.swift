//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient

/// GraphQL-backed implementation of `SupportedCountriesRepository`.
///
/// Builds the generated query, executes it through `SudoApiGraphQLExecutor` (which
/// centralises error translation), and maps the response through
/// `SupportedCountriesTransformer`.
final class DefaultSupportedCountriesRepository: SupportedCountriesRepository, SudoApiGraphQLExecutor {

    // MARK: - Properties

    let sudoApiClient: SudoApiClient

    // MARK: - Lifecycle

    /// Create the repository.
    ///
    /// - Parameter sudoApiClient: The client used to reach the AppSync endpoint.
    init(sudoApiClient: SudoApiClient) {
        self.sudoApiClient = sudoApiClient
    }

    // MARK: - SupportedCountriesRepository

    func getSupportedCountries() async throws -> [String] {
        let query = GraphQL.GetSupportedCountriesQuery()
        let data = try await fetch(query)
        return SupportedCountriesTransformer.transform(data.getSupportedCountriesForTelephony)
    }
}
