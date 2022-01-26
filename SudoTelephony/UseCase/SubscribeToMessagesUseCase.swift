//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging

class SubscribeToMessagesUseCase {

    let service: SubscriptionServices
    let keyManager: TelephonyKeyManager

    internal init(service: SubscriptionServices,
                  keyManager: TelephonyKeyManager) {
        self.service = service
        self.keyManager = keyManager
    }

    func execute(ownerId: String,
                 statusObserver: SubscriptionHandler<SubscriptionStatus>?,
                 resultHandler: @escaping SubscriptionHandler<PhoneMessage>) throws -> SubscriptionToken? {
        return try service.subscribeToMessages(ownerId: ownerId, statusObserver: {
            statusObserver?(SubscriptionStatusTransformer.fromService(status: $0))
        }, resultHandler: { [keyManager] sealedMessage in
            let transformer = PhoneMessageTransformer(keyManager: keyManager)
            guard let phoneMessage = try? transformer.transformSealed(message: sealedMessage) else {
                Logger.telephony.error("Failed to unseal message with id \(sealedMessage.id)")
                return
            }
            resultHandler(phoneMessage)
        })
    }
}
