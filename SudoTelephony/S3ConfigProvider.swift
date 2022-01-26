//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoConfigManager

public struct S3ConfigProvider {

    /// The AWS region of the S3 bucket
    var region: String

    /// Pool ID.
    var poolId: String

    /// Identity pool ID.
    var identityPoolId: String

    /// S3 bucket used by directory service for storing large objects.
    var bucket: String

    /// Transient S3 bucket used by directory service for storing large objects. Objects in this bucket have a short TTL. Useful for MMS media uploads.
    var transientBucket: String

    public init(
        region: String,
        poolId: String,
        identityPoolId: String,
        bucket: String,
        transientBucket: String
    ) {
        self.region = region
        self.poolId = poolId
        self.identityPoolId = identityPoolId
        self.bucket = bucket
        self.transientBucket = transientBucket
    }
}

extension S3ConfigProvider {

    init?(configManager: SudoConfigManager) {

        guard let identityServiceConfig = configManager.getConfigSet(namespace: "identityService") else { return nil }

        guard let region = identityServiceConfig["region"] as? String,
              let poolId = identityServiceConfig["poolId"] as? String,
              let identityPoolId = identityServiceConfig["identityPoolId"] as? String,
              let bucket = identityServiceConfig["bucket"] as? String,
              let transientBucket = identityServiceConfig["transientBucket"] as? String
        else {
            return nil
        }

        self.init(
            region: region,
            poolId: poolId,
            identityPoolId: identityPoolId,
            bucket: bucket,
            transientBucket: transientBucket
        )
    }
}
