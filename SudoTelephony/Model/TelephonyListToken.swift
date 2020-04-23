//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Object containing a page of objects from a list, along with a token referencing the next page.
public struct TelephonyListToken<T> {
    /// Items returned from the token that represent a page in the overall list.
    public let items: [T]

    /// A token that can be used to retrieve the next page.
    public let nextToken: String?
}
