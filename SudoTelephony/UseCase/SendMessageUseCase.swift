//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class SendMessageUseCase {

    let messageService: MessageServices
    let mediaService: MessageMediaServices
    let keyManager: TelephonyKeyManager

    init(messageService: MessageServices,
         mediaService: MessageMediaServices,
         keyManager: TelephonyKeyManager) {
        self.messageService = messageService
        self.mediaService = mediaService
        self.keyManager = keyManager
    }

    /// Send an SMS message
    func execute(localNumber: String,
                 remoteNumber: String,
                 body: String,
                 completion: @escaping ClientCompletion<PhoneMessage>) {

        guard let keyId = self.keyManager.getKeyId() else {
            // TODO:
            // This is misleading error, but it keeps behavior the same.
            // consider refactor to "missingKey" or something.
            return completion(.failure(SudoTelephonyClientError.messageSendFailed))
        }

        self.messageService.sendSMSMessage(localNumber: localNumber,
                                           keyId: keyId,
                                           remoteNumber: remoteNumber,
                                           body: body) { serviceResult in
            let transformer = PhoneMessageTransformer(keyManager: self.keyManager)
            let unsealedResult = serviceResult.mapThrowing { sealed in
                return try transformer.transformSealed(message: sealed)
            }
            completion(unsealedResult)
        }
    }

    /// Send an MMS message with attachment.
    func execute(localNumber: String,
                 remoteNumber: String,
                 body: String?,
                 mediaAttachment: URL,
                 completion: @escaping ClientCompletion<PhoneMessage>) {

        guard let keyId = self.keyManager.getKeyId() else {
            // TODO:
            // This is misleading error, but it keeps behavior the same.
            // consider refactor to "missingKey" or something.
            return completion(.failure(SudoTelephonyClientError.messageSendFailed))
        }

        self.mediaService.uploadFile(url: mediaAttachment) { result in
            switch result {
            case .success(let mediaObject):
                self.messageService.sendMMSMessage(localNumber: localNumber,
                                                    keyId: keyId,
                                                    remoteNumber: remoteNumber,
                                                    body: body,
                                                    media: [mediaObject],
                                                    completion: { serviceResult in
                    let transformer = PhoneMessageTransformer(keyManager: self.keyManager)
                    let unsealedResult = serviceResult.mapThrowing { sealed in
                        return try transformer.transformSealed(message: sealed)
                    }
                    completion(unsealedResult)
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
