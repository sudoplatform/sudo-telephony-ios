//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoTelephonyCommon

/// `ConfigurationRepository` backed by the telephony service's `getTelephonyConfig` query.
final class DefaultConfigurationRepository: ConfigurationRepository, SudoApiGraphQLExecutor {

    // MARK: - Properties

    let sudoApiClient: SudoApiClient

    // MARK: - Lifecycle

    /// Create the repository.
    ///
    /// - Parameter sudoApiClient: The client used to reach the AppSync endpoint.
    init(sudoApiClient: SudoApiClient) {
        self.sudoApiClient = sudoApiClient
    }

    // MARK: - ConfigurationRepository

    func getConfigurationData() async throws -> TelephonyConfigurationData {
        let data = try await fetch(GraphQL.GetTelephonyConfigQuery())
        return ConfigurationTransformer.transform(data.getTelephonyConfig)
    }
}
