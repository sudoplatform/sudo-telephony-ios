//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging
import OSLog

internal extension SudoLogging.Logger {
    static let telephonyDriver = TelephonyLogDriver(level: .debug)
    static let telephony = Logger(identifier: "SudoTelephony", driver: telephonyDriver)
}

// log driver for telephony sdk.
//
// This is a wrapper around NSLogDriver because:
// NSLogDriver appears to allow you to change the log level via its
// log level property, but it's a value type, and the logger holds an
// immutable reference.
class TelephonyLogDriver: LogDriverProtocol {

    // MARK: - Properties: LogDriverProtocol

    var logLevel: LogLevel {
        didSet {
            self.driver = .init(level: logLevel)
        }
    }

    var driver: NSLogDriver

    // MARK: - Lifecycle

    init(level: LogLevel) {
        self.logLevel = level
        self.driver = .init(level: level)
    }

    // MARK: - Conformance: LogDriverProtocol

    func outputMessage(_ message: String) {
        driver.outputMessage(message)
    }

    func outputError(_ error: Error, withUserInfo userInfo: [String: Any]?) {
        driver.outputError(error, withUserInfo: userInfo)
    }
}
