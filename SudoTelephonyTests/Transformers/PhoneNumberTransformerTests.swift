//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient
@testable import SudoTelephony
import SudoTelephonyCommon
import XCTest

final class PhoneNumberTransformerTests: XCTestCase {

    // MARK: - Helpers

    private func phoneNumberFragment(
        state: String = "ACTIVE",
        numberType: String = "LOCAL",
        failureReason: String? = nil,
        gracePeriodEndsAtEpochMs: Double? = nil,
        owners: [Snapshot]? = nil
    ) -> GraphQL.PhoneNumberFragment {
        var snapshot: Snapshot = [
            "__typename": "PhoneNumber",
            "id": "pn-1",
            "phoneNumber": "+14155550123",
            "countryCode": "US",
            "numberType": numberType,
            "areaCode": "415",
            "state": state,
            "clientRefId": "ref-1",
            "createdAtEpochMs": 1000.0,
            "updatedAtEpochMs": 2000.0
        ]
        snapshot["failureReason"] = failureReason
        snapshot["gracePeriodEndsAtEpochMs"] = gracePeriodEndsAtEpochMs
        snapshot["owners"] = owners
        return GraphQL.PhoneNumberFragment(snapshot: snapshot)
    }

    // MARK: - PhoneNumber

    func test_transformPhoneNumber_mapsAllFields() throws {
        let result = try PhoneNumberTransformer.transform(phoneNumberFragment())

        XCTAssertEqual(result.id, "pn-1")
        XCTAssertEqual(result.phoneNumber, "+14155550123")
        XCTAssertEqual(result.numberType, .local)
        XCTAssertEqual(result.areaCode, "415")
        XCTAssertEqual(result.state, .active)
        XCTAssertNil(result.failureReason)
        XCTAssertEqual(result.clientRefId, "ref-1")
    }

    func test_transformPhoneNumber_mapsOwners() throws {
        let result = try PhoneNumberTransformer.transform(
            phoneNumberFragment(owners: [
                ["__typename": "Owner", "id": "sudo-1", "issuer": "sudoplatform.sudoservice"]
            ])
        )

        XCTAssertEqual(result.owners, [Owner(id: "sudo-1", issuer: "sudoplatform.sudoservice")])
    }

    func test_transformPhoneNumber_missingOwnersMapsToEmpty() throws {
        let result = try PhoneNumberTransformer.transform(phoneNumberFragment())

        XCTAssertEqual(result.owners, [])
    }

    func test_transformPhoneNumber_mapsFailureAndGracePeriod() throws {
        let failed = try PhoneNumberTransformer.transform(
            phoneNumberFragment(state: "FAILED", failureReason: "CARRIER_ERROR")
        )
        XCTAssertEqual(failed.failureReason, .carrierError)

        let suspended = try PhoneNumberTransformer.transform(
            phoneNumberFragment(state: "SUSPENDED", gracePeriodEndsAtEpochMs: 5000.0)
        )
        XCTAssertEqual(suspended.state, .suspended)
        XCTAssertEqual(suspended.gracePeriodEndsAtEpochMs, 5000.0)
    }

    func test_transformPhoneNumber_unknownStateThrows() {
        XCTAssertThrowsError(
            try PhoneNumberTransformer.transform(phoneNumberFragment(state: "WARP_SPEED"))
        ) { error in
            guard case SudoTelephonyError.internalError = error else {
                return XCTFail("Expected .internalError, got \(error)")
            }
        }
    }

    func test_transformPhoneNumber_unknownFailureReasonThrows() {
        XCTAssertThrowsError(
            try PhoneNumberTransformer.transform(
                phoneNumberFragment(state: "FAILED", failureReason: "METEOR")
            )
        ) { error in
            guard case SudoTelephonyError.internalError = error else {
                return XCTFail("Expected .internalError, got \(error)")
            }
        }
    }
}
