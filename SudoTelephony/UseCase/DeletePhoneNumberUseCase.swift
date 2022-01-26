//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation


class DeletePhoneNumberUseCase {

    let service: PhoneNumberServices

    init(service: PhoneNumberServices) {
        self.service = service
    }

    func execute(phoneNumber: String,
                 completion: @escaping ClientCompletion<String>) {
        service.deprovisionNumber(phoneNumber: phoneNumber) { result in
            completion(result)
        }
    }
}
