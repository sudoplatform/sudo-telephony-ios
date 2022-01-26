//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class ErrorTransformer {

    static func transform(error: Error) -> SudoTelephonyClientError {
        return SudoTelephonyClientError(serviceError: error)
    }
}
