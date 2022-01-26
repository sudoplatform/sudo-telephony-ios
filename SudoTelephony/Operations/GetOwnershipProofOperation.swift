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

/// Get the ownership proof of the sudo.
class GetOwnershipProofOperation: PlatformOperation {

    /// Result of fetching ownership proof.
    var resultObject: String?

    /// Sudo id used to get the ownership proof.
    let sudoId: String

    /// ownership proof provider to fetch the proof.
    let dataProvider: OwnershipProofProviding

    /// Initialize an instance of `GetOwnershipProofOperation`.
    init(sudoId: String, dataProvider: OwnershipProofProviding, logger: Logger) {
        self.sudoId = sudoId
        self.dataProvider = dataProvider
        super.init(logger: logger)
    }

    override func execute() {
        self.dataProvider.getWithSudo(id: sudoId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(ownershipProof):
                self.resultObject = ownershipProof
                self.finish()
            case let .failure(error):
                self.finishWithError(error)
            }
        }
    }
}
