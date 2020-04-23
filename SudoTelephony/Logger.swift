//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging

extension Logger {
    static let telephonyClientLogger = Logger(identifier: "telephonyClient", driver: NSLogDriver(level: .debug))
}
