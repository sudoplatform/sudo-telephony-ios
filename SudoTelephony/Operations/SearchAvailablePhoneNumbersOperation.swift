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

// There are three different search methods which all yield a different mutation/result type
// search param enum is intended to help unify them so searching appears the to outside observers.
enum SearchAvailableNumberOptions {

    struct GPSSearchParams {
        var lat: Double
        var long: Double
    }
    case prefix(String)
    case gps(GPSSearchParams)
}

/// Searching for available phone numbers is a two step process.  We first generate
/// a mutation to generate search results, followed by a query to fetch results
/// when ready.
class SearchAvailablePhoneNumbersOperation: PlatformOperation {

    // MARK: Search input
    let countryCode: String
    let searchParams: SearchAvailableNumberOptions?
    var limit: Int?

    // MARK: Params
    var queue = PlatformOperationQueue()
    unowned let appSyncClient: SudoApiClient
    unowned let operationFactory: OperationFactory

    // Mark: Output
    var searchResultId: String?

    internal init(countryCode: String,
                  searchParams: SearchAvailableNumberOptions?,
                  limit: Int?,
                  appSyncClient: SudoApiClient,
                  operationFactory: OperationFactory,
                  logger: Logger,
                  queue: PlatformOperationQueue = PlatformOperationQueue())
    {
        self.queue = queue
        self.appSyncClient = appSyncClient
        self.operationFactory = operationFactory
        self.countryCode = countryCode
        self.searchParams = searchParams
        self.limit = limit
        super.init(logger: logger)
    }

    override func execute() {
        // Use the search params to create the correct mutation operation.
        // These are all the same, but typed differently so there isn't a super
        // nice and clean way to combine them.
        switch searchParams {
        case .none:
            let mutation = AvailablePhoneNumbersForCountryCodeMutation(country: countryCode,
                                                                       limit: limit)

            let mutationOperation = operationFactory.generateMutationOperation(mutation: mutation,
                                                                               graphQLClient: appSyncClient,
                                                                               logger: logger)

            let observer = PlatformBlockObserver(finishHandler:  { [unowned mutationOperation, weak self] _, errors in
                guard let self = self else { return }
                if let error = errors.first {
                    self.finishWithError(error)
                }
                self.searchResultId = mutationOperation.result?.searchPhoneNumbers?.id
                self.finish()
            })

            mutationOperation.addObserver(observer)
            self.queue.addOperation(mutationOperation)
        case .some(.gps(let coordinates)):
            let mutation = AvailablePhoneNumbersForGpsMutation(country: countryCode,
                                                               latitude: String(coordinates.lat),
                                                               longitude: String(coordinates.long),
                                                               limit: limit)

            let mutationOperation = operationFactory.generateMutationOperation(mutation: mutation,
                                                                               graphQLClient: appSyncClient,
                                                                               logger: logger)

            let observer = PlatformBlockObserver(finishHandler:  { [unowned mutationOperation, weak self] _, errors in
                guard let self = self else { return }
                if let error = errors.first {
                    self.finishWithError(error)
                }
                self.searchResultId = mutationOperation.result?.searchPhoneNumbers?.id
                self.finish()
            })

            mutationOperation.addObserver(observer)
            self.queue.addOperation(mutationOperation)
        case .some(.prefix(let prefix)):
            let mutation = AvailablePhoneNumbersForPrefixMutation(country: countryCode,
                                                                  prefix: prefix,
                                                                  limit: limit)

            let mutationOperation = operationFactory.generateMutationOperation(mutation: mutation,
                                                                               graphQLClient: appSyncClient,
                                                                               logger: logger)

            let observer = PlatformBlockObserver(finishHandler:  { [unowned mutationOperation, weak self] _, errors in
                guard let self = self else { return }
                if let error = errors.first {
                    self.finishWithError(error)
                }
                self.searchResultId = mutationOperation.result?.searchPhoneNumbers?.id
                self.finish()
            })

            mutationOperation.addObserver(observer)
            self.queue.addOperation(mutationOperation)
        }
    }
}
