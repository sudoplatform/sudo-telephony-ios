//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// The unsealed payload of a telephony service push notification, decoded by its `type`.
///
/// Decoding throws when `type` is missing, or when a known type is missing one of its fields.
enum TelephonyServiceNotification: Decodable, Equatable {

    // MARK: - Supplementary

    enum CodingKeys: String, CodingKey {
        case type
    }

    // MARK: - Cases

    /// An inbound message was received.
    case messageReceived(MessageReceivedPayload)

    /// A type this version of the SDK doesn't know, carrying the type as sent.
    case unknown(String)

    // MARK: - Properties

    /// The notification type the unsealed payload declared.
    var type: String {
        switch self {
        case .messageReceived: TelephonyServiceNotificationType.messageReceived.rawValue
        case .unknown(let type): type
        }
    }

    // MARK: - Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try container.decode(String.self, forKey: .type)
        guard let knownType = TelephonyServiceNotificationType(rawValue: typeName) else {
            self = .unknown(typeName)
            return
        }
        switch knownType {
        case .messageReceived:
            self = try .messageReceived(MessageReceivedPayload(from: decoder))
        }
    }
}
