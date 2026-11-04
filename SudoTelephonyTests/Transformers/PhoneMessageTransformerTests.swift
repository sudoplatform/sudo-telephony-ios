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

final class PhoneMessageTransformerTests: XCTestCase {

    private var deviceKeyManager: MockDeviceKeyManager!

    override func setUp() {
        super.setUp()
        deviceKeyManager = MockDeviceKeyManager()
    }

    override func tearDown() {
        deviceKeyManager = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func sealedFragment(
        type: String = "SMS",
        direction: String = "INBOUND",
        remotePhoneNumber: String? = "sealed-remote",
        body: String = "sealed-body"
    ) -> GraphQL.SealedPhoneMessageFragment {
        var snapshot: Snapshot = [
            "__typename": "SealedPhoneMessage",
            "id": "msg-1",
            "phoneNumberId": "pn-1",
            "conversationId": "conv-1",
            "type": type,
            "direction": direction,
            "localPhoneNumber": "+14155550123",
            "body": body,
            "segmentCount": 1,
            "mediaOmitted": false,
            "seen": false,
            "receivedAtEpochMs": 1000.0,
            "createdAtEpochMs": 1100.0,
            "updatedAtEpochMs": 1200.0
        ]
        snapshot["remotePhoneNumber"] = remotePhoneNumber
        return GraphQL.SealedPhoneMessageFragment(snapshot: snapshot)
    }

    // MARK: - Tests

    func test_transform_unsealsBodyAndRemoteNumber() throws {
        deviceKeyManager.unsealResults = [
            "sealed-body": "Hello there",
            "sealed-remote": "+14155559876"
        ]

        let result = try PhoneMessageTransformer.transform(
            sealedFragment(),
            keyId: "key-1",
            deviceKeyManager: deviceKeyManager
        )

        XCTAssertEqual(result.body, "Hello there")
        XCTAssertEqual(result.remotePhoneNumber, "+14155559876")
        XCTAssertEqual(result.type, .sms)
        XCTAssertEqual(result.direction, .inbound)
        XCTAssertEqual(deviceKeyManager.lastUnsealKeyId, "key-1")
        XCTAssertEqual(deviceKeyManager.lastUnsealAlgorithm, "RSAEncryptionOAEPAESGCM")
    }

    func test_transform_nilRemoteNumberStaysNil() throws {
        deviceKeyManager.unsealResults = ["sealed-body": "Hi"]

        let result = try PhoneMessageTransformer.transform(
            sealedFragment(remotePhoneNumber: nil),
            keyId: "key-1",
            deviceKeyManager: deviceKeyManager
        )

        XCTAssertNil(result.remotePhoneNumber)
        XCTAssertEqual(result.body, "Hi")
    }

    func test_transform_unknownTypeThrows() {
        XCTAssertThrowsError(
            try PhoneMessageTransformer.transform(
                sealedFragment(type: "MMS"),
                keyId: "k",
                deviceKeyManager: deviceKeyManager
            )
        ) { error in
            guard case SudoTelephonyError.internalError = error else {
                return XCTFail("Expected .internalError, got \(error)")
            }
        }
    }

    func test_transform_propagatesUnsealFailure() {
        deviceKeyManager.defaultUnsealResult = .failure(SudoTelephonyError.internalError("bad"))

        XCTAssertThrowsError(
            try PhoneMessageTransformer.transform(
                sealedFragment(),
                keyId: "k",
                deviceKeyManager: deviceKeyManager
            )
        ) { error in
            guard case SudoTelephonyError.internalError = error else {
                return XCTFail("Expected .internalError, got \(error)")
            }
        }
    }
}
