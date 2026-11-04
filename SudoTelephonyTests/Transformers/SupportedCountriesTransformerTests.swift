//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import SudoTelephony
import XCTest

final class SupportedCountriesTransformerTests: XCTestCase {

    // MARK: - Tests

    func test_transform_mapsCountriesVerbatim() {
        let result = SupportedCountriesTransformer.transform(["US", "CA", "GB", "NZ"])

        XCTAssertEqual(result, ["US", "CA", "GB", "NZ"])
    }

    func test_transform_mapsEmptyList() {
        let result = SupportedCountriesTransformer.transform([])

        XCTAssertEqual(result, [])
    }
}
