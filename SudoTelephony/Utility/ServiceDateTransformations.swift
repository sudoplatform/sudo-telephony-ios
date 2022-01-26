//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

extension Date {
    /// Dates come back from the service in ms and we need to convert.
    /// This is to consolidate logic as we convert data from the graphQL layer
    /// to our entities.
    init(epochMs: Double) {
        self.init(timeIntervalSince1970: epochMs / 1000)
    }
}
