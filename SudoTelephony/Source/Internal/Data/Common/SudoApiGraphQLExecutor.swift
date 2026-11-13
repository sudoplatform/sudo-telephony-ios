//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
import SudoTelephonyCommon

/// Shared GraphQL execution behaviour for repository implementations.
///
/// This is the single place where transport errors are translated into the SDK's
/// public `SudoTelephonyError`. Repository implementations conform to this protocol
/// and call `fetch(_:)` / `perform(_:)` rather than touching `SudoApiClient` directly.
protocol SudoApiGraphQLExecutor: AnyObject {

    /// The client used to reach the telephony service's AppSync GraphQL endpoint.
    var sudoApiClient: SudoApiClient { get }
}

extension SudoApiGraphQLExecutor {

    /// Execute a query, translating any failure into a `SudoTelephonyError`.
    func fetch<Query: GraphQLQuery>(_ query: Query) async throws -> Query.Data {
        do {
            return try await sudoApiClient.fetch(query: query)
        } catch {
            throw SudoTelephonyError.fromApiOperationError(error)
        }
    }

    /// Execute a mutation, translating any failure into a `SudoTelephonyError`.
    func perform<Mutation: GraphQLMutation>(_ mutation: Mutation) async throws -> Mutation.Data {
        do {
            return try await sudoApiClient.perform(mutation: mutation)
        } catch {
            throw SudoTelephonyError.fromApiOperationError(error)
        }
    }

    /// Execute a mutation, translating any failure into a `SudoTelephonyError`, and
    /// first calling `onDefinitiveRejection` if the failure proves the service didn't
    /// carry the mutation out.
    ///
    /// The rejection is decided from the raw error, before it is mapped; see
    /// `SudoTelephonyError.isDefinitiveRejection(_:)`.
    ///
    /// - Parameters:
    ///   - mutation: The mutation to perform.
    ///   - onDefinitiveRejection: Undoes local work done for the mutation, such as a
    ///     key generated for it, when the service definitely didn't act on it.
    func perform<Mutation: GraphQLMutation>(
        _ mutation: Mutation,
        onDefinitiveRejection: () -> Void
    ) async throws -> Mutation.Data {
        do {
            return try await sudoApiClient.perform(mutation: mutation)
        } catch {
            if SudoTelephonyError.isDefinitiveRejection(error) {
                onDefinitiveRejection()
            }
            throw SudoTelephonyError.fromApiOperationError(error)
        }
    }

    /// Encode a GraphQL input object to a compact, deterministic JSON string.
    ///
    /// Retained for inputs that are still passed as JSON; generated input types that
    /// conform to `GraphQLMapConvertible` are preferred where available.
    func encodeInput(_ object: [String: Any]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
        guard let string = String(data: data, encoding: .utf8) else {
            throw SudoTelephonyError.internalError("Failed to encode GraphQL input")
        }
        return string
    }
}
