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

/// Fetches the keyRingId from the keychain, or generates a keypair and registers it with the
/// service.  This is a dependency to provision a phone number.
class GetKeyRingIdOperation: PlatformOperation {

    // MARK: Params
    var keyManager: TelephonyKeyManager
    var identityId: String
    var publicKeyCreator: PublicKeyGenerating

    // Mark: Output
    var resultObject: String?

    internal init(identityId: String,
                  keyManager: TelephonyKeyManager,
                  publicKeyCreator: PublicKeyGenerating,
                  logger: Logger)
    {
        self.identityId = identityId
        self.keyManager = keyManager
        self.publicKeyCreator = publicKeyCreator
        super.init(logger: logger)
    }

    override func execute() {
        // Look in the keychain for the data and return
        if let keyRingId = self.keyManager.getKeyRingId() {
            self.resultObject = keyRingId
            self.finish()
        } else {
            //otherwise generate a keypair.
            publicKeyCreator.generateKeyPair(identityId: identityId) { result in
                switch result {
                case .success(let tuple):
                    self.resultObject = tuple.keyRingId
                    self.finish()
                case .failure(let error):
                    self.finishWithError(error)
                }
            }
        }
    }
}
