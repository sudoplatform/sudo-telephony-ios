//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class GetMessageUseCase {

    let messageService: MessageServices
    let keyManager: TelephonyKeyManager

    init(messageService: MessageServices,
         keyManager: TelephonyKeyManager) {
        self.messageService = messageService
        self.keyManager = keyManager
    }

    func execute(id: String,
                 completion: @escaping ClientCompletion<PhoneMessage>) {

        guard let keyId = self.keyManager.getKeyId() else {
            // TODO:
            // This is misleading error, but it keeps behavior the same.
            // consider refactor to "missingKey" or something.
            return completion(.failure(SudoTelephonyClientError.getMessageFailed))
        }

        self.messageService.getMessage(id: id, keyId: keyId) { result in
            let transformer = PhoneMessageTransformer(keyManager: self.keyManager)
            let unsealedResult = result.mapThrowing { sealed in
                return try transformer.transformSealed(message: sealed)
            }

            completion(unsealedResult)
        }
    }
}
