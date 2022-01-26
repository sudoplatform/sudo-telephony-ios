//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSAppSync
import Foundation
import SudoApiClient
import SudoLogging
import SudoOperations


/// Operation factory is conceptually the boundary between graphQL and the the rest of the SDK.
/// If you need a telephony service call made, inject a factory whenever you need an operation and it
/// returns the correct instance during during running vs tests (if all calls mocked properly).
///
/// This factory makes parts. some assembly required.
class OperationFactory {

    // Generic query operation
    func generateQueryOperation<Query: GraphQLQuery>(
        query: Query,
        graphQLClient: SudoApiClient,
        logger: Logger
    ) -> PlatformQueryOperation<Query> {
        return PlatformQueryOperation(
            graphQLClient: graphQLClient,
            serviceErrorTransformations: nil,
            query: query,
            cachePolicy: .remoteOnly,
            logger: logger
        )
    }

    // Generic mutation operation
    func generateMutationOperation<Mutation: GraphQLMutation>(
        mutation: Mutation,
        optimisticUpdate: OptimisticResponseBlock? = nil,
        optimisticCleanup: OptimisticCleanupBlock? = nil,
        graphQLClient: SudoApiClient,
        logger: Logger
    ) -> PlatformMutationOperation<Mutation> {
        return PlatformMutationOperation(
            graphQLClient: graphQLClient,
            serviceErrorTransformations: nil,
            mutation: mutation,
            optimisticUpdate: optimisticUpdate,
            optimisticCleanup: optimisticCleanup,
            logger: logger
        )
    }

    /// Creates a mutation that asks the service to generate a list of
    /// available numbers for the given parameters.  Results are fetched
    /// using a `AvailablePhoneNumberResultQueryOperation`.
    func generateSearchAvailablePhoneNumbersOperation(countryCode: String,
                                                      searchParams: SearchAvailableNumberOptions?,
                                                      limit: Int?,
                                                      appSyncClient: SudoApiClient,
                                                      operationFactory: OperationFactory,
                                                      logger: Logger,
                                                      queue: PlatformOperationQueue = PlatformOperationQueue()) -> SearchAvailablePhoneNumbersOperation
    {
        return SearchAvailablePhoneNumbersOperation(countryCode: countryCode,
                                                    searchParams: searchParams,
                                                    limit: limit,
                                                    appSyncClient: appSyncClient,
                                                    operationFactory: operationFactory,
                                                    logger: logger,
                                                    queue: queue)
    }

    /// Fetches available phone number results from the service. Requires a `SearchAvailablePhoneNumbersOperation`
    /// as a dependency to obtain the search id, or the id can be injected via the queryId parameter.
    func generateAvailablePhoneNumberResultQueryOperation(appSyncClient: SudoApiClient,
                                                          operationFactory: OperationFactory,
                                                          logger: Logger,
                                                          queue: PlatformOperationQueue = PlatformOperationQueue()) -> AvailablePhoneNumberResultQueryOperation
    {
        return AvailablePhoneNumberResultQueryOperation(appSyncClient: appSyncClient,
                                                        operationFactory: operationFactory,
                                                        logger: logger,
                                                        queue: queue)
    }
}
