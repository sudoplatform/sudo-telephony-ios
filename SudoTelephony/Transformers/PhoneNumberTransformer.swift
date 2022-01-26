//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

enum PhoneNumberTransformer {
    static func fromService(object: SudoPhoneNumber) -> PhoneNumber {
        let number = PhoneNumber(
            id: object.id,
            phoneNumber: object.phoneNumber,
            state: PhoneNumber.State(internalState: object.state),
            version: object.version,
            created: Date(epochMs: object.createdAtEpochMs),
            updated: Date(epochMs: object.createdAtEpochMs)
        )
        return number
    }
}
