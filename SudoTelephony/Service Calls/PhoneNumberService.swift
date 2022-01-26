//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging
import AWSAppSync
import SudoOperations
import SudoApiClient

protocol PhoneNumberServices: AnyObject {
    /// Get supported countries where numbers can be provisioned.
    func getSupportedCountries(completion: @escaping ClientCompletion<[String]>)

    /// Search for available numbers using the provided parameters.
    func searchAvailablePhoneNumbers(countryCode: String,
                                     searchParams: SearchAvailableNumberOptions?,
                                     limit: Int?,
                                     completion: @escaping ClientCompletion<AvailablePhoneNumberResult>)

    /// Provision a phone number using provided parameters.
    func provisionNumber(phoneNumber: String,
                         countryCode: String,
                         keyRingId: String,
                         ownerProofs: [String],
                         completion: @escaping ClientCompletion<PhoneNumber>)


    func getPhoneNumberWith(id: GraphQLID, completion: @escaping ClientCompletion<PhoneNumber?>)

    func listPhoneNumbers(sudoId: String?,
                          limit: Int?,
                          nextToken:
                          String?,
                          completion: @escaping ClientCompletion<TelephonyListToken<PhoneNumber>>)

    func deprovisionNumber(phoneNumber: String, completion: @escaping ClientCompletion<String>)
}

class PhoneNumberService: PhoneNumberServices {

    // MARK: - Properties

    /// App sync client for performing operations against the telephony service.
    var graphQLClient: SudoApiClient

    /// Used to log diagnostic and error information.
    var logger: Logger

    /// Utility factory class to generate mutation and query operations.
    var operationFactory = OperationFactory()

    /// Operation queue for enqueuing asynchronous tasks.
    var queue: PlatformOperationQueue

    // MARK: - Lifecycle

    /// Initialize an instance of `AvailableNumberProvider`.
    init(graphQLClient: SudoApiClient,
         queue: PlatformOperationQueue = PlatformOperationQueue(),
         logger: Logger = .telephony) {
        self.graphQLClient = graphQLClient
        self.queue = queue
        self.logger = logger
    }

    /// Get supported countries where numbers can be provisioned.
    func getSupportedCountries(completion: @escaping ClientCompletion<[String]>) {
        let query = SupportedCountriesQuery()
        let operation = operationFactory.generateQueryOperation(query: query,
                                                                graphQLClient: graphQLClient,
                                                                logger: logger
        )

        let observer = PlatformBlockObserver(finishHandler:  { _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            let countries = operation.result?.getPhoneNumberCountries?.countries ?? []
            completion(.success(countries))
        })

        operation.addObserver(observer)
        queue.addOperation(operation)
    }

    /// Search for available phone numbers, with optional search parameters.
    func searchAvailablePhoneNumbers(countryCode: String,
                                             searchParams: SearchAvailableNumberOptions?,
                                             limit: Int?,
                                             completion: @escaping ClientCompletion<AvailablePhoneNumberResult>) {

        // operation to generate a mutation to search for numbers
        let searchOperation = operationFactory.generateSearchAvailablePhoneNumbersOperation(countryCode: countryCode,
                                                                                            searchParams: searchParams,
                                                                                            limit: limit,
                                                                                            appSyncClient: graphQLClient,
                                                                                            operationFactory: operationFactory,
                                                                                            logger: logger
        )

        // operation to fetch results from the previous search mutation
        let queryResultsOperation = operationFactory.generateAvailablePhoneNumberResultQueryOperation(appSyncClient: graphQLClient,
                                                                                                      operationFactory: operationFactory,
                                                                                                      logger: logger
        )

        // result operation depends on the search mutation
        queryResultsOperation.addDependency(searchOperation)

        let observer = PlatformBlockObserver(finishHandler:  { _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            guard let result = queryResultsOperation.resultObject else {
                completion(.failure(SudoTelephonyClientError.internalError))
                return
            }

            completion(.success(result))
        })

        queryResultsOperation.addObserver(observer)
        queue.addOperation(searchOperation)
        queue.addOperation(queryResultsOperation)
    }

    func provisionNumber(phoneNumber: String,
                         countryCode: String,
                         keyRingId: String,
                         ownerProofs: [String],
                         completion: @escaping ClientCompletion<PhoneNumber>)
    {

        let input = ProvisionPhoneNumberInput(phoneNumber: phoneNumber,
                                              country: countryCode,
                                              keyRingId: keyRingId,
                                              clientRefId: nil,
                                              ownerProofs: ownerProofs)
        let mutation = ProvisionPhoneNumberMutation(input: input)

        let op = self.operationFactory.generateMutationOperation(mutation: mutation,
                                                                 graphQLClient: self.graphQLClient,
                                                                 logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [weak self, unowned op] _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            guard let opResult = op.result?.provisionPhoneNumber else {
                completion(.failure(SudoTelephonyClientError.internalError))
                return
            }

            // Check for results
            self?.pollForPhoneNumberProvisionResultsWith(id: opResult.id, completion: completion)
        })

        op.addObserver(observer)
        self.queue.addOperation(op)
    }

    // Queries the service for results of a provision mutation
    // The service might return a status of .searching so we have to poll
    // for results.
    private func pollForPhoneNumberProvisionResultsWith(id: GraphQLID, completion: @escaping ClientCompletion<PhoneNumber>) {
        self.getPhoneNumberWith(id: id) { [weak self] result in
            // mapping because value is a double optional. yuck.
            guard let number = result.value?.map({$0}) else {
                completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                return
            }


            // Fail early if the provision failed.
            if number.state == .failed {
                completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                return
            }

            // If results aren't complete yet search again.
            guard number.state == .complete else {
                self?.pollForPhoneNumberProvisionResultsWith(id: id, completion: completion)
                return
            }

            completion(.success(number))
        }
    }

    // MARK: Get Phone Number

    func getPhoneNumberWith(id: GraphQLID, completion: @escaping ClientCompletion<PhoneNumber?>) {
        let query = PhoneNumberQuery(id: id)
        let queryPhoneNumberOp = self.operationFactory.generateQueryOperation(query: query,
                                                                              graphQLClient: self.graphQLClient,
                                                                              logger: logger)

        // Process results of the query operation.
        let observer = PlatformBlockObserver(finishHandler: { [unowned queryPhoneNumberOp] _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            // Check for result data from the service
            guard let number = queryPhoneNumberOp.result?.getPhoneNumber?.fragments.sudoPhoneNumber else {
                completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                return
            }

            completion(.success(PhoneNumberTransformer.fromService(object: number)))
        })

        // Add observer and inject into queue.
        queryPhoneNumberOp.addObserver(observer)
        self.queue.addOperation(queryPhoneNumberOp)
    }

    func listPhoneNumbers(sudoId: String?,
                          limit: Int?,
                          nextToken:
                          String?,
                          completion: @escaping ClientCompletion<TelephonyListToken<PhoneNumber>>) {

        var filter: PhoneNumberFilterInput? = nil
        if let sudoId = sudoId {
            filter = PhoneNumberFilterInput(sudoOwner: IDFilterInput(eq: sudoId))
        }

        let query = PhoneNumbersQuery(filter: filter, limit: limit, nextToken: nextToken)

        let operation = operationFactory.generateQueryOperation(query: query,
                                                graphQLClient: graphQLClient,
                                                logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned operation] _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            // Check for result data from the service
            guard let data = operation.result?.listPhoneNumbers else {
                completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                return
            }

            // Transform data
            let numbers = data.items?.compactMap {
                PhoneNumberTransformer.fromService(object: $0.fragments.sudoPhoneNumber)
            }

            // Send results
            let results = TelephonyListToken<PhoneNumber>(items: numbers ?? [], nextToken: data.nextToken)
            completion(.success(results))
        })

        operation.addObserver(observer)
        queue.addOperation(operation)
    }

    // MARK: Deprovision Number

    func deprovisionNumber(phoneNumber: String, completion: @escaping ClientCompletion<String>) {
        // TODO: Can expected version be hard coded?
        let input = DeprovisionPhoneNumberInput(phoneNumber: phoneNumber, expectedVersion: 0)
        let mutation = DeprovisionPhoneNumberMutation(input: input)

        let operation = operationFactory.generateMutationOperation(mutation: mutation,
                                                                   graphQLClient: graphQLClient,
                                                                   logger: logger)

        let observer = PlatformBlockObserver(finishHandler: { [unowned operation] _, errors in
            if let error = errors.first {
                completion(.failure(error))
                return
            }

            // Check for result data from the service
            guard let data = operation.result?.deprovisionPhoneNumber else {
                completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                return
            }

            completion(.success(data.phoneNumber))
        })

        operation.addObserver(observer)
        queue.addOperation(operation)
    }

}
