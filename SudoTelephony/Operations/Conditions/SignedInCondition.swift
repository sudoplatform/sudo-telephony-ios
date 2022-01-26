//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoUser
import SudoOperations

/// Check if the user is signed in.
class SignedInCondition: PlatformOperationCondition {

    public static var name: String {
        return "SignedInCondition"
    }

    private let ownerIdProvider: OwnerIdProvider

    init(ownerIdProvider: OwnerIdProvider) {
        self.ownerIdProvider = ownerIdProvider
    }

    func dependencyForOperation(_ operation: PlatformOperation) -> Operation? {
        return nil
    }

    func evaluateForOperation(_ operation: PlatformOperation, completion: (PlatformOperationConditionResult) -> Void) {
        guard ownerIdProvider.resolveOwnerId() != nil else {
            completion(.failure(PlatformOperationErrors.conditionFailed))
            return
        }
        completion(.success(()))
    }
}
