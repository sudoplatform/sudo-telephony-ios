//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class ListConversationsTransformer {

    static func transform(conversations: TelephonyListToken<Conversation>,
                          phoneMessages: [PhoneMessage]) -> TelephonyListToken<PhoneMessageConversation> {

        // Create a lookup table for the fetched messages, a dictionary keyed by message id
        var lookupTable: [String: PhoneMessage] = [:]
        phoneMessages.forEach {
            lookupTable[$0.id] = $0
        }

        let transformed = conversations.items.map({
            return PhoneMessageConversationTransformer.transform(conversation: $0,
                                                                 latestMessage: lookupTable[$0.lastMessage])
        })

        return .init(items: transformed,
                     nextToken: conversations.nextToken)
    }
}

