//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSS3

protocol TransferUtility {
    @discardableResult func uploadData(_ data: Data,
                    bucket: String,
                    key: String,
                    contentType: String,
                    expression: AWSS3TransferUtilityUploadExpression?,
                    completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?)
    -> AWSTask<AWSS3TransferUtilityUploadTask>

    @discardableResult func downloadData(fromBucket bucket: String,
                      key: String,
                      expression: AWSS3TransferUtilityDownloadExpression?,
                      completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?)
    -> AWSTask<AWSS3TransferUtilityDownloadTask>
}

extension AWSS3TransferUtility: TransferUtility{}
