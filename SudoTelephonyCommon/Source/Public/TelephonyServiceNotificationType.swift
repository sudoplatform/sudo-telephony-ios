//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The types of push notification the telephony service sends.
///
/// The service will add types over time. Adding a case is a source-breaking change for code that
/// switches over this enum exhaustively, so it ships in a major version; include a `default` case
/// if you switch over it. A type this SDK version doesn't know decodes as `TelephonyUnknownNotification`.
public enum TelephonyServiceNotificationType: String, Sendable {

    /// An inbound message was received on one of the user's phone numbers.
    case messageReceived
}
