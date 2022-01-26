//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

class GetPhoneNumberUseCase {

    let service: PhoneNumberServices

    init(service: PhoneNumberServices) {
        self.service = service
    }

    func execute(id: String,
                 completion: @escaping ClientCompletion<PhoneNumber?>) {
        service.getPhoneNumberWith(id: id, completion: completion)
    }
}


