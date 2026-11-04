//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Port for reading the telephony service's supported countries.
///
/// Declares *what* the core needs, not *how* it is fetched. Implemented in the data
/// layer by `DefaultSupportedCountriesRepository`.
protocol SupportedCountriesRepository {

    /// Fetch the ISO country codes the telephony service supports.
    ///
    /// - Returns: The supported ISO country codes.
    /// - Throws: `SudoTelephonyError` if the fetch fails.
    func getSupportedCountries() async throws -> [String]
}
