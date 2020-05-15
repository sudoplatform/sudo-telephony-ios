//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync

/// Represents a change subscription. When this object is released, the subscription is canceled.
public protocol SubscriptionToken: class {
    /// Cancel an in progress action.
    func cancel()
}

extension AWSAppSyncSubscriptionWatcher: SubscriptionToken {}
