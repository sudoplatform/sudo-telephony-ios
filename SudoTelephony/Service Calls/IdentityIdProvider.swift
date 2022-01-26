//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoUser

protocol IdentityIdProviding {
    /// Retrieves and returns the identity ID associated with the temporary credential used for
    /// accessing certain backend resources, e.g. large blobs stored in AWS S3.
    ///
    /// - Returns:Identity ID.
    func getIdentityId() -> String?
}

class IdentityIdProvider: IdentityIdProviding {

    let userClient: SudoUserClient

    init(userClient: SudoUserClient) {
        self.userClient = userClient
    }

    func getIdentityId() -> String? {
        return self.userClient.getIdentityId()
    }
}
