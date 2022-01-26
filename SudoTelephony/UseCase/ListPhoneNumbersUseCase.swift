//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class ListPhoneNumbersUseCase {

    let service: PhoneNumberServices

    init(service: PhoneNumberServices) {
        self.service = service
    }

    func execute(sudoID: String?,
                 limit: Int?,
                 nextToken: String?,
                 completion: @escaping ClientCompletion<TelephonyListToken<PhoneNumber>>) {
        service.listPhoneNumbers(sudoId: sudoID,
                                 limit: limit,
                                 nextToken: nextToken,
                                 completion: completion)
    }
}

