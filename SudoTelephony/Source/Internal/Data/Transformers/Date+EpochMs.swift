//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

extension Date {

    /// A date from the service's timestamps, which are milliseconds since the Unix epoch.
    init(epochMs: Double) {
        self.init(timeIntervalSince1970: epochMs / 1000)
    }
}
