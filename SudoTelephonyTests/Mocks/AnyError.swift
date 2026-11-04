//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// A trivial `Error` used to drive failure-path translation tests.
enum AnyError: Error, Equatable {
    case unexpected
}
