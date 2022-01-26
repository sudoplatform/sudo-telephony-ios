//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync

enum SubscriptionStatusTransformer {
    static func fromService(status: AWSAppSyncSubscriptionWatcherStatus) -> SubscriptionStatus {
        switch status {
        case .connected: return .connected
        case .disconnected: return .disconnected
        case .connecting: return .connecting
        case .error(let e): return .error(e)
        }
    }
}
