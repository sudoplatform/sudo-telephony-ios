//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class DeleteMessageUseCase {

    let messageService: MessageServices

    init(messageService: MessageServices) { 
        self.messageService = messageService
    }

    func execute(id: String,
                 completion: @escaping ClientCompletion<String>) {
        messageService.deleteMessage(id: id, completion: completion)
    }
}
