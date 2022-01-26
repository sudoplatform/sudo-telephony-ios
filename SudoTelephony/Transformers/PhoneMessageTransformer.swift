//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

// Using the key manager, decrypts and transforms sealed messages into phone messages.
class PhoneMessageTransformer {

    let keyManager: TelephonyKeyManager
    init(keyManager: TelephonyKeyManager) {
        self.keyManager = keyManager
    }

    func transformSealed(message: SealedMessage) throws -> PhoneMessage {

        // Key id used when querying for data.  We expect a key with this id
        // to be in the key manager for decryption.
        //let keyKid = message.keyId
        PhoneMessage.init(
            id: message.id,
            owner: message.owner,
            conversation: message.conversation,
            updated: Date(epochMs: message.updatedAtEpochMs),
            created: Date(epochMs: message.createdAtEpochMs),
            localPhoneNumber: try keyManager.decrypt(message.localPhoneNumber),
            remotePhoneNumber: try keyManager.decrypt(message.remotePhoneNumber),
            body: try message.body.map { try keyManager.decrypt($0) },
            direction: .init(internalDirection: message.direction),
            state: .init(internalState: message.state),
            media: (message.media ?? []).map { MediaObject(media: $0.fragments.s3MediaObject) }
        )
    }
}


