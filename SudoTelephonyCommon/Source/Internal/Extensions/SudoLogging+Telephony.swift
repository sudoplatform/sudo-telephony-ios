//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging

public extension Logger {

    /// Logger used internally in the SudoTelephony SDK.
    static let telephonySDKLogger = Logger(identifier: "SudoTelephony", driver: NSLogDriver(level: .debug))
}
