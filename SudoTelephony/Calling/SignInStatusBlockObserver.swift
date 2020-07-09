//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoUser

class SignInStatusBlockObserver: SignInStatusObserver {

    var changeBlock: (_ status: SignInStatus) -> Void

    init(statusChanged: @escaping (_ status: SignInStatus) -> Void) {
        self.changeBlock = statusChanged
    }

    /// Notifies the changes to the sign in or refresh token operation.
    ///
    /// - Parameter status: new sign in status.
    func signInStatusChanged(status: SignInStatus) {
        self.changeBlock(status)
    }
}
