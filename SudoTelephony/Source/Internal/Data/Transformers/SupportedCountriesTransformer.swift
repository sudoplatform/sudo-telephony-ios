//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Maps the generated supported-countries response to the public domain type (an
/// array of ISO country codes).
///
/// Pure and independently testable — it performs no I/O.
enum SupportedCountriesTransformer {

    /// Transform the decoded country list into the public list of ISO country codes.
    ///
    /// - Parameter countries: The ISO country codes decoded from the response.
    /// - Returns: The ISO country codes supported by the service.
    static func transform(_ countries: [String]) -> [String] {
        countries
    }
}
