//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoTelephonyCommon

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

    /// The public enum value of a required enum field.
    ///
    /// A value the SDK doesn't recognise maps to the enum's `unknown` case rather than failing, so a value the service adds
    /// later doesn't stop the item being read. Only a missing value, which the schema doesn't allow, is an error.
    ///
    /// - Throws: `SudoTelephonyError.internalError` if the field has no value.
    func enumValue<T: RawRepresentable>(_ field: String) throws -> T where T.RawValue == String {
        guard let value = optionalEnumValue(field) as T? else {
            throw SudoTelephonyError.internalError("Missing \(field) in \(Self.self)")
        }
        return value
    }

    /// The public enum value of an optional enum field, or `nil` if it has no value.
    ///
    /// A value the SDK doesn't recognise maps to the enum's `unknown` case.
    func optionalEnumValue<T: RawRepresentable>(_ field: String) -> T? where T.RawValue == String {
        enumRawValue(field).flatMap(T.init(rawValue:))
    }
}
