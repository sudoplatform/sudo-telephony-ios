//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging

class DownloadDataUseCase {

    let service: MessageMediaServices
    let keyManager: TelephonyKeyManager

    init(service: MessageMediaServices,
         keyManager: TelephonyKeyManager) {
        self.service = service
        self.keyManager = keyManager
    }

    func execute(with media: MediaObject,
                 completion: @escaping ClientCompletion<Data>) {
        service.downloadSealedData(for: media) { [keyManager] sealedResult in
            Logger.telephony.info("Data \(media.key) successfully downloaded")
            let unsealed = sealedResult.mapThrowing { sealedData in
                return try keyManager.decryptSealedData(data: sealedData.data)
            }
            completion(unsealed)
        }
    }
}
