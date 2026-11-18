//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoNotificationExtension
import SudoTelephonyCommon

/// A telephony service push notification the SDK could not use.
///
/// Returned for a notification type this version of the SDK doesn't know, a payload in an
/// unsupported format, one sealed to a key this device doesn't hold, or a malformed one.
/// Apps should leave the push's original alert in place when they receive this.
public struct TelephonyUnknownNotification: SudoNotification, Equatable {

    // MARK: - Properties

    /// Always `Constants.serviceName`.
    public let serviceName = Constants.serviceName

    /// The notification's type as the service sent it, or the service name if the type
    /// couldn't be read.
    public let type: String

    // MARK: - Lifecycle

    /// Create an unknown notification.
    ///
    /// - Parameter type: The notification's type as the service sent it.
    public init(type: String) {
        self.type = type
    }
}
