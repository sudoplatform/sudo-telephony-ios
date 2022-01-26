//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import Foundation
import SudoLogging
import AWSAppSync
import SudoOperations
import SudoApiClient

protocol ConversationServices {
    func getConversation(conversationId: String,
                         completion: @escaping ClientCompletion<Conversation>)

    func getConversations(localNumberId: String,
                          limit: Int?,
                          nextToken: String?,
                          completion: @escaping ClientCompletion<TelephonyListToken<Conversation>>)
}

class ConversationService: ConversationServices {
    // MARK: - Properties

    /// App sync client for performing operations against the telephony service.
    var graphQLClient: SudoApiClient

    /// Used to log diagnostic and error information.
    var logger: Logger

    /// Utility factory class to generate mutation and query operations.
    var operationFactory = OperationFactory()

    /// Operation queue for enqueuing asynchronous tasks.
    var queue: PlatformOperationQueue

    // MARK: - Lifecycle

    /// Initialize an instance of `AvailableNumberProvider`.
    init(graphQLClient: SudoApiClient,
         queue: PlatformOperationQueue = PlatformOperationQueue(),
         logger: Logger = .telephony) {
        self.graphQLClient = graphQLClient
        self.queue = queue
        self.logger = logger
    }

    func getConversation(conversationId: String,
                                completion: @escaping ClientCompletion<Conversation>) {
        let query = GetConversationQuery(id: conversationId)
        let op = self.operationFactory.generateQueryOperation(query: query,
                                                              graphQLClient: self.graphQLClient,
                                                              logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned op] _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            guard let conversation = op.result?.getConversation?.fragments.conversation else {
                completion(.failure(SudoTelephonyClientError.internalError))
                return
            }

            completion(.success(conversation))
        })

        op.addObserver(observer)
        self.queue.addOperation(op)
    }

    func getConversations(localNumberId: String,
                          limit: Int?,
                          nextToken: String?,
                          completion: @escaping ClientCompletion<TelephonyListToken<Conversation>>) {

        let numberFilter = IDFilterInput(eq: localNumberId)
        let input: ConversationFilterInput = ConversationFilterInput(phoneNumberId: numberFilter,
                                                                     createdAtEpochMs: FloatFilterInput(ge: 0),
                                                                     updatedAtEpochMs: nil,
                                                                     and: nil,
                                                                     or: nil,
                                                                     not: nil)

        let query = ListConversationsQuery(filter: input, limit: limit, nextToken: nextToken)
        let op = self.operationFactory.generateQueryOperation(query: query,
                                                              graphQLClient: self.graphQLClient,
                                                              logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned op] _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            guard let listConversations = op.result?.listConversations else {
                completion(.failure(SudoTelephonyClientError.internalError))
                return
            }

            let items = listConversations.items?.map({
                return $0.fragments.conversation
            })

            let returnData = TelephonyListToken.init(items: items ?? [],
                                                nextToken: listConversations.nextToken)
            completion(.success(returnData))
        })

        op.addObserver(observer)
        self.queue.addOperation(op)
    }
}
