//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging

class ListMessagesUseCase {

    let messageService: MessageServices
    let keyManager: TelephonyKeyManager
    let logger: Logger = .telephony

    init(messageService: MessageServices,
         keyManager: TelephonyKeyManager) {
        self.messageService = messageService
        self.keyManager = keyManager
    }

    func execute(localNumber: String,
                 remoteNumber: String,
                 ownerId: String,
                 limit: Int?,
                 nextToken: String?,
                 completion: @escaping ClientCompletion<TelephonyListToken<PhoneMessage>>) {

        guard let keyId = self.keyManager.getKeyId() else {
            // TODO:
            // This is misleading error, but it keeps behavior the same.
            // consider refactor to "missingKey" or something.
            return completion(.failure(SudoTelephonyClientError.getConversationFailed))
        }

        self.messageService.getMessages(localNumber: localNumber,
                                        remoteNumber: remoteNumber,
                                        ownerId: ownerId,
                                        keyId: keyId,
                                        limit: limit,
                                        nextToken: nextToken) { sealedResult in

            completion(self.unseal(sealedResult: sealedResult))
        }
    }

    func execute(conversationId: String,
                 keyId: String,
                 limit: Int?,
                 nextToken: String?,
                 completion: @escaping ClientCompletion<TelephonyListToken<PhoneMessage>>) {

        guard let keyId = self.keyManager.getKeyId() else {
            // TODO:
            // This is misleading error, but it keeps behavior the same.
            // consider refactor to "missingKey" or something.
            return completion(.failure(SudoTelephonyClientError.getConversationFailed))
        }

        self.messageService.getMessages(conversationId: conversationId,
                                        keyId: keyId,
                                        limit: limit,
                                        nextToken: nextToken) { sealedResult in

            completion(self.unseal(sealedResult: sealedResult))
        }
    }

    // Unseals results from the service.
    private func unseal(sealedResult: Result<TelephonyListToken<SealedMessage>, Error>) -> Result<TelephonyListToken<PhoneMessage>, Error> {
        // Create a transformer to unseal the message
        let transformer = PhoneMessageTransformer(keyManager: self.keyManager)

        return sealedResult.mapThrowing { list in

            // This is more verbose than other transformations.
            // The goal here is to return as many unsealed messages even if some fail
            // to unseal. Logging errors if a failure occurs.
            var unsealedItems: [PhoneMessage] = []
            var lastError: Error?
            for sealed in list.items {
                do {
                    let unsealed = try transformer.transformSealed(message: sealed)
                    unsealedItems.append(unsealed)
                }
                catch {
                    lastError = error
                    self.logger.error("Failed to unseal phone message id: \(sealed.id), error: \(error)")
                }
            }

            // return the unsealed items or throw the last error encountered.
            if let unsealingError = lastError, unsealedItems.isEmpty {
                throw unsealingError
            } else {
                return TelephonyListToken(items: unsealedItems, nextToken: list.nextToken)
            }
        }
    }
}
