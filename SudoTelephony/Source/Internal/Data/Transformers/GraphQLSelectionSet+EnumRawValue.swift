//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient

extension GraphQLSelectionSet {

    /// The raw value of an enum field in the response, such as `"ACTIVE"`.
    ///
    /// Read enum fields with this rather than the generated accessors. `SudoApiClient` decodes responses as plain JSON, so an
    /// enum field holds its string value, and the generated accessor, which casts it to the generated enum, would crash.
    /// sudo-email-ios works around this the same way. A value that is already a generated enum is also accepted.
    func enumRawValue(_ field: String) -> String? {
        guard let value = snapshot[field] ?? nil else { return nil }
        if let string = value as? String {
            return string
        }
        return (value as? any RawRepresentable)?.rawValue as? String
    }
}
