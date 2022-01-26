//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoOperations

class GetConversationUseCase {

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

    func execute(conversationId: String,
                 completion: @escaping ClientCompletion<PhoneMessageConversation>) {
        conversationService.getConversation(conversationId: conversationId) { result in
            switch result {
            case .success(let conversation):
                guard let keyId = self.keyManager.getKeyId() else {
                    let conversation = PhoneMessageConversationTransformer.transform(conversation: conversation,
                                                                                     latestMessage: nil)
                    completion(.success(conversation))
                    return
                }
                self.fetchMessage(conversation: conversation, keyId: keyId, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Fetches conversations and converts the data returned from fetching conversations
    // into client return type.
    private func fetchMessage(conversation: Conversation,
                              keyId: String,
                              completion: @escaping ClientCompletion<PhoneMessageConversation>) {

        let op = GetMessageOperation(messageId: conversation.lastMessage,
                                     keyId: keyId,
                                     messageService: messageService,
                                     keyManager: keyManager)

        // ignore op and errors passed into handler
        op.addObserver(PlatformBlockObserver(finishHandler: { [unowned op] _, _ in
            let conversation = PhoneMessageConversationTransformer.transform(conversation: conversation,
                                                                             latestMessage: op.resultObject)
            completion(.success(conversation))
        }))

        operationQueue.addOperation(op)
    }
}
