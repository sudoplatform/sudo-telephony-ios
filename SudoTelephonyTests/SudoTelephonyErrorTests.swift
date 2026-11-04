//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation
import SudoApiClient
@testable import SudoTelephony
import SudoTelephonyCommon
import XCTest

final class SudoTelephonyErrorTests: XCTestCase {

    // MARK: - Tests: mapping

    func test_fromApiOperationError_mapsInsufficientEntitlements() {
        let error = SudoTelephonyError.fromApiOperationError(ApiOperationError.insufficientEntitlements)
        XCTAssertEqual(error, .insufficientEntitlements)
    }

    func test_fromApiOperationError_mapsInvalidArgument() {
        let error = SudoTelephonyError.fromApiOperationError(ApiOperationError.invalidArgument)
        XCTAssertEqual(error, .invalidArgument(nil))
    }

    func test_fromApiOperationError_mapsServiceError() {
        let error = SudoTelephonyError.fromApiOperationError(ApiOperationError.serviceError)
        XCTAssertEqual(error, .serviceError)
    }

    func test_fromApiOperationError_mapsNotSignedIn() {
        let error = SudoTelephonyError.fromApiOperationError(ApiOperationError.notSignedIn)
        XCTAssertEqual(error, .notSignedIn)
    }

    func test_fromApiOperationError_mapsFatalErrorToInternalError() {
        let error = SudoTelephonyError.fromApiOperationError(ApiOperationError.fatalError(description: "cause"))
        XCTAssertEqual(error, .internalError("cause"))
    }

    func test_fromApiOperationError_passesThroughExistingSdkError() {
        let error = SudoTelephonyError.fromApiOperationError(SudoTelephonyError.noResultError)
        XCTAssertEqual(error, .noResultError)
    }

    func test_fromApiOperationError_mapsUnknownErrorToInternalError() {
        let error = SudoTelephonyError.fromApiOperationError(AnyError.unexpected)
        guard case .internalError = error else {
            return XCTFail("Expected .internalError, got \(error)")
        }
    }

    // MARK: - Tests: GraphQL error message preservation

    func test_fromApiOperationError_graphQLError_areaCodeMessageBecomesInvalidArgument() {
        let graphQLError = GraphQLError(message: "Area code is required for this country.")
        let error = SudoTelephonyError.fromApiOperationError(
            ApiOperationError.graphQLError(cause: graphQLError)
        )
        XCTAssertEqual(error, .invalidArgument("Area code is required for this country."))
    }

    func test_fromApiOperationError_graphQLError_requiredMessageBecomesInvalidArgument() {
        let graphQLError = GraphQLError(message: "clientRefId is required.")
        let error = SudoTelephonyError.fromApiOperationError(
            ApiOperationError.graphQLError(cause: graphQLError)
        )
        XCTAssertEqual(error, .invalidArgument("clientRefId is required."))
    }

    func test_fromApiOperationError_graphQLError_otherMessagePreservedAsInternalError() {
        let graphQLError = GraphQLError(message: "Upstream carrier timeout.")
        let error = SudoTelephonyError.fromApiOperationError(
            ApiOperationError.graphQLError(cause: graphQLError)
        )
        XCTAssertEqual(error, .internalError("Upstream carrier timeout."))
    }

    // MARK: - Tests: description

    func test_errorDescription_isPresentForEveryCase() {
        let cases: [SudoTelephonyError] = [
            .invalidArgument("x"),
            .invalidConfig,
            .notSignedIn,
            .insufficientEntitlements,
            .serviceError,
            .noResultError,
            .internalError("y")
        ]
        for error in cases {
            XCTAssertNotNil(error.errorDescription)
            XCTAssertFalse(error.errorDescription?.isEmpty ?? true)
        }
    }
}
