//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoUser
import SudoOperations

/// Check if the user is signed in.
public class SignedInCondition: PlatformOperationCondition {

    public static var name: String {
        return "SignedInCondition"
    }

    private unowned let userClient: SudoUserClient

    public init(userClient: SudoUserClient) {
        self.userClient = userClient
    }

    public func dependencyForOperation(_ operation: PlatformOperation) -> Operation? {
        return nil
    }

    public func evaluateForOperation(_ operation: PlatformOperation, completion: (PlatformOperationConditionResult) -> Void) {
        guard (try? userClient.getSubject()) != nil else {
            completion(.failure(PlatformOperationErrors.conditionFailed))
            return
        }
        completion(.success(()))
    }
}
