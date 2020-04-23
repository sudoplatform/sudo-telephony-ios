//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// An object representing a conversation between a sudo phone number and one or more
/// participants.  This id of this object will be set as the conversation id on message objects

public struct PhoneMessageConversation {
    /// Enum that represents the direction of the message.
    public enum MessageConversationType {
        case individual
        case group
        case unknown

        init(internalType: ConversationType) {
            switch internalType {
            case .individual:
                self = .individual
            case .group:
                self = .group
            case .unknown(_):
                self = .unknown
            }
        }
    }
        
    /// Unique ID of the conversation. Calculated by calculating the v5 UUID of `localPhoneNumber + remotePhoneNumber` with `owner` as the namespace
    public let id: String
    /// The ID of the owner of the message (also referred to as the subject)
    public let owner: String
    /// The `MessageConversationType` of the conversation
    public let type: MessageConversationType
    /// The id of the latest message in the conversation
    public let latestMessageId: String
    /// The latest phone message
    public var latestPhoneMessage: PhoneMessage?
    /// The creation date of the conversation
    public let created: Date
    /// The date of the last modification to the conversation
    public let updated: Date
}
