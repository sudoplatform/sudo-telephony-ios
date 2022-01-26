//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSAppSync
import Foundation
import SudoApiClient
import SudoLogging
import SudoOperations

// MARK: Protocol Definition

/// MessageService is responsible for CRUD operations on messages.
/// Data returned by this service is sealed.
///
/// Most functions require a keyId.  This is used for the service
/// to filter and seal messages with the key registered with this id.
/// Generally we expect a 1:1 mapping of keys to phone numbers, and it's
/// reasonable that all numbers share a single key.
protocol MessageServices: AnyObject {
    /// Sends an SMS message from a provisioned phone number to another number.
    ///
    /// - Parameter localNumber: The E164 formatted phone number to send the message from. For example: "+14155552671".
    /// - Parameter keyId: The key ID of the local number. Required to fetch the message after sending so
    /// the service only provides results that can be unsealed.
    /// - Parameter remoteNumber: The E164 formatted phone number of the recipient. For example: "+14155552671".
    /// - Parameter body: The body of the SMS message.
    /// - Parameter completion: Provides the PhoneMessage sent on success.
    func sendSMSMessage(localNumber: String,
                        keyId: String,
                        remoteNumber: String,
                        body: String,
                        completion: @escaping ClientCompletion<SealedMessage>)

    /// Sends an MMS message from a provisioned phone number to another number. Media must be uploaded prior to sending.
    ///
    /// - Parameter localNumber: The E164 formatted phone number to send the message from. For example: "+14155552671".
    /// - Parameter keyId: The key ID of the local number. Required to fetch the message after sending so
    /// the service only provides results that can be unsealed.
    /// - Parameter remoteNumber: The E164 formatted phone number of the recipient. For example: "+14155552671".
    /// - Parameter body: The text body of the MMS message.
    /// - Parameter media: Metadata for media previously uploaded to the service prior to sending this message.
    /// - Parameter completion: Provides the phone message sent on completion
    func sendMMSMessage(localNumber: String,
                        keyId: String,
                        remoteNumber: String,
                        body: String?,
                        media: [MediaObject],
                        completion: @escaping ClientCompletion<SealedMessage>)

    /// Retrieves a message matching the associated id.
    ///
    /// - Parameter id: The id of the message to retrieve.
    /// - Parameter keyId: The keyId, used in unsealing messages.  The service will filter messages based on this id.
    /// - Parameter completion: Provides sealed message retrieved from service
    func getMessage(id: String,
                    keyId: String,
                    completion: @escaping ClientCompletion<SealedMessage>)

    /// Retrieves a list of messages matching the specified criteria.
    ///
    /// - Parameter localNumber: The E164 formatted phone number of the participating sudo. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the other participant in the phone conversation. For example: "+14155552671".
    /// - Parameter keyId: KeyID of the key associated with the local number.  Used for sealing and unsealing of data.
    /// - Parameter keyId: KeyID of the key associated with the local number.  Used for sealing and unsealing of data.
    /// - Parameter limit: The maximum number of messages to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of messages or an error if there was a failure.
    func getMessages(localNumber: String,
                     remoteNumber: String,
                     ownerId: String,
                     keyId: String,
                     limit: Int?,
                     nextToken: String?,
                     completion: @escaping ClientCompletion<TelephonyListToken<SealedMessage>>)

    /// Retrieves a list of messages matching the specified criteria.
    ///
    /// - Parameter conversationId: The id of the conversation associated with the messages to be retrieved.
    /// - Parameter limit: The maximum number of messages to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of messages or an error if there was a failure.
    func getMessages(conversationId: String,
                     keyId: String,
                     limit: Int?,
                     nextToken: String?,
                     completion: @escaping ClientCompletion<TelephonyListToken<SealedMessage>>)

    /// Deletes a message matching the associated id.
    ///
    /// - Parameter id: The id of the message to delete.
    /// - Parameter completion: Completion callback providing the id of the deleted message or an error if the message could not be deleted.
    func deleteMessage(id: String,
                       completion: @escaping ClientCompletion<String>)
}

// MARK: MessageService Implementation

/// This service is essentially the simplified GraphQL
/// functionality for performing CRUD operations on messages.
class MessageService: MessageServices
{
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
         logger: Logger = .telephony)
    {
        self.graphQLClient = graphQLClient
        self.queue = queue
        self.logger = logger
    }

    // MARK: Send Message

    func sendSMSMessage(localNumber: String,
                        keyId: String,
                        remoteNumber: String,
                        body: String,
                        completion: @escaping ClientCompletion<SealedMessage>)
    {
        let input = SendMessageInput(from: localNumber, to: remoteNumber, body: body)
        let mutation = SendMessageMutation(input: input)

        let op = operationFactory.generateMutationOperation(mutation: mutation,
                                                            graphQLClient: graphQLClient,
                                                            logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned op, weak self] _, errors in
            if let error = errors.first
            {
                return completion(.failure(error))
            }

            guard let sentMessageId = op.result?.sendMessage
            else
            {
                return completion(.failure(SudoTelephonyClientError.internalError))
            }

            // Fetch the message to provide results
            self?.getMessage(id: sentMessageId, keyId: keyId, completion: completion)
        })

        op.addObserver(observer)
        queue.addOperation(op)
    }

    func sendMMSMessage(localNumber: String,
                        keyId: String,
                        remoteNumber: String,
                        body: String?,
                        media: [MediaObject],
                        completion: @escaping ClientCompletion<SealedMessage>)
    {
        let s3Media = media.map
        {
            S3MediaObjectInput(key: $0.key,
                               bucket: $0.bucket,
                               region: $0.region)
        }

        let input = SendMessageInput(from: localNumber,
                                     to: remoteNumber,
                                     body: body,
                                     media: s3Media,
                                     clientRefId: UUID().uuidString)

        let mutation = SendMessageMutation(input: input)

        let op = operationFactory.generateMutationOperation(mutation: mutation,
                                                            graphQLClient: graphQLClient,
                                                            logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned op, weak self] _, errors in
            if let error = errors.first
            {
                return completion(.failure(error))
            }

            guard let sentMessageId = op.result?.sendMessage
            else
            {
                return completion(.failure(SudoTelephonyClientError.internalError))
            }

            // Fetch the message to provide results
            self?.getMessage(id: sentMessageId, keyId: keyId, completion: completion)
        })

        op.addObserver(observer)
        queue.addOperation(op)
    }

    // MARK: Get Message

    func getMessage(id: String,
                    keyId: String,
                    completion: @escaping ClientCompletion<SealedMessage>)
    {
        let query = GetMessageQuery(id: id, keyId: keyId)
        let op = operationFactory.generateQueryOperation(query: query,
                                                         graphQLClient: graphQLClient,
                                                         logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned op] _, errors in
            if let error = errors.first
            {
                return completion(.failure(error))
            }

            guard let data = op.result?.getMessage
            else
            {
                return completion(.failure(SudoTelephonyClientError.internalError))
            }

            completion(.success(data.fragments.sealedMessage))
        })

        op.addObserver(observer)
        queue.addOperation(op)
    }

    func getMessages(localNumber: String,
                     remoteNumber: String,
                     ownerId: String,
                     keyId: String,
                     limit: Int?,
                     nextToken: String?,
                     completion: @escaping ClientCompletion<TelephonyListToken<SealedMessage>>)
    {
        // Convert the local/remote numbers and owner id into a conversation id
        let conversationId = ConversationIdGenerator.conversationIdWith(localNumber: localNumber,
                                                                        remoteNumber: remoteNumber,
                                                                        ownerId: ownerId)

        // delegate to getMessages with conversation id
        getMessages(conversationId: conversationId,
                    keyId: keyId,
                    limit: limit,
                    nextToken: nextToken,
                    completion: completion)
    }

    func getMessages(conversationId: String,
                     keyId: String,
                     limit: Int?,
                     nextToken: String?,
                     completion: @escaping ClientCompletion<TelephonyListToken<SealedMessage>>)
    {
        let filterInput = MessageFilterInput(conversation: IDFilterInput(eq: conversationId),
                                             keyId: IDFilterInput(eq: keyId))

        let query = ListMessagesQuery(filter: filterInput, limit: limit, nextToken: nextToken)

        let op = operationFactory.generateQueryOperation(query: query,
                                                         graphQLClient: graphQLClient,
                                                         logger: logger)
        let observer = PlatformBlockObserver(finishHandler: { [unowned op] _, errors in
            if let error = errors.first
            {
                return completion(.failure(error))
            }

            guard let data = op.result?.listMessages
            else
            {
                return completion(.failure(SudoTelephonyClientError.internalError))
            }

            // Transform the list messages return objects to a list of SealedMessages to unify types
            let sealedMessages: [SealedMessage]? = data.items?.map {$0.fragments.sealedMessage}

            let returnList = TelephonyListToken(items: sealedMessages ?? [], nextToken: data.nextToken)
            completion(.success(returnList))
        })

        op.addObserver(observer)
        queue.addOperation(op)
    }

    // MARK: Delete Message

    func deleteMessage(id: String,
                       completion: @escaping ClientCompletion<String>)
    {
        let mutation = DeleteMessageMutation(id: id)
        let op = operationFactory.generateMutationOperation(mutation: mutation,
                                                            graphQLClient: graphQLClient,
                                                            logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned op] _, errors in
            if let error = errors.first
            {
                return completion(.failure(error))
            }

            guard let deletedId = op.result?.deleteMessage
            else
            {
                return completion(.failure(SudoTelephonyClientError.internalError))
            }

            completion(.success(deletedId))
        })

        op.addObserver(observer)
        queue.addOperation(op)
    }
}
