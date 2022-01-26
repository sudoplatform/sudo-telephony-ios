//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoOperations

class GetMessageOperation: PlatformOperation {

    // MARK: Input
    let messageService: MessageServices
    let keyManager: TelephonyKeyManager
    let messageId: String
    let keyId: String

    // MARK: Result
    var resultObject: PhoneMessage?

    // MARK: Lifecycle
    init(messageId: String,
         keyId: String,
         messageService: MessageServices,
         keyManager: TelephonyKeyManager) {
        self.messageId = messageId
        self.keyId = keyId
        self.messageService = messageService
        self.keyManager = keyManager
        super.init(logger: .telephony)
    }

    // Mark: Execute
    override func execute() {
        self.messageService.getMessage(id: self.messageId, keyId: keyId) { result in
            let transformer = PhoneMessageTransformer(keyManager: self.keyManager)
            let result = result.mapThrowing { sealed in
                return try transformer.transformSealed(message: sealed)
            }

            switch result {
            case .success(let message):
                self.resultObject = message
                self.finish()
            case .failure(let error):
                self.finishWithError(error)
            }
        }
    }
}
