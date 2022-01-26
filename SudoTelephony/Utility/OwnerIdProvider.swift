//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoUser

// OwnerID is used extensively when sending graphQL requests (e.g. subscriptions)
// This abstracts the concept of the owner ID from the value used - SudoUser.getSubject.
class OwnerIdProvider {
    private let userClient: SudoUserClient
    init(userClient: SudoUserClient) {
        self.userClient = userClient
    }

    // This is like the id of the currently signed in user so it must be resolved when needed.
    func resolveOwnerId() -> String? {
        return try? userClient.getSubject()
    }
}
