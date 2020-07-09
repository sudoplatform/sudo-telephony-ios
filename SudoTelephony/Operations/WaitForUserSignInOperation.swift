//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

import Foundation
import AWSAppSync
import SudoLogging
import SudoOperations
import SudoUser

class WaitForUserSignInOperation: PlatformOperation, SignInStatusObserver {
    let userClient: SudoUserClient
    let observerID = UUID().uuidString

    init(sudoUserClient: SudoUserClient, logger: Logger) {
        self.userClient = sudoUserClient
        super.init(logger: logger)
    }

    override func execute() {
        self.userClient.registerSignInStatusObserver(id: observerID, observer: self)

        do {
            guard try self.userClient.isSignedIn() else {
                return
            }

            self.userClient.deregisterSignInStatusObserver(id: observerID)
            self.finish()
        }
        catch {
            self.userClient.deregisterSignInStatusObserver(id: observerID)
            self.finish([error])
        }
    }

    func signInStatusChanged(status: SignInStatus) {
        guard case .signedIn = status else { return }
        self.userClient.deregisterSignInStatusObserver(id: observerID)
        self.finish()
    }
}


