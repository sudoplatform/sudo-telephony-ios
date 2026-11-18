//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The `data` of a telephony service push notification, before its sealed part is unsealed.
///
/// Only `version` and `type` are required, so a notification in a future shape still reports its real
/// type. The sealing fields are required to decode a `messageReceived` notification, and checked there.
struct SealedTelephonyNotification: Decodable {

    // MARK: - Properties

    /// The payload format version this SDK can decode.
    static let supportedVersion = 1

    /// The algorithm the payload was sealed with, if the payload is sealed.
    let algorithm: String?

    /// ID of the key pair the payload was sealed to, if the payload is sealed.
    let keyId: String?

    /// The base64-encoded sealed payload, if any. It unseals to a JSON `TelephonyServiceNotification`.
    let sealed: String?

    /// The notification type, for example `messageReceived`.
    let type: String

    /// The payload format version.
    let version: Int
}
