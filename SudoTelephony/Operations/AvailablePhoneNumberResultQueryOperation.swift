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

/// Searching for available phone numbers is a two step process.
/// This operation fetches results that a previous operation prepared via a mutation.
class AvailablePhoneNumberResultQueryOperation: PlatformOperation {

    var queue = PlatformOperationQueue()
    unowned let appSyncClient: SudoApiClient
    unowned let operationFactory: OperationFactory

    // The mutation query result id too query for.
    // Provided externally, or fetched from dependent operations
    var queryId: String?

    // Result of this operation
    var resultObject: AvailablePhoneNumberResult?

    internal init(appSyncClient: SudoApiClient,
                  operationFactory: OperationFactory,
                  logger: Logger,
                  queue: PlatformOperationQueue = PlatformOperationQueue())
    {
        self.queue = queue
        self.appSyncClient = appSyncClient
        self.operationFactory = operationFactory
        super.init(logger: logger)
    }

    // Look through the dependencies for an operation that generated a search result id.
    func resolveQueryIdFromDependentOperation() -> String? {
        self.dependencies.compactMap { op in
            return op as? SearchAvailablePhoneNumbersOperation
        }
        .first?
        .searchResultId
    }

    override func execute() {
        guard let searchQueryId = self.queryId ?? resolveQueryIdFromDependentOperation() else {
            self.finishWithError(SudoTelephonyClientError.internalError)
            return
        }

        queryForAvailableNumbers(queryId: searchQueryId)
    }

    // Query the service to check if results for this query id are available.
    // Will recursively query the service until the request fails or results are available.
    func queryForAvailableNumbers(queryId: String) {
        let query = AvailablePhoneNumberResultQuery(id: queryId)
        let queryOperation = operationFactory.generateQueryOperation(query: query,
                                                                     graphQLClient: appSyncClient,
                                                                     logger: logger
        )

        let observer = PlatformBlockObserver(finishHandler:  { [unowned queryOperation, weak self] _, errors in
            guard let self = self else { return }
            if let error = errors.first {
                self.finishWithError(error)
                return
            }

            guard let result = queryOperation.result?.getPhoneNumberSearch else {
                self.finishWithError(SudoTelephonyClientError.internalError)
                return
            }

            // Inspect the result state to see if we have a result or if another query needs to be made.
            switch result.state {
            case .complete:
                // Construct results and finish this operation.
                self.resultObject = AvailablePhoneNumberResult(id: result.id,
                                                               numbers: result.results ?? [],
                                                               countryCode: result.country,
                                                               prefix: result.prefix,
                                                               state: result.state
                )
                self.finish()
            case .failed:
                // Finish with an error
                self.finishWithError(SudoTelephonyClientError.internalError)
            default:
                // a `Searching` status might be returned in which case this observer will not be called again.
                // To ensure we get the phone number list make another call to search for the number list.
                // Eventually the back end will return a status that will stop the recursion.
                self.queryForAvailableNumbers(queryId: queryId)
            }
        })

        queryOperation.addObserver(observer)
        queue.addOperation(queryOperation)
    }
}
