//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

// Conversation id's can be generated from known pieces of data using a v5 UUID.
class ConversationIdGenerator {
    /// Generates a conversation id based on locally available data.
    static func conversationIdWith(localNumber: String, remoteNumber: String, ownerId: String) -> String {
        let uuid = UUID.init(v5WithNameSpace: ownerId,
                             name: localNumber + remoteNumber)
        return "tl-cnv-" + uuid.uuidString.lowercased()
    }
}
