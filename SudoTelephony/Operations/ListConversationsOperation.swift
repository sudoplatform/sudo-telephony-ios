//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import SudoLogging
import SudoOperations

class ListConversationsOperation: PlatformOperation {
    
    var result: TelephonyListToken<PhoneMessageConversation>?
    
    // MARK: - Properties: Private
    
    private let input: ConversationFilterInput
    
    private let keyId: String

    private let nextToken: String?

    private let limit: Int?
    
    private let keyManager: TelephonyKeyManager
    
    private unowned let appSyncClient: AWSAppSyncClient

    let queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: - Lifecycle
    
    init(input: ConversationFilterInput,
         keyId: String,
         limit: Int?,
         nextToken: String?,
         appSyncClient: AWSAppSyncClient,
         keyManager: TelephonyKeyManager,
         logger: Logger) {
        
        self.input = input
        self.keyId = keyId
        self.limit = limit
        self.nextToken = nextToken
        self.appSyncClient = appSyncClient
        self.keyManager = keyManager
        super.init(logger: logger)
    }
    
    override func execute() {
        logger.debug("Getting conversations")

        let listQuery = ListConversationsQuery(filter: self.input, limit: self.limit, nextToken: self.nextToken)

        self.appSyncClient.fetch(query: listQuery, cachePolicy: .fetchIgnoringCacheData, queue: self.queue) { (result, error) in

            guard error == nil else {
                self.finishWithError(error)
                return
            }

            guard result?.errors?.first == nil else {
                self.finishWithError(result?.errors?.first)
                return
            }

            guard let items = result?.data?.listConversations?.items else {
                self.finishWithError(SudoTelephonyClientError.internalError)
                return
            }

            // The next page of data
            let nextPage = result?.data?.listConversations?.nextToken

            // now we need to go through each item and make an api call to fetch the message.
            // The plan is to create a dispatch group so we know when they are all complete.
            // for thread safety we also need a dispatchqueue here to run things async

            // An array to hold the converations as they are finalized
            let conversations = SynchronizedArray<PhoneMessageConversation>()

            // A dispatch group to make sure all messages are downloaded for the different conversations returned
            let group = DispatchGroup()

            // Loop through all of the conversations and fetch the last message for each.
            for item in items {

                //Enter the group before fetching the message
                group.enter()

                let messageId = item.lastMessage
                self.logger.debug("Getting message: \(messageId)")

                // Create the message query and fetch the message
                let query = GetMessageQuery(id: messageId, keyId: self.keyId)
                self.appSyncClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: self.queue) { (fetchMessageResult, error) in

                    if let error = error {
                        //Log an error.  Failure to fetch the latest message doesn't affect return of the conversations
                        self.logger.error("Error fetching message id: \(messageId) for conversation: \(item.id), error: \(error)")
                    }

                    if let error = fetchMessageResult?.errors?.first {
                        //Log an error.  Failure to fetch the latest message doesn't affect return of the conversations
                        self.logger.error("Error fetching message id: \(messageId) for conversation: \(item.id), error: \(error)")
                    }

                    let latestPhoneMessage: PhoneMessage?
                    if let message = fetchMessageResult?.data?.getMessage {
                        do {
                            try latestPhoneMessage = PhoneMessage(decrypting: message.fragments.sealedMessage, keyManager: self.keyManager)
                        }
                        catch {
                            self.logger.error("Error creating PhoneMessage \(messageId) from provided data: \(error)")
                            latestPhoneMessage = nil
                        }
                    } else {
                        latestPhoneMessage = nil
                    }

                    // Conversation and message data fetch finished. Finalize creating the PhoneMessage and the PhoneMessageConveration.
                    // Append to the results arrray using the async queue for thread safety.
                    let type = PhoneMessageConversation.MessageConversationType(internalType: item.type)
                    let conversation = PhoneMessageConversation(
                        id: item.id,
                        owner: item.owner,
                        type: type,
                        latestMessageId: messageId,
                        latestPhoneMessage: latestPhoneMessage,
                        created: Date(timeIntervalSince1970: item.createdAtEpochMs / 1000),
                        updated: Date(timeIntervalSince1970: item.updatedAtEpochMs / 1000)
                    )
                    conversations.append(conversation)

                    // All done.  Leave the dispatch group.
                    group.leave()
                }
            }

            // Wait for all results to come in.
            group.wait()

            self.result = TelephonyListToken(items: conversations.contents, nextToken: nextPage)
            self.finish()
        }
    }
}
