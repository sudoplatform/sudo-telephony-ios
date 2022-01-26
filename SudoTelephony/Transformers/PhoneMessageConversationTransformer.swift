//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class PhoneMessageConversationTransformer {
    static func transform(conversation: Conversation, latestMessage: PhoneMessage?) -> PhoneMessageConversation {
        let type = PhoneMessageConversation.MessageConversationType(internalType: conversation.type)
        return PhoneMessageConversation(id: conversation.id,
                                        owner: conversation.owner,
                                        type: type,
                                        latestMessageId: conversation.lastMessage,
                                        latestPhoneMessage: latestMessage,
                                        created: Date(epochMs: conversation.createdAtEpochMs),
                                        updated: Date(epochMs: conversation.createdAtEpochMs))
    }
}
