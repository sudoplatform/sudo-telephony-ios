//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging
import AWSAppSync
import SudoOperations
import SudoApiClient

class GetSupportedCountriesUseCase {

    let dataProvider: PhoneNumberServices

    init(dataProvider: PhoneNumberServices) {
        self.dataProvider = dataProvider
    }

    func execute(completion: @escaping ClientCompletion<[String]>) {
        dataProvider.getSupportedCountries(completion: completion)
    }
}
