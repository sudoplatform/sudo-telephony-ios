//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Business operation: read how the telephony service is configured.
final class GetConfigurationDataUseCase {

    private let repository: ConfigurationRepository

    init(repository: ConfigurationRepository) {
        self.repository = repository
    }

    /// Execute the operation.
    func execute() async throws -> TelephonyConfigurationData {
        try await repository.getConfigurationData()
    }
}
