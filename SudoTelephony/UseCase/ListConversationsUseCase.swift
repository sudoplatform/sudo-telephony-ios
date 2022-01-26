//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoOperations

class ListConversationsUseCase {

    let conversationService: ConversationServices
    let messageService: MessageServices
    let keyManager: TelephonyKeyManager
    var operationQueue: PlatformOperationQueue = .init()

    init(conversationService: ConversationServices,
         messageService: MessageServices,
         keymanager: TelephonyKeyManager) {
        self.conversationService = conversationService
        self.messageService = messageService
        self.keyManager = keymanager
    }

    func execute(localNumberId: String,
                 limit: Int?,
                 nextToken: String?,
                 completion: @escaping ClientCompletion<TelephonyListToken<PhoneMessageConversation>>) {

        conversationService.getConversations(localNumberId: localNumberId,
                                             limit: limit,
                                             nextToken: nextToken) { result in
            switch result {
            case .success(let list):
                self.fetchMessagesForConversation(list: list, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Fetches conversations and converts the data returned from fetching conversations
    // into client return type.
    private func fetchMessagesForConversation(list: TelephonyListToken<Conversation>,
                                              completion: @escaping ClientCompletion<TelephonyListToken<PhoneMessageConversation>>) {

        guard let keyId = self.keyManager.getKeyId() else {
            // If keyID missing return conversation without decrypted message contents.
            let result = ListConversationsTransformer.transform(conversations: list,
                                                                phoneMessages: [])
            completion(.success(result))
            return
        }

        // Operations to fetch the messages.
        let fetchOperations: [GetMessageOperation] = list.items.map { conversation in
            return GetMessageOperation(messageId: conversation.lastMessage,
                                       keyId: keyId,
                                       messageService: self.messageService,
                                       keyManager: self.keyManager)
        }

        // group operation to fetch all messages and notify when done
        let fetchMessagesOp = PlatformGroupOperation(logger: .telephony,
                                                     operations: fetchOperations)

        // Observe completion of all the message fetches.
        let observer = PlatformBlockObserver(finishHandler:  { _, errors in
            let fetchedMessages = fetchOperations.compactMap({ $0.resultObject })
            let result = ListConversationsTransformer.transform(conversations: list,
                                                   phoneMessages: fetchedMessages)
            completion(.success(result))
        })

        fetchMessagesOp.addObserver(observer)
        self.operationQueue.addOperation(fetchMessagesOp)
    }
}

