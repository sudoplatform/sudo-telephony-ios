//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import SudoLogging
import SudoOperations

class ListConversationsOperation: PlatformGroupOperation {
    
    var result: [PhoneMessageConversation]?
    var nextToken: String?
    
    // MARK: - Properties: Private
    
    private let input: ConversationFilterInput
    
    private let keyId: String
    
    private unowned let telephonyClient: DefaultSudoTelephonyClient
    
    private unowned let appSyncClient: AWSAppSyncClient
    
    
    // MARK: - Lifecycle
    
    init(input: ConversationFilterInput,
         keyId: String,
         appSyncClient: AWSAppSyncClient,
         telephonyClient: DefaultSudoTelephonyClient,
         logger: Logger) {
        
        self.input = input
        self.keyId = keyId
        self.appSyncClient = appSyncClient
        self.telephonyClient = telephonyClient
        self.result = [PhoneMessageConversation]()
        super.init(logger: logger, operations: [])
    }
    
    override func execute() {
        logger.debug("Getting conversations")
        
        let listQuery = ListConversationsQuery(filter: self.input)
        let queryOperation = PlatformQueryOperation(appSyncClient: self.appSyncClient,
                                                    query: listQuery,
                                                    cachePolicy: .useOnline,
                                                    logger: self.logger)
        
        let completionOperation = PlatformBlockOperation(logger: self.logger) {
            guard let data = queryOperation.result?.listConversations?.items else {
                return
            }

            self.nextToken = queryOperation.result?.listConversations?.nextToken
            
            data.forEach() { item in
                let messageId = item.lastMessage
                let fetchOp = GetMessageOperation(messageId: messageId,
                                                  keyId: self.keyId,
                                                  appSyncClient: self.appSyncClient,
                                                  telephonyClient: self.telephonyClient,
                                                  logger: self.logger)

                let conversationOp = PlatformBlockOperation(logger: self.logger) { [weak self] in
                    guard let self = self else { return }
                    
                    let type = PhoneMessageConversation.MessageConversationType(internalType: item.type)
                    let conversation = PhoneMessageConversation(id: item.id,
                                                                    owner: item.owner,
                                                                    type: type,
                                                                    latestMessageId: messageId,
                                                                    latestPhoneMessage: fetchOp.result,
                                                                    created: Date(timeIntervalSinceNow: TimeInterval(item.updatedAtEpochMs)),
                                                                    updated: Date(timeIntervalSinceNow: TimeInterval(item.updatedAtEpochMs)))
                    self.result?.append(conversation)
                    return
                }
                
                conversationOp.addDependency(fetchOp)
                self.addOperations([fetchOp, conversationOp])
            }
        }
        
        completionOperation.addDependency(queryOperation)
        self.addOperations([queryOperation, completionOperation])
        
        super.execute()
    }
}

