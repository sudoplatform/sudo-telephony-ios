//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoTelephonyCommon

/// Maps the generated configuration response to the public `TelephonyConfigurationData`.
enum ConfigurationTransformer {

    /// Transform the configuration selection set.
    static func transform(_ config: GraphQL.GetTelephonyConfigQuery.Data.GetTelephonyConfig) -> TelephonyConfigurationData {
        TelephonyConfigurationData(
            sudoOwnershipProofRequired: config.sudoOwnershipProofRequired,
            phoneNumberSearchDefaultLimit: config.phoneNumberSearchDefaultLimit,
            phoneNumberSearchMaxLimit: config.phoneNumberSearchMaxLimit,
            phoneNumberSearchLifetime: TimeInterval(config.phoneNumberSearchLifetimeMs) / 1000,
            listDefaultLimit: config.listDefaultLimit,
            listMaxLimit: config.listMaxLimit,
            deletePhoneMessagesLimit: config.deletePhoneMessagesLimit,
            updatePhoneMessagesLimit: config.updatePhoneMessagesLimit
        )
    }
}
