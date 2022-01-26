//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Simple extension on Result to easily grab the value/error without clunky
/// "if case let", "try? self.get()", or switch statements.
extension Result {

    var value: Success? {
        switch self {
        case .success(let output):
            return output
        case .failure:
            return nil
        }
    }

    var error: Failure? {
        switch self {
        case .failure(let output):
            return output
        case .success:
            return nil
        }
    }

    // This is like Result.map, but catches errors thrown by the transformation.
    // Because of the error transformation function, the generic `Failure` type is
    // is mapped to an `Error` type to handle the nature of throwing functions.
    func mapThrowing<T>(transformation: (Success) throws -> T) -> Result<T, Error> {
        switch self {
        case .success(let unwrapped):
            do {
                let transformed = try transformation(unwrapped)
                return .success(transformed)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
