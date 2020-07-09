//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Provides instructions on what CallKit should display for an incoming/active call.
public struct CallKitDisplayName {

    public let value: String
    public let ignoreSystemContacts: Bool

    /// Creates a display name used by Callkit for display of an incoming/active call.
    /// - Parameters:
    ///     - value: The display value, e.g. Jon Smith
    ///     - ignoreSystemContacts: If CallKit should ignore system contacts.  By default, if iOS can resolve a contact it will ignore the display value we provide. To override this behavior and force CallKit to use the value provided, set this to true.
    public init(value: String, ignoreSystemContacts: Bool = false) {
        self.value = value
        self.ignoreSystemContacts = ignoreSystemContacts
    }
}
