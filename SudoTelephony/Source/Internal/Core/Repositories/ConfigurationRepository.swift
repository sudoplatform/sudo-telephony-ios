//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Port for reading how the telephony service is configured.
///
/// Implemented in the data layer by `DefaultConfigurationRepository`.
protocol ConfigurationRepository {

    /// Fetch the service's configuration.
    ///
    /// - Returns: The configuration data.
    /// - Throws: `SudoTelephonyError` if the fetch fails.
    func getConfigurationData() async throws -> TelephonyConfigurationData
}
