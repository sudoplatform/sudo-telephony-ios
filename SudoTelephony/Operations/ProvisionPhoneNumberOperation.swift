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

/// Provisions a phone number. Dependencies are provided via the injectables and
/// are provided by dependent operations enforced by a condition.
class ProvisionPhoneNumberOperation: PlatformOperation {
    /// Data from dependencies injected into this operation.
    struct Injectables {
        /// KeyRingId, pulled from TelephonyKeyManager or created by GetKeyRingIdOperation
        let keyRingId: String

        /// Ownership proof provided by GetOwnershipProofOperation
        let ownershipProof: String
    }

    /// Injected data.
    var injectables: Injectables!

    // MARK: Input Params

    let phoneNumber: String
    let countryCode: String
    let numberProvider: PhoneNumberServices

    // MARK: Output

    /// Operation result is the newly provisioned number
    var resultObject: PhoneNumber?

    internal init(phoneNumber: String,
                  countryCode: String,
                  numberProvider: PhoneNumberServices,
                  logger: Logger)
    {
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.numberProvider = numberProvider
        super.init(logger: logger)

        // Add condition to gather and inject required dependencies.
        let condition = ProvisionPhoneNumberOperationDependencyCondition()
        condition.logger = logger
        self.addCondition(condition)
    }

    override func execute() {
        numberProvider.provisionNumber(phoneNumber: self.phoneNumber,
                                       countryCode: self.countryCode,
                                       keyRingId: injectables.keyRingId,
                                       ownerProofs: [injectables.ownershipProof]) { result in
            switch result {
            case .success(let number):
                self.resultObject = number
                self.finish()
            case .failure(let error):
                self.finishWithError(error)
            }
        }
    }
}

// MARK: Dependency Conditions

/// Extracts dependency information for the ProvisionPhoneNumberOperation and injects it.
class ProvisionPhoneNumberOperationDependencyCondition: PlatformOperationCondition {
    static var name: String = "ProvisionPhoneNumberOperationDependencyCondition"

    var logger: Logger?

    func dependencyForOperation(_ operation: PlatformOperation) -> Operation? {
        return nil
    }

    func evaluateForOperation(_ operation: PlatformOperation, completion: (PlatformOperationConditionResult) -> Void) {
        // Ensure this is the correct operation type
        guard let operation = operation as? ProvisionPhoneNumberOperation else {
            logger?.error("Condition assigned to wrong operation type. Expected \(type(of: self).name)")
            completion(.failure(SudoTelephonyClientError.internalError))
            return
        }

        // Extract the dependent operations from the dependency list.
        guard let keyRingIdOp = operation.dependencies.first(whereType: GetKeyRingIdOperation.self),
              let ownershipProofOp = operation.dependencies.first(whereType: GetOwnershipProofOperation.self)
        else {
            logger?.error("Operation missing required dependent operations")
            completion(.failure(SudoTelephonyClientError.internalError))
            return
        }

        // extract the required data from dependent operations
        guard let keyRingId = keyRingIdOp.resultObject,
              let ownershipProof = ownershipProofOp.resultObject
        else {
            logger?.error("Operation dependencies missing required result objects")
            completion(.failure(SudoTelephonyClientError.internalError))
            return
        }

        // Inject data and finish
        let injectedData = ProvisionPhoneNumberOperation.Injectables(keyRingId: keyRingId,
                                                                     ownershipProof: ownershipProof)

        operation.injectables = injectedData
        completion(.success(()))
    }
}
