//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import SudoLogging
import SudoOperations

internal class GetMessageOperation: PlatformGroupOperation {
    
    var result: PhoneMessage?
    
    // MARK: - Properties: Private
    
    private let messageId: String
    
    private let keyId: String
    
    private unowned let appSyncClient: AWSAppSyncClient
    
    private unowned let telephonyClient: DefaultSudoTelephonyClient
    
    // MARK: - Lifecycle
    
    init(messageId: String,
         keyId: String,
         appSyncClient: AWSAppSyncClient,
         telephonyClient: DefaultSudoTelephonyClient,
         logger: Logger) {

        self.messageId = messageId
        self.keyId = keyId
        self.appSyncClient = appSyncClient
        self.telephonyClient = telephonyClient
        super.init(logger: logger, operations: [])
    }
    
    override func execute() {
        logger.debug("Getting message: \(self.messageId)")
        
        let getMessageQuery = GetMessageQuery(id: self.messageId, keyId: self.keyId)
       
        let queryOperation = PlatformQueryOperation(appSyncClient: self.appSyncClient,
                                                    query: getMessageQuery,
                                                    cachePolicy: .useOnline,
                                                    logger: self.logger)
        
        let completion = PlatformBlockOperation(logger: logger) { [weak self] in
            guard let self = self else {
                return
            }
            
            guard let data = queryOperation.result?.getMessage else {
                return
            }
            
            guard let sealedBody = data.body,
                let sealedBodyData = Data(base64Encoded: sealedBody, options: .ignoreUnknownCharacters),
                let sealedRemoteData = Data(base64Encoded: data.remotePhoneNumber, options: .ignoreUnknownCharacters),
                let sealedLocalData = Data(base64Encoded: data.localPhoneNumber, options: .ignoreUnknownCharacters) else {
                    return
            }
            
            do {
                let decryptedBody = try self.telephonyClient.decryptSealedData(data: sealedBodyData)
                let decryptedRemote = try self.telephonyClient.decryptSealedData(data: sealedRemoteData)
                let decryptedLocal = try self.telephonyClient.decryptSealedData(data: sealedLocalData)
                let bodyText = String(decoding: decryptedBody, as: UTF8.self)
                let remote = String(decoding: decryptedRemote, as: UTF8.self)
                let local = String(decoding: decryptedLocal, as: UTF8.self)
                
                let phoneMessage = PhoneMessage(id: data.id,
                                                    owner: data.owner,
                                                    conversation: data.conversation,
                                                    updated: Date(timeIntervalSinceNow: TimeInterval(data.updatedAtEpochMs)),
                                                    created: Date(timeIntervalSinceNow: TimeInterval(data.createdAtEpochMs)),
                                                    localPhoneNumber: local,
                                                    remotePhoneNumber: remote,
                                                    body: bodyText,
                                                    direction: PhoneMessage.Direction(internalDirection: data.direction),
                                                    state: PhoneMessage.State(internalState: data.state),
                                                    media: data.media?.map { $0.fragments.s3MediaObject } ?? [])
                self.result = phoneMessage
                self.finish()
            } catch {
                return
            }
        }
        
        completion.addDependency(queryOperation)
        addOperations([queryOperation, completion])
        super.execute()
    }
}
