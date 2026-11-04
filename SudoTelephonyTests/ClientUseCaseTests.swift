//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import SudoTelephony
import SudoTelephonyCommon
import XCTest

/// Exercises the public client surface through the use-case factory with mock
/// repositories, confirming each method routes to the right repository and
/// propagates results and typed errors.
final class ClientUseCaseTests: XCTestCase {

    private var supportedCountries: MockSupportedCountriesRepository!
    private var phoneNumber: MockPhoneNumberRepository!
    private var phoneMessage: MockPhoneMessageRepository!
    private var subscription: MockSubscriptionRepository!
    private var deviceKeyManager: MockDeviceKeyManager!
    private var client: DefaultSudoTelephonyClient!

    override func setUp() {
        super.setUp()
        supportedCountries = MockSupportedCountriesRepository()
        phoneNumber = MockPhoneNumberRepository()
        phoneMessage = MockPhoneMessageRepository()
        subscription = MockSubscriptionRepository()
        deviceKeyManager = MockDeviceKeyManager()
        let factory = UseCaseFactory.mock(
            supportedCountries: supportedCountries,
            phoneNumber: phoneNumber,
            phoneMessage: phoneMessage,
            subscription: subscription
        )
        client = DefaultSudoTelephonyClient(useCaseFactory: factory, deviceKeyManager: deviceKeyManager)
    }

    override func tearDown() {
        client = nil
        deviceKeyManager = nil
        subscription = nil
        phoneMessage = nil
        phoneNumber = nil
        supportedCountries = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func number(state: PhoneNumberState = .active) -> PhoneNumber {
        PhoneNumber(
            id: "pn-1",
            phoneNumber: "+14155550123",
            countryCode: "US",
            numberType: .local,
            areaCode: "415",
            state: state,
            failureReason: nil,
            gracePeriodEndsAtEpochMs: nil,
            clientRefId: nil,
            owners: [],
            createdAtEpochMs: 1,
            updatedAtEpochMs: 2
        )
    }

    private func message() -> PhoneMessage {
        PhoneMessage(
            id: "msg-1",
            phoneNumberId: "pn-1",
            conversationId: "c-1",
            type: .sms,
            direction: .inbound,
            localPhoneNumber: "+14155550123",
            remotePhoneNumber: "+1",
            body: "hi",
            segmentCount: 1,
            mediaOmitted: false,
            seen: false,
            receivedAtEpochMs: 1,
            createdAtEpochMs: 2,
            updatedAtEpochMs: 3
        )
    }

    // MARK: - Supported countries

    func test_getSupportedCountries_returnsRepositoryResult() async throws {
        supportedCountries.result = .success(["US", "CA"])
        let result = try await client.getSupportedCountries()
        XCTAssertEqual(result, ["US", "CA"])
    }

    func test_getSupportedCountries_propagatesError() async throws {
        supportedCountries.result = .failure(SudoTelephonyError.serviceError)
        do {
            _ = try await client.getSupportedCountries()
            XCTFail("Expected error")
        } catch let error as SudoTelephonyError {
            XCTAssertEqual(error, .serviceError)
        }
    }

    // MARK: - Phone numbers

    func test_provisionPhoneNumber_returnsNumber() async throws {
        phoneNumber.provisionResult = .success(number(state: .provisioning))
        let result = try await client.provisionPhoneNumber(
            ProvisionPhoneNumberInput(searchId: "s", phoneNumber: "+1")
        )
        XCTAssertEqual(result.state, .provisioning)
    }

    func test_getPhoneNumber_returnsNil() async throws {
        phoneNumber.getResult = .success(nil)
        let result = try await client.getPhoneNumber(id: "missing")
        XCTAssertNil(result)
    }

    func test_listPhoneNumbers_returnsPage() async throws {
        phoneNumber.listResult = .success(PhoneNumberListToken(items: [number()], nextToken: "n"))
        let result = try await client.listPhoneNumbers(ListPhoneNumbersInput())
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.nextToken, "n")
    }

    // MARK: - Messages

    func test_listPhoneMessages_returnsPage() async throws {
        phoneMessage.listResult = .success(PhoneMessageListToken(items: [message()], nextToken: nil))
        let result = try await client.listPhoneMessages(ListPhoneMessagesInput(phoneNumberId: "pn-1"))
        XCTAssertEqual(result.items.first?.body, "hi")
    }

    func test_deletePhoneMessages_returnsResult() async throws {
        phoneMessage.deleteResult = .success(PhoneMessageBatchResult(succeededIds: ["a"], failedIds: []))
        let result = try await client.deletePhoneMessages(ids: ["a"])
        XCTAssertEqual(result.succeededIds, ["a"])
    }

    func test_updatePhoneMessages_returnsResult() async throws {
        phoneMessage.updateResult = .success(PhoneMessageBatchResult(succeededIds: ["a"], failedIds: ["b"]))
        let result = try await client.updatePhoneMessages(ids: ["a", "b"], seen: true)
        XCTAssertEqual(result.failedIds, ["b"])
    }

    // MARK: - Subscriptions

    func test_subscribeToPhoneNumberUpdates_deliversAndCancels() async throws {
        let received = expectation(description: "update")
        var delivered: PhoneNumber?
        let token = try await client.subscribeToPhoneNumberUpdates(owner: "o") { result in
            if case .success(let n) = result { delivered = n; received.fulfill() }
        }
        subscription.numberHandler?(.success(number()))
        await fulfillment(of: [received], timeout: 1.0)
        XCTAssertEqual(delivered?.id, "pn-1")
        token.cancel()
        XCTAssertEqual(subscription.lastToken?.cancelCallCount, 1)
    }

    func test_subscribeToPhoneMessageEvents_deliversEvent() async throws {
        let received = expectation(description: "event")
        var delivered: PhoneMessageEvent?
        _ = try await client.subscribeToPhoneMessageEvents(owner: "o") { result in
            if case .success(let e) = result { delivered = e; received.fulfill() }
        }
        subscription.eventHandler?(.success(
            PhoneMessageEvent(
                id: "msg-1",
                phoneNumberId: "pn-1",
                conversationId: "c-1",
                type: .sms,
                direction: .inbound,
                changeType: .received,
                seen: false
            )
        ))
        await fulfillment(of: [received], timeout: 1.0)
        XCTAssertEqual(delivered?.changeType, .received)
    }

    // MARK: - Lifecycle

    func test_reset_removesAllKeys() throws {
        try client.reset()
        XCTAssertEqual(deviceKeyManager.removeAllKeysCallCount, 1)
    }

    func test_reset_propagatesError() {
        deviceKeyManager.removeAllKeysError = SudoTelephonyError.internalError("boom")
        XCTAssertThrowsError(try client.reset())
    }

    func test_exportKeys_returnsArchiveData() throws {
        deviceKeyManager.exportKeysResult = .success(Data("my-archive".utf8))
        let data = try client.exportKeys()
        XCTAssertEqual(data, Data("my-archive".utf8))
        XCTAssertEqual(deviceKeyManager.exportKeysCallCount, 1)
    }

    func test_exportKeys_propagatesError() {
        deviceKeyManager.exportKeysResult = .failure(SudoTelephonyError.internalError("boom"))
        XCTAssertThrowsError(try client.exportKeys())
    }

    func test_importKeys_passesArchiveToKeyManager() throws {
        let archive = Data("restore".utf8)
        try client.importKeys(archiveData: archive)
        XCTAssertEqual(deviceKeyManager.importedArchives, [archive])
    }

    func test_importKeys_propagatesError() {
        deviceKeyManager.importKeysError = SudoTelephonyError.internalError("bad archive")
        XCTAssertThrowsError(try client.importKeys(archiveData: Data()))
    }
}
