//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The type of a `SudoTelephonyClient` search callback.
public typealias SudoTelephonySearchResult = (Swift.Result<AvailablePhoneNumberResult, SudoTelephonyClientError>) -> Void

public typealias TelephonyClientCompletion<O> = (Swift.Result<O, SudoTelephonyClientError>) -> Void

/// Protocol encapsulating a library of functions for managing phone numbers and messages in the Sudo Platform Telephony service.
public protocol SudoTelephonyClient {
    /// Removes all keys associated with this client, resets any cached data, cleans up subscriptions, and purges any pending operations.
    ///
    /// It is important to note that this will clear ALL cached data related to all telephony services.
    func reset() throws

    /// Get supported countries for searching available phone numbers. The supported countries are returned in ISO 3166-1 alpha-2 format. For example: US, ND, etc.
    ///
    /// - Parameter completion: Completion callback that returns supported countries.
    func getSupportedCountries(completion: @escaping TelephonyClientCompletion<[String]>)

    /// Get available phone numbers for the specified country code.
    ///
    /// - Parameter countryCode: Supported country code to search on. Code must be formatted in ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter limit: Optional limit on the number of available phone numbers returned in the search result. If the limit is not specified, the default value is 10 and the search result will provide no more than 10 phone numbers.
    /// - Parameter completion: Completion callback providing a search result containing available phone numbers with the given country code.
    func searchAvailablePhoneNumbers(countryCode: String, limit: UInt?, completion: @escaping SudoTelephonySearchResult)

    /// Get available phone numbers for the specified country code and prefix.
    ///
    /// - Parameter countryCode: Supported country code to search on. Code must be formatted on the ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter prefix: Parameter prefix: Optional prefix (area code) used to limit the search results. If nil, only the country code will used for the search. If the country code and area code do not match, the resulting list of available phone numbers might be empty.
    /// - Parameter limit: Optional limit on the number of available phone numbers returned in the search result. If the limit is not specified, the default value is 10 and the search result will provide no more than 10 phone numbers.
    /// - Parameter completion: Completion callback providing a search result containing available phone numbers with the given country code and prefix.
    func searchAvailablePhoneNumbers(countryCode: String, prefix: String, limit: UInt?, completion: @escaping SudoTelephonySearchResult)

    /// Get available phone numbers for the specified coordinates.
    ///
    /// - Parameter countryCode: Supported country code to search on. Code must be formatted on the ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter longitude: Double value of the longitude of the coordinate to search on.
    /// - Parameter latitude: Double value of the latitude of the coordinate to search on.
    /// - Parameter limit: Optional limit on the number of available phone numbers returned in the search result. If the limit is not specified, the default value is 10 and the search result will provide no more than 10 phone numbers.
    /// - Parameter completion: Completion callback providing a search result containing available phone numbers with the given country code and coordinates.
    func searchAvailablePhoneNumbers(countryCode: String, latitude: Double, longitude: Double, limit: UInt?, completion: @escaping SudoTelephonySearchResult)

    /// Provision a phone number to the signed in account. Searching for available phone numbers should be done before this call, ensuring that the passed in phone number is available.
    ///
    /// - Parameter countryCode: Supported country of the number to provision. Code must be formatted on the ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter phoneNumber: The E164 formatted phone number to provision.. For example: "+14155552671".
    /// - Parameter sudoId: The ID of the Sudo to provision the phone number for.
    /// - Parameter completion: Completion callback that provides the provisioned phone number.
    func provisionPhoneNumber(countryCode: String, phoneNumber: String, sudoId: String, completion: @escaping TelephonyClientCompletion<PhoneNumber>)

    /// Delete an already provisioned from number from the signed in account.
    ///
    /// - Parameter phoneNumber: The E164 formatted phone number to delete. For example: "+14155552671".
    /// - Parameter completion: Completion callback that provides the phone number string on success.
    func deletePhoneNumber(phoneNumber: String, completion: @escaping TelephonyClientCompletion<String>)

    /// List all the phone numbers provisioned by the user account. If the user does not have phone numbers associated with the account, an empty list will be returned.
    /// The list can be queried in batches, where the limit and the next batch token can be specified.
    ///
    /// - Parameter sudoId: The sudo id to fetch for.
    /// - Parameter limit: The limit of the batch to fetch. If none specified, all of them will be returned.
    /// - Parameter nextToken: The token to use for pagination. Must pass same parameters as the previous call or unexpected results may be returned.
    /// - Parameter completion: Completion callback that provides a list of phone numbers or an error if there was a failure.
    func listPhoneNumbers(sudoId: String?, limit: Int?, nextToken: String?, completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneNumber>>)

    /// Retrieves the phone number for the provided ID. If the number is not associated/provisioned by the account, `nil` will be returned.
    ///
    /// - Parameter id: The id of the phone number to retrieve.
    /// - Parameter completion: Completion callback that provides the phone number or an error if it could not be retrieved.
    func getPhoneNumber(id: String, completion: @escaping TelephonyClientCompletion<PhoneNumber?>)

    /// Sends an MMS message from a provisioned phone number to another number.
    ///
    /// - Parameter localNumber: The E164 formatted phone number to send the message from. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the recipient. For example: "+14155552671".
    /// - Parameter body: The body of the SMS message.
    /// - Parameter completion: Completion callback providing the sent message or an error if there was a failure.
    func sendSMSMessage(localNumber: PhoneNumber, remoteNumber: String, body: String, completion: @escaping TelephonyClientCompletion<PhoneMessage>)

    /// Sends an MMS message from a provisioned phone number to another number.
    ///
    /// - Parameter localNumber: The E164 formatted phone number to send the message from. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the recipient. For example: "+14155552671".
    /// - Parameter body: The text body of the MMS message.
    /// - Parameter localUrl: The local path of the media to be uploaded.
    /// - Parameter completion: Completion callback providing the sent message or an error if there was a failure.
    func sendMMSMessage(localNumber: PhoneNumber, remoteNumber: String, body: String?, localUrl: URL, completion: @escaping TelephonyClientCompletion<PhoneMessage>)

    /// Subscribe to new messages and message status updates.
    ///
    /// - Parameter statusObserver: A callback that provides subscription status events.
    /// - Parameter resultHandler: A callback that provides new/updated messages when message events occur.
    /// - Returns: `SubscriptionToken` The object used to cancel the subscription. When this object is released, the subscription is canceled.
    func subscribeToMessages(statusObserver: SubscriptionHandler<SubscriptionStatus>?,
                                    resultHandler: @escaping SubscriptionHandler<PhoneMessage>) throws -> SubscriptionToken?

    /// Retrieves a message matching the associated id.
    ///
    /// - Parameter id: The id of the message to retrieve.
    /// - Parameter completion: Completion callback providing the message or an error if it could not be retrieved.
    func getMessage(id: String, completion: @escaping TelephonyClientCompletion<PhoneMessage>)

    /// Retrieves a list of messages matching the specified criteria.
    ///
    /// - Parameter localNumber: The E164 formatted phone number of the participating sudo. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the other participant in the phone conversation. For example: "+14155552671".
    /// - Parameter limit: The maximum number of messages to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of messages or an error if there was a failure.
    func getMessages(localNumber: PhoneNumber, remoteNumber: String, limit: Int?, nextToken: String?, completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneMessage>>)

    /// Retrieves a list of messages matching the specified criteria.
    ///
    /// - Parameter conversationId: The id of the conversation associated with the messages to be retrieved.
    /// - Parameter limit: The maximum number of messages to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of messages or an error if there was a failure.
    func getMessages(conversationId: String, limit: Int?, nextToken: String?, completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneMessage>>)

    /// Downloads MMS attachments.
    ///
    /// - Parameter media: The MediaObject that provides the necessary info for retrieving the media data.
    /// - Parameter completion: Completion callback providing the raw data of the retrieved media object or an error if it could not be retrieved.
    func downloadData(for media: MediaObject, completion: @escaping TelephonyClientCompletion<Data>)

    /// Deletes a message matching the associated id.
    ///
    /// - Parameter id: The id of the message to delete.
    /// - Parameter completion: Completion callback providing the id of the deleted message or an error if the message could not be deleted.
    func deleteMessage(id: String, completion: @escaping TelephonyClientCompletion<String>)

    /// Retrieves the conversation matching the specified criteria.
    ///
    /// - Parameter conversationId: The id of the conversation to be retrieved.
    /// - Parameter completion: Completion callback providing the conversation or an error if could not be retrieved.
    func getConversation(conversationId: String, completion: @escaping TelephonyClientCompletion<PhoneMessageConversation>)

    /// Retrieves the conversation matching the specified criteria.
    ///
    /// - Parameter localNumber: The E164 formatted phone number of the participating sudo. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the other participant in the phone conversation. For example: "+14155552671".
    /// - Parameter completion: Completion callback providing the conversation or an error if could not be retrieved.
    func getConversation(localNumber: PhoneNumber, remoteNumber: String, completion: @escaping TelephonyClientCompletion<PhoneMessageConversation>)

    /// Retrieves a list of conversations for provisioned numbers.
    ///
    /// - Parameter localNumber: The E164 formatted phone number of the participating sudo. For example: "+14155552671".
    /// - Parameter limit: The maximum number of conversations to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of conversations or an error if there was a failure.
    func getConversations(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneMessageConversation>>)

    /// Creates a call from a provisioned phone number to another number.
    ///
    /// - Parameters
    ///     - localNumber: The E164 formatted phone number to call from. For example: "+14155552671".
    ///     - remoteNumber: The E164 formatted phone number of the recipient. For example: "+14155552671".
    ///     - delegate: ActiveCallDelegate for monitoring voice call events
    /// - Throws: A `CallConfigurationError` if a CallProviderConfiguration object is not provided in the initializer.
    func createVoiceCall(localNumber: PhoneNumber, remoteNumber: String, delegate: ActiveCallDelegate) throws

    /// Register for incoming calls.
    /// - Parameters:
    ///     - data: The push token data from PushKit
    ///     - useSandbox: Use the sandbox or production APNS.  Developer builds typically use the sandbox.
    ///     - completion: Called when the push token has been sucessfully provided to the service. Returns an error on failure.
    /// - Throws: A `CallConfigurationError` if a CallProviderConfiguration object is not provided in the initializer.
    func registerForIncomingCalls(with token: Data, useSandbox: Bool, completion: ((SudoTelephonyClientError?) -> Void)?) throws

    /// Deregisters for calls using the last recieved voip push token data.  The method should be called when Pushkit notifies your app the credentials have been invalidaded, or any other time you want to stop recieving voip pushes for incoming calls.
    /// - Parameters:
    ///     - completion: Called when deregistration is complete.
    /// - Throws: A `CallConfigurationError` if a CallProviderConfiguration object is not provided in the initializer.
    func deregisterForIncomingCalls(completion: ((SudoTelephonyClientError?) -> Void)?) throws

    /// Notifies the SDK a new push was recieved.
    ///
    /// - Parameters:
    ///     - payload: The payload from the voip push
    ///
    /// - Returns: A Bool indicating if the SDK was able to handle the payload or not.
    /// - Throws: A `CallConfigurationError` if a CallProviderConfiguration object is not provided in the initializer.
    func handleIncomingPushNotificationPayload(_ payload: [AnyHashable: Any], notificationDelegate: IncomingCallNotificationDelegate) throws -> Bool

    /// Retrieves the call record with specified id.
    ///
    /// - Parameter callRecordId: The id of the `CallRecord` to be retrieved.
    /// - Parameter completion: Completion callback providing the `CallRecord` or an error if it could not be retrieved.
    func getCallRecord(callRecordId: String, completion: @escaping (Swift.Result<CallRecord, SudoTelephonyClientError>) -> Void) throws

    /// Retrieves a list of call records.
    ///
    /// - Parameter localNumber: The `PhoneNumber` of the participating sudo.
    /// - Parameter limit: The maximum number of call records to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of `CallRecord`s or an error if it could not be retrieved.
    func getCallRecords(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<CallRecord>, SudoTelephonyClientError>) -> Void) throws

    /// Subscribe to new call record updates.
    ///
    /// - Parameter resultHandler: A callback that provides new/updated call record when a call is completed.
    /// - Returns: `SubscriptionToken` The object used to cancel the subscription. When this object is released, the subscription is canceled.
    func subscribeToCallRecords(resultHandler: @escaping (Swift.Result<CallRecord, SudoTelephonyClientError>) -> Void) throws -> SubscriptionToken

    /// Deletes a call record matching the associated id.
    ///
    /// - Parameter id: The id of the `CallRecord` to delete.
    /// - Parameter completion: Completion callback providing the id of the deleted `CallRecord` or an error if the `CallRecord` could not be deleted.
    func deleteCallRecord(id: String, completion: @escaping (Swift.Result<String, SudoTelephonyClientError>) -> Void) throws

    /// Retrieves a list of `Voicemail`s for the given `PhoneNumber`.
    ///
    /// - Parameters:
    ///   - localNumber: The `PhoneNumber` to fetch `Voicemail`s for.
    ///   - limit: The maximum number of `Voicemail`s to retrieve per page.
    ///   - nextToken: The token to use for pagination.
    ///   - completion: Completion callback providing a list of `Voicemail`s or an error if it could not be retrieved.
    func getVoicemails(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<Voicemail>, SudoTelephonyClientError>) -> Void)

    /// Retrieves the voicemail with the specified `id`.
    ///
    /// - Parameters:
    ///   - id: The `id` of the `Voicemail` to retrieve.
    ///   - completion: Completion callback providing the `Voicemail` or an error if it could not be retrieved.
    func getVoicemail(id: String, completion: @escaping (Swift.Result<Voicemail, SudoTelephonyClientError>) -> Void)

    /// Deletes a voicemail matching the given `id`.
    ///
    /// - Parameters:
    ///   - id: The `id` of the `Voicemail` to delete.
    ///   - completion: Completion callback providing success or an error if the `Voicemail` could not be deleted.
    func deleteVoicemail(id: String, completion: @escaping (Swift.Result<Void, SudoTelephonyClientError>) -> Void)

    /// Subscribe to new, updated, and deleted `Voicemail` records.
    ///
    /// - Parameter resultHandler: A callback that provides new/updated/deleted `Voicemail` records when changes occur.
    /// - Returns: `SubscriptionToken` An object used to cancel the subscription. When this object is released, the subscription is canceled.
    func subscribeToVoicemails(resultHandler: @escaping (Swift.Result<Voicemail, SudoTelephonyClientError>) -> Void) throws -> SubscriptionToken
}
