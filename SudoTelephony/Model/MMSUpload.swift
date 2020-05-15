//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync

struct MMSUpload : AWSS3InputObjectProtocol, AWSS3ObjectProtocol {
    let key: String
    let bucket: String
    let region: String
    let mimeType: String
    let localUri: URL
    func getLocalSourceFileURL() -> URL? { return localUri }
    func getMimeType() -> String { return mimeType }
    func getBucketName() -> String { return bucket }
    func getKeyName() -> String { return key }
    func getRegion() -> String { return region }
}
