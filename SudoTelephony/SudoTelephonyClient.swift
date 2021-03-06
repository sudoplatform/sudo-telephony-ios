
//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import AWSS3
import SudoLogging
import SudoKeyManager
import SudoUser
import SudoProfiles
import SudoConfigManager
import SudoApiClient
import MobileCoreServices
import SudoOperations
import TwilioVoice
import CallKit

/// The type of a `SudoTelephonyClient` search callback.
public typealias SudoTelephonySearchResult = (Swift.Result<AvailablePhoneNumberResult, SudoTelephonyClientError>) -> Void

/// Stores Sudo Platform configuration properties.
public typealias SudoTelephonyClientConfigProvider = SudoUserClientConfigProvider

/// Protocol encapsulating a library of functions for managing phone numbers and messages in the Sudo Platform Telephony service.
public protocol SudoTelephonyClient {
    /// Removes all keys associated with this client, resets any cached data, cleans up subscriptions, and purges any pending operations.
    ///
    /// It is important to note that this will clear ALL cached data related to all telephony services.
    func reset() throws

    /// Get supported countries for searching available phone numbers. The supported countries are returned in ISO 3166-1 alpha-2 format. For example: US, ND, etc.
    ///
    /// - Parameter completion: Completion callback that returns supported countries.
    func getSupportedCountries(completion: @escaping (Swift.Result<[String], SudoTelephonyClientError>) -> Void) throws

    /// Get available phone numbers for the specified country code.
    ///
    /// - Parameter countryCode: Supported country code to search on. Code must be formatted in ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter limit: Optional limit on the number of available phone numbers returned in the search result. If the limit is not specified, the default value is 10 and the search result will provide no more than 10 phone numbers.
    /// - Parameter completion: Completion callback providing a search result containing available phone numbers with the given country code.
    func searchAvailablePhoneNumbers(countryCode: String, limit: UInt?, completion: @escaping SudoTelephonySearchResult) throws
    
    /// Get available phone numbers for the specified country code and prefix.
    ///
    /// - Parameter countryCode: Supported country code to search on. Code must be formatted on the ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter prefix: Parameter prefix: Optional prefix (area code) used to limit the search results. If nil, only the country code will used for the search. If the country code and area code do not match, the resulting list of available phone numbers might be empty.
    /// - Parameter limit: Optional limit on the number of available phone numbers returned in the search result. If the limit is not specified, the default value is 10 and the search result will provide no more than 10 phone numbers.
    /// - Parameter completion: Completion callback providing a search result containing available phone numbers with the given country code and prefix.
    func searchAvailablePhoneNumbers(countryCode: String, prefix: String, limit: UInt?, completion: @escaping SudoTelephonySearchResult) throws
    
    /// Get available phone numbers for the specified coordinates.
    ///
    /// - Parameter countryCode: Supported country code to search on. Code must be formatted on the ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter longitude: Double value of the longitude of the coordinate to search on.
    /// - Parameter latitude: Double value of the latitude of the coordinate to search on.
    /// - Parameter limit: Optional limit on the number of available phone numbers returned in the search result. If the limit is not specified, the default value is 10 and the search result will provide no more than 10 phone numbers.
    /// - Parameter completion: Completion callback providing a search result containing available phone numbers with the given country code and coordinates.
    func searchAvailablePhoneNumbers(countryCode: String, latitude: Double, longitude: Double, limit: UInt?, completion: @escaping SudoTelephonySearchResult) throws
    
    /// Provision a phone number to the signed in account. Searching for available phone numbers should be done before this call, ensuring that the passed in phone number is available.
    ///
    /// - Parameter countryCode: Supported country of the number to provision. Code must be formatted on the ISO 3166-1 alpha-2 format. For example: US, BR, ND, etc.
    /// - Parameter phoneNumber: The E164 formatted phone number to provision.. For example: "+14155552671".
    /// - Parameter sudoId: The ID of the Sudo to provision the phone number for.
    /// - Parameter completion: Completion callback that provides the provisioned phone number.
    func provisionPhoneNumber(countryCode: String, phoneNumber: String, sudoId: String, completion: @escaping (Swift.Result<PhoneNumber, SudoTelephonyClientError>) -> Void) throws
    
    /// Delete an already provisioned from number from the signed in account.
    ///
    /// - Parameter phoneNumber: The E164 formatted phone number to delete. For example: "+14155552671".
    /// - Parameter completion: Completion callback that provides the phone number string on success.
    func deletePhoneNumber(phoneNumber: String, completion: @escaping (Swift.Result<String, SudoTelephonyClientError>) -> Void) throws
    
    /// List all the phone numbers provisioned by the user account. If the user does not have phone numbers associated with the account, an empty list will be returned.
    /// The list can be queried in batches, where the limit and the next batch token can be specified.
    ///
    /// - Parameter sudoId: The sudo id to fetch for.
    /// - Parameter limit: The limit of the batch to fetch. If none specified, all of them will be returned.
    /// - Parameter nextToken: The token to use for pagination. Must pass same parameters as the previous call or unexpected results may be returned.
    /// - Parameter completion: Completion callback that provides a list of phone numbers or an error if there was a failure.
    func listPhoneNumbers(sudoId: String?, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneNumber>, SudoTelephonyClientError>) -> Void) throws
    
    /// Retrieves the phone number for the provided ID. If the number is not associated/provisioned by the account, `nil` will be returned.
    ///
    /// - Parameter id: The id of the phone number to retrieve.
    /// - Parameter completion: Completion callback that provides the phone number or an error if it could not be retrieved.
    func getPhoneNumber(id: String, completion: @escaping (Swift.Result<PhoneNumber?, SudoTelephonyClientError>) -> Void) throws
    
    /// Sends an MMS message from a provisioned phone number to another number.
    ///
    /// - Parameter localNumber: The E164 formatted phone number to send the message from. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the recipient. For example: "+14155552671".
    /// - Parameter body: The body of the SMS message.
    /// - Parameter completion: Completion callback providing the sent message or an error if there was a failure.
    func sendSMSMessage(localNumber: PhoneNumber, remoteNumber: String, body: String, completion: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws
    
    /// Sends an MMS message from a provisioned phone number to another number.
    ///
    /// - Parameter localNumber: The E164 formatted phone number to send the message from. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the recipient. For example: "+14155552671".
    /// - Parameter body: The text body of the MMS message.
    /// - Parameter localUrl: The local path of the media to be uploaded.
    /// - Parameter completion: Completion callback providing the sent message or an error if there was a failure.
    func sendMMSMessage(localNumber: PhoneNumber, remoteNumber: String, body: String?, localUrl: URL, completion: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws
    
    /// Subscribe to new messages and message status updates.
    ///
    /// - Parameter resultHandler: A callback that provides new/updated messages when message events occur.
    /// - Returns: `SubscriptionToken` The object used to cancel the subscription. When this object is released, the subscription is canceled.
    func subscribeToMessages(resultHandler: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws -> SubscriptionToken

    /// Retrieves a message matching the associated id.
    ///
    /// - Parameter id: The id of the message to retrieve.
    /// - Parameter completion: Completion callback providing the message or an error if it could not be retrieved.
    func getMessage(id: String, completion: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws
    
    /// Retrieves a list of messages matching the specified criteria.
    ///
    /// - Parameter localNumber: The E164 formatted phone number of the participating sudo. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the other participant in the phone conversation. For example: "+14155552671".
    /// - Parameter limit: The maximum number of messages to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of messages or an error if there was a failure.
    func getMessages(localNumber: PhoneNumber, remoteNumber: String, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneMessage>, SudoTelephonyClientError>) -> Void) throws
    
    /// Retrieves a list of messages matching the specified criteria.
    ///
    /// - Parameter conversationId: The id of the conversation associated with the messages to be retrieved.
    /// - Parameter limit: The maximum number of messages to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of messages or an error if there was a failure.
    func getMessages(conversationId: String, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneMessage>, SudoTelephonyClientError>) -> Void) throws
    
    /// Downloads MMS attachments.
    ///
    /// - Parameter media: The MediaObject that provides the necessary info for retrieving the media data.
    /// - Parameter completion: Completion callback providing the raw data of the retrieved media object or an error if it could not be retrieved.
    func downloadData(for media: MediaObject, completion: @escaping (Swift.Result<Data, SudoTelephonyClientError>) -> Void)
    
    /// Deletes a message matching the associated id.
    ///
    /// - Parameter id: The id of the message to delete.
    /// - Parameter completion: Completion callback providing the id of the deleted message or an error if the message could not be deleted.
    func deleteMessage(id: String, completion: @escaping (Swift.Result<String, SudoTelephonyClientError>) -> Void) throws
    
    /// Retrieves the conversation matching the specified criteria.
    ///
    /// - Parameter conversationId: The id of the conversation to be retrieved.
    /// - Parameter completion: Completion callback providing the conversation or an error if could not be retrieved.
    func getConversation(conversationId: String, completion: @escaping (Swift.Result<PhoneMessageConversation, SudoTelephonyClientError>) -> Void) throws
    
    /// Retrieves the conversation matching the specified criteria.
    ///
    /// - Parameter localNumber: The E164 formatted phone number of the participating sudo. For example: "+14155552671".
    /// - Parameter remoteNumber: The E164 formatted phone number of the other participant in the phone conversation. For example: "+14155552671".
    /// - Parameter completion: Completion callback providing the conversation or an error if could not be retrieved.
    func getConversation(localNumber: PhoneNumber, remoteNumber: String, completion: @escaping (Swift.Result<PhoneMessageConversation, SudoTelephonyClientError>) -> Void) throws
    
    /// Retrieves a list of conversations for provisioned numbers.
    ///
    /// - Parameter localNumber: The E164 formatted phone number of the participating sudo. For example: "+14155552671".
    /// - Parameter limit: The maximum number of conversations to retrieve.
    /// - Parameter nextToken: The token to use for pagination.
    /// - Parameter completion: Completion callback providing a list of conversations or an error if there was a failure.
    func getConversations(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneMessageConversation>, SudoTelephonyClientError>) -> Void) throws

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

/// Default implementation of `SudoTelephonyClient`.
public class DefaultSudoTelephonyClient: SudoTelephonyClient {
    /// Cache policy for objects managed by the client.
    public enum CacheType {
        /// Cached objects should be stored in memory. The cache will be cleared when the client is released.
        case memory
        /// Cached objects should be stored on disk. Cached objects will persist across most app restarts.
        case disk
    }
    
    /// Configuration parameter names.
    public struct Config {
        /// Configuration namespace.
        struct Namespace {
            /// Identity service related configuration.
            static let identityService = "identityService"
            /// Telephony sign in related configuration
            static let telephonyService = "telephonyService"
            /// API sign in related configuration
            static let apiService = "apiService"
        }

        /// Telephony service-specific configuration.
        struct TelephonyService {
            /// AWS region hosting the telephony service.
            static let region = "region"
            /// API URL.
            static let apiUrl = "apiUrl"
            /// API key.
            static let apiKey = "apiKey"
            /// S3 bucket
            static let bucket = "bucket"
            /// Transient S3 bucket
            static let transientBucket = "transientBucket"
            /// Pool ID
            static let poolId = "poolId"
            /// Identity Pool ID
            static let identityPoolId = "identityPoolId"
        }
    }
    
    private struct Constants {
        struct KeyName {
            static let symmetricKeyId = "symmetricKeyId"
            static let userId = "userId"
            static let userKeyId = "userKeyId"
            static let idToken = "idToken"
            static let accessToken = "accessToken"
            static let refreshToken = "refreshToken"
            static let tokenExpiry = "tokenExpiry"
            static let identityId = "identityId"
        }
        struct SudoProfiles {
            static let telephonyAudience = "sudoplatform.telephony.phone-number"
        }
    }
    
    /// Operation Queue that API operations are executed on
    var queue = PlatformOperationQueue()

    /// Default logger for the client.
    private let logger: Logger
    
    /// AWS region hosting directory service.
    private let region: String
    
    /// The AWS region of the S3 bucket
    private let s3Region: String
    
    /// S3 bucket used by directory service for storing large objects.
    private let s3Bucket: String

    /// Transient S3 bucket used by directory service for storing large objects. Objects in this bucket have a short TTL. Useful for MMS media uploads.
    private let transientS3Bucket: String

    /// Pool ID.
    private let poolId: String

    /// Identity pool ID.
    private let identityPoolId: String

    ///`SudoUserClient` instance required to issue authentication tokens
    private unowned let sudoUserClient: SudoUserClient
    
    /// `SudoProfilesclient` instance required to get ownership proofs
    private unowned let sudoProfilesClient: SudoProfilesClient
    
    /// GraphQL client for communicating with the Sudo  service.
    private let graphQLClient: AWSAppSyncClient
    
    /// Queue for processing API result.
    private let apiResultQueue = DispatchQueue(label: "com.sudoplatform.telephonyclient.api.result")

    /// Key used to instantiate the AWSS3TransferUtility.
    private let s3TransferUtilityKey = "com.sudoplatform.telephonyclient.s3TransferUtility"

    /// The key manager to use for creating telephony keys/passwords and performing cryptographic operations
    private let keyManager: TelephonyKeyManager

    /// Weak reference to a cancellable resource, i.e. a subscription callback.
    struct WeakCancellable {
        /// The cancellable resource reference.
        weak var value: Cancellable?
    }

    /// Weak references to subscribers.
    private var subscriptions: [WeakCancellable] = []

    /// Queue for synchronized reading and writing to the `subscriptions` array.
    private let subscriptionsAccessQueue = DispatchQueue(label: "com.sudoplatform.telephonyclient.api.subscriptions")

    /// Calling feature.
    private var callProviderConfig: CallProviderConfiguration?
    lazy var calling: SudoTelephonyCalling? = {
        guard let config = self.callProviderConfig else { return nil }
        return SudoTelephonyCalling(
            graphQLClient: self.graphQLClient,
            apiResultQueue: self.apiResultQueue,
            sudoUserClient: self.sudoUserClient,
            callProviderConfiguration: config,
            keyManager: self.keyManager,
            subscriptionsAccessQueue: self.subscriptionsAccessQueue,
            subscriptions: self.subscriptions,
            logger: self.logger
        )
    }()
    
    /// Intializes a new `DefaultTelephonyClient` instance.  It uses configuration parameters defined in
    /// `sudoplatformconfig.json` file located in the app bundle.
    ///
    /// - Parameters:
    ///   - sudoUserClient: `SudoUserClient` instance required to issue authentication tokens
    ///   - sudoProfilesClient: `SudoProfilesClient` instance required to issue ownership proofs
    ///   - callProviderConfiguration: Optional configuration object for calling related functionality.  If not provided, attemts to use calling features will throw an error.
    ///   - logger: A logger to use for logging messages. The default logger logs debug messages. Provide `nil` to silence logging.
    /// - Throws: `TelephonyClientError`
    public convenience init(
        sudoUserClient: SudoUserClient,
        sudoProfilesClient: SudoProfilesClient,
        callProviderConfiguration: CallProviderConfiguration? = nil,
        logger: Logger? = DefaultSudoTelephonyClient.defaultLogger
    ) throws {
        guard let configManager = DefaultSudoConfigManager(),
            let identityServiceConfig = configManager.getConfigSet(namespace: Config.Namespace.identityService),
            let sudoTelephonyConfig = configManager.getConfigSet(namespace: Config.Namespace.apiService) else {
                throw SudoTelephonyClientError.invalidConfig
        }
        
        // Use the singleton AppSync client instance if we are using the config file.
        guard let graphQLClient = try ApiClientManager.instance?.getClient(sudoUserClient: sudoUserClient) else {
            throw SudoTelephonyClientError.invalidConfig
        }

        let config = [
            Config.Namespace.identityService: identityServiceConfig,
            Config.Namespace.apiService: sudoTelephonyConfig
        ]

        let logger = logger ?? Logger(
            identifier: DefaultSudoTelephonyClient.defaultLogger.logIdentifier,
            driver: NSLogDriver(level: LogLevel.none)
        )
        let keyManager = DefaultTelephonyKeyManager(
            keyNamespace: "tel",
            sudoUserClient: sudoUserClient,
            graphQLClient: graphQLClient,
            logger: logger
        )
        
        try self.init(
            config: config,
            sudoUserClient: sudoUserClient,
            sudoProfilesClient: sudoProfilesClient,
            callProviderConfiguration: callProviderConfiguration,
            logger: logger,
            keyManager: keyManager,
            graphQLClient: graphQLClient
        )
    }

    /// Intializes a new `DefaultTelephonyClient` instance with the specified backend configuration.
    ///
    /// - Parameters:
    ///   - config: Configuration parameters for the client.
    ///   - sudoUserClient: `SudoUserClient` instance required to issue authentication tokens and perform cryptographic operations.
    ///   - sudoProfilesClient: `SudoProfilesClient` instance required to issue ownership proofs
    ///   - callProviderConfiguration: Optional configuration object for calling related functionality.  If not provided, attemts to use calling features will throw an error.
    ///   - cacheType: Cache type to use. Please refer to CacheType enum.
    ///   - logger: A logger to use for logging messages. The default logger logs debug messages. Provide `nil` to silence logging.
    ///   - keyNamespace: Namespace to use for the keys and passwords.
    /// - Throws: `TelephonyClientError`
    public convenience init(
        config: [String: Any],
        sudoUserClient: SudoUserClient,
        sudoProfilesClient: SudoProfilesClient,
        callProviderConfiguration: CallProviderConfiguration? = nil,
        cacheType: CacheType = .disk,
        logger: Logger? = DefaultSudoTelephonyClient.defaultLogger,
        keyNamespace: String = "tel"
    ) throws {
        let logger = logger ?? Logger(
            identifier: DefaultSudoTelephonyClient.defaultLogger.logIdentifier,
            driver: NSLogDriver(level: LogLevel.none)
        )
        let appSyncClient = try DefaultSudoTelephonyClient.getAppSyncClient(
            config: config,
            sudoUserClient: sudoUserClient,
            cacheType: cacheType
        )
        let keyManager = DefaultTelephonyKeyManager(
            keyNamespace: keyNamespace,
            sudoUserClient: sudoUserClient,
            graphQLClient: appSyncClient,
            logger: logger
        )
        try self.init(
            config: config,
            sudoUserClient: sudoUserClient,
            sudoProfilesClient: sudoProfilesClient,
            callProviderConfiguration: callProviderConfiguration,
            logger: logger,
            keyManager: keyManager,
            graphQLClient: appSyncClient
        )
    }

    @available(*, deprecated, message: "This initializer references internal implementation details and should not be used. Prefer a different initializer.")
    public convenience init(
        config: [String: Any],
        sudoUserClient: SudoUserClient,
        sudoProfilesClient: SudoProfilesClient,
        callProviderConfiguration: CallProviderConfiguration? = nil,
        cacheType: CacheType = .disk,
        logger: Logger? = nil,
        keyNamespace: String = "tel",
        graphQLClient: AWSAppSyncClient? = nil
    ) throws {
        let logger = logger ?? DefaultSudoTelephonyClient.defaultLogger
        let appSyncClient = try graphQLClient ?? DefaultSudoTelephonyClient.getAppSyncClient(
            config: config,
            sudoUserClient: sudoUserClient,
            cacheType: cacheType
        )
        let keyManager = DefaultTelephonyKeyManager(
            keyNamespace: keyNamespace,
            sudoUserClient: sudoUserClient,
            graphQLClient: appSyncClient,
            logger: logger
        )
        try self.init(
            config: config,
            sudoUserClient: sudoUserClient,
            sudoProfilesClient: sudoProfilesClient,
            callProviderConfiguration: callProviderConfiguration,
            logger: logger,
            keyManager: keyManager,
            graphQLClient: appSyncClient
        )
    }

    /// Intializes a new `DefaultTelephonyClient` instance with the specified backend configuration.
    ///
    /// - Parameters:
    ///   - config: Configuration parameters for the client.
    ///   - sudoUserClient: `SudoUserClient` instance required to issue authentication tokens and perform cryptographic operations.
    ///   - sudoProfilesClient: `SudoProfilesClient` instance required to issue ownership proofs
    ///   - callProviderConfiguration: Optional configuration object for calling related functionality.  If not provided, attemts to use calling features will throw an error.
    ///   - logger: A logger to use for logging messages. Provide `nil` to silence logging.
    ///   - keyManager: `TelephonyKeyManager`
    ///   - graphQLClient: `AWSAppSyncClient`
    /// - Throws: `SudoTelephonyClientError.invalidConfig`
    internal init(config: [String: Any],
                  sudoUserClient: SudoUserClient,
                  sudoProfilesClient: SudoProfilesClient,
                  callProviderConfiguration: CallProviderConfiguration?,
                  logger: Logger,
                  keyManager: TelephonyKeyManager,
                  graphQLClient: AWSAppSyncClient) throws {
        
        #if DEBUG
        AWSDDLog.sharedInstance.logLevel = .verbose
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        #endif

        self.logger = logger
        self.sudoUserClient = sudoUserClient
        self.sudoProfilesClient = sudoProfilesClient

        self.callProviderConfig = callProviderConfiguration

        guard let telephonyServiceConfig = config[Config.Namespace.apiService] as? [String: Any],
            let identityServiceConfig = config[Config.Namespace.identityService] as? [String: Any],
            let region = telephonyServiceConfig[Config.TelephonyService.region] as? String,
            let poolId = identityServiceConfig[Config.TelephonyService.poolId] as? String,
            let identityPoolId = identityServiceConfig[Config.TelephonyService.identityPoolId] as? String,
            let s3Region = identityServiceConfig[Config.TelephonyService.region] as? String,
            let bucket = identityServiceConfig[Config.TelephonyService.bucket] as? String,
            let transientBucket = identityServiceConfig[Config.TelephonyService.bucket] as? String else {
                throw SudoTelephonyClientError.invalidConfig
        }
        
        self.region = region
        self.s3Region = s3Region
        self.s3Bucket = bucket
        self.transientS3Bucket = transientBucket
        self.poolId = poolId
        self.identityPoolId = identityPoolId

        self.graphQLClient = graphQLClient
        self.keyManager = keyManager
    }

    public static var defaultLogger: Logger {
        return Logger(identifier: "telephonyClient", driver: NSLogDriver(level: .debug))
    }

    private static func getAppSyncClient(
        config: [String: Any],
        sudoUserClient: SudoUserClient,
        cacheType: CacheType
    ) throws -> AWSAppSyncClient {
        let cacheConfiguration: AWSAppSyncCacheConfiguration
        switch cacheType {
        case .memory:
            cacheConfiguration = AWSAppSyncCacheConfiguration.inMemory
        case .disk:
            cacheConfiguration = try AWSAppSyncCacheConfiguration()
        }

        guard
            let telephonyServiceConfig = config[Config.Namespace.apiService] as? [String: Any],
            let configProvider = SudoTelephonyClientConfigProvider(config: telephonyServiceConfig)
        else {
            throw SudoTelephonyClientError.invalidConfig
        }
        let appSyncConfig = try AWSAppSyncClientConfiguration(
            appSyncServiceConfig: configProvider,
            userPoolsAuthProvider: GraphQLAuthProvider(client: sudoUserClient),
            urlSessionConfiguration: URLSessionConfiguration.default,
            cacheConfiguration: cacheConfiguration,
            connectionStateChangeHandler: nil,
            s3ObjectManager: nil,
            presignedURLClient: nil,
            retryStrategy: .exponential
        )
        let graphQLClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        graphQLClient.apolloClient?.cacheKeyForObject = { $0["id"] }
        return graphQLClient
    }

    private var s3TransferUtility: AWSS3TransferUtility {
        if let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: s3TransferUtilityKey) {
            return transferUtility
        }

        // configure S3TransferUtility
        let s3RegionType = AWSRegionType.regionTypeForString(regionString: self.s3Region)
        let identityProviderManager = IdentityProviderManager(client: self.sudoUserClient,
                                                              region: self.s3Region,
                                                              poolId: self.poolId)
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: s3RegionType,
                                                                identityPoolId: self.identityPoolId,
                                                                identityProviderManager: identityProviderManager)
        // this constructor always returns a non-nil value
        let awsConfig = AWSServiceConfiguration(region: s3RegionType, credentialsProvider: credentialsProvider)!

        // register and retrieve the utility.
        // this retrieval will always succeed unless another thread calls reset()
        AWSS3TransferUtility.register(with: awsConfig, forKey: s3TransferUtilityKey)
        return AWSS3TransferUtility.s3TransferUtility(forKey: s3TransferUtilityKey)!
    }

    public func reset() throws {
        try subscriptionsAccessQueue.sync {
            subscriptions.forEach { $0.value?.cancel() }
            logger.info("Resetting client state.")

            calling?.reset()

            AWSS3TransferUtility.remove(forKey: s3TransferUtilityKey)

            try graphQLClient.clearCaches(options: .init(clearQueries: true,
                                                         clearMutations: true,
                                                         clearSubscriptions: true))
            queue.cancelAllOperations()
            subscriptions.forEach { $0.value?.cancel() }
            subscriptions.removeAll()

            try keyManager.removeAllKeys()
        }
    }

    private func s3KeyPath(s3Key: String) -> String? {
        guard let identityId = self.sudoUserClient.getIdentityId() else { return nil }
        return identityId + "/telephony/media/" + s3Key
    }
    

    public func getSupportedCountries(completion: @escaping (Swift.Result<[String], SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Fetching supported countries")
        
        let query = SupportedCountriesQuery()
        self.graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: self.apiResultQueue) { (result, error) in
            
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }

            if let apiError = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: apiError)))
                return
            }
            
            guard let data = result?.data?.getPhoneNumberCountries else {
                self.logger.error("Data not received for Supported Countries")
                completion(.failure(.internalError))
                return
            }
            
            completion(.success(data.countries))
        }
    }
    
    public func searchAvailablePhoneNumbers(countryCode: String, limit: UInt?, completion: @escaping SudoTelephonySearchResult) throws {
        self.logger.info("Searching for available phone numbers for \(countryCode)")
        
        let mutation = AvailablePhoneNumbersForCountryCodeMutation(country: countryCode, limit: Int(limit ?? 10))
        self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }
            
            if let apiError = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: apiError)))
                return
            }
            
            guard let data = result?.data?.searchPhoneNumbers else {
                completion(.failure(.internalError))
                return
            }
            
            let searchID = data.id
            let query = AvailablePhoneNumberResultQuery(id: searchID)
            self.searchForAvailablePhoneNumbersPostMutation(query: query, completion: completion)
        }
    }


    
    public func searchAvailablePhoneNumbers(countryCode: String, prefix: String, limit: UInt?, completion: @escaping SudoTelephonySearchResult) throws {
        // Searching will fail if the prefix is an empty string. Catch this case and send it to the sibling function that does not require a prefix
        guard !prefix.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return try self.searchAvailablePhoneNumbers(countryCode: countryCode, limit: limit, completion: completion)
        }

        self.logger.info("Searching for available phone numbers for \(countryCode) and prefix \(prefix)")

        let mutation = AvailablePhoneNumbersForPrefixMutation(country: countryCode, prefix: prefix, limit: Int(limit ?? 10))
        self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }
            
            if let apiError = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: apiError)))
                return
            }
            
            guard let data = result?.data?.searchPhoneNumbers else {
                completion(.failure(.internalError))
                return
            }
            
            let query = AvailablePhoneNumberResultQuery(id: data.id)
            self.searchForAvailablePhoneNumbersPostMutation(query: query, completion: completion)
        }
    }
    
    public func searchAvailablePhoneNumbers(countryCode: String, latitude: Double, longitude: Double, limit: UInt?, completion: @escaping SudoTelephonySearchResult) throws {
        self.logger.info("Searching for available phone numbers for \(countryCode) and latitude \(latitude), longitude \(longitude)")
        
        let mutation = AvailablePhoneNumbersForGpsMutation(country: countryCode, latitude: String(latitude), longitude: String(longitude), limit: Int(limit ?? 10))
        self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }
            
            if let apiError = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: apiError)))
                return
            }
            
            guard let data = result?.data?.searchPhoneNumbers else {
                completion(.failure(.internalError))
                return
            }
            
            let query = AvailablePhoneNumberResultQuery(id: data.id)
            self.searchForAvailablePhoneNumbersPostMutation(query: query, completion: completion)
        }
    }

    /// This is the completion handler for all of the `searchForAvailablePhoneNumbers` functions. After performing the mutation the flow is the
    /// same - fetching the list of phone numbers.
    private func searchForAvailablePhoneNumbersPostMutation(query: AvailablePhoneNumberResultQuery, completion: @escaping SudoTelephonySearchResult) {
        self.graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: self.apiResultQueue) { [weak self] (result, error) in

            guard let self = self else {return}

            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }

            if let apiError = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: apiError)))
                return
            }

            guard let data = result?.data?.getPhoneNumberSearch else {
                completion(.failure(.internalError))
                return
            }

            if data.state == PhoneNumberSearchState.failed {
                completion(.failure(.internalError))
                return
            }

            // a `Searching` status might be returned in which case this handler will not be called again.
            // To ensure we get the phone number list make another call to search for the number list.
            // Eventually the back end will return a status that will stop the recursion.
            guard data.state == PhoneNumberSearchState.complete else {
                self.searchForAvailablePhoneNumbersPostMutation(query: query, completion: completion)
                return
            }

            completion(.success(AvailablePhoneNumberResult(id: data.id, numbers: data.results ?? [], countryCode: data.country, prefix: data.prefix, state: data.state)))
        }
    }
    
    public func provisionPhoneNumber(countryCode: String, phoneNumber: String, sudoId: String, completion: @escaping (Swift.Result<PhoneNumber, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Provisioning phone number \(phoneNumber)")
        
        // Result handler block to be called after provisioning
        let resultHandler = { (result: GraphQLResult<ProvisionPhoneNumberMutation.Data>?, error: Error?) in
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }

            if let error = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: error)))
                return
            }
            
            guard let data = result?.data?.provisionPhoneNumber else {
                completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                return
            }
            
            let query = PhoneNumberQuery(id: data.id)

            // the completion block of `graphQLClient.fetch` might return a status of .searching.  In this case we need to call
            // fetch again. This handler function is declared here so it can call itself again to get a `completed` status.
            func postProvisionFetchHandler(query: PhoneNumberQuery, completion: @escaping (Swift.Result<PhoneNumber, SudoTelephonyClientError>) -> Void) {
                self.graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: self.apiResultQueue) { (result, error) in
                    guard error == nil else {
                        completion(.failure(SudoTelephonyClientError(serviceError: error)))
                        return
                    }

                    guard let data = result?.data?.getPhoneNumber else {
                        completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                        return
                    }

                    if data.state == PhoneNumberState.failed {
                        completion(.failure(SudoTelephonyClientError.numberProvisioningFailed))
                        return
                    }

                    guard data.state == PhoneNumberState.complete else {
                        postProvisionFetchHandler(query: query, completion: completion)
                        return
                    }

                    let newPhoneNumber = PhoneNumber(
                        id: data.id,
                        phoneNumber: data.phoneNumber,
                        state: PhoneNumber.State(internalState: data.state),
                        version: data.version,
                        created: Date(timeIntervalSince1970: data.createdAtEpochMs / 1000),
                        updated: Date(timeIntervalSince1970: data.updatedAtEpochMs / 1000))

                    completion(.success(newPhoneNumber))
                }
            }

            postProvisionFetchHandler(query: query, completion: completion)
        }

        let doProvisioning = {
            guard let keyRingId = self.keyManager.getKeyRingId() else {
                completion(.failure(SudoTelephonyClientError.keyGenerationFailed))
                return
            }

            let sudo = Sudo(id: sudoId)
            do {
                try self.sudoProfilesClient.getOwnershipProof(sudo: sudo, audience: Constants.SudoProfiles.telephonyAudience) { (result: GetOwnershipProofResult) in
                    switch result {
                    case let .success(jwt):
                        let input = ProvisionPhoneNumberInput(phoneNumber: phoneNumber, country: countryCode, keyRingId: keyRingId, ownerProofs: [jwt])
                        let mutation = ProvisionPhoneNumberMutation(input: input)
                        self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: resultHandler)
                    case let .failure(cause):
                        self.logger.error("Failed to get ownership proof: \(cause)")
                        completion(.failure(SudoTelephonyClientError.ownershipProofFailed))
                    }
                }
            } catch {
                completion(.failure(SudoTelephonyClientError.ownershipProofFailed))
                return
            }
        }

        // Set up public/private keypair
        if keyManager.getKeyPair() != nil {
            doProvisioning()
        } else {
            try keyManager.generateKeyPair(apiResultQueue: apiResultQueue) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    return
                case .success:
                    doProvisioning()
                }
            }
        }
    }
    
    public func deletePhoneNumber(phoneNumber: String, completion: @escaping (Swift.Result<String, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Deleting phone number \(phoneNumber)")
        
        let input = DeprovisionPhoneNumberInput(phoneNumber: phoneNumber, expectedVersion: 0)
        let mutation = DeprovisionPhoneNumberMutation(input: input)
        self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }
            
            completion(.success(phoneNumber))
        }
    }
    
    public func listPhoneNumbers(sudoId: String?, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneNumber>, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Listing phone numbers")

        var filter: PhoneNumberFilterInput? = nil
        if let sudoId = sudoId {
            filter = PhoneNumberFilterInput(sudoOwner: IDFilterInput(eq: sudoId))
        }

        let query = PhoneNumbersQuery(filter: filter, limit: limit, nextToken: nextToken)
        
        self.graphQLClient.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: self.apiResultQueue) { (result, error) in
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }

            if let apiError = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: apiError)))
                return
            }

            guard let data = result?.data?.listPhoneNumbers else {
                completion(.failure(.internalError))
                return
            }

            let token = TelephonyListToken(items: data.items?.map {
                PhoneNumber(id: $0.id, phoneNumber: $0.phoneNumber, state: PhoneNumber.State(internalState: $0.state), version: $0.version, created: Date(timeIntervalSince1970: $0.createdAtEpochMs / 1000), updated: Date(timeIntervalSince1970: $0.updatedAtEpochMs / 1000))
                } ?? [], nextToken: data.nextToken)
            
            completion(.success(token))
        }
    }
    
    public func getPhoneNumber(id: String, completion: @escaping (Swift.Result<PhoneNumber?, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Getting phone number \(id)")
        
        let query = PhoneNumberQuery(id: id)
        
        self.graphQLClient.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: self.apiResultQueue) { (result, error) in
            guard error == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error)))
                return
            }

            if let apiError = result?.errors?.first {
                completion(.failure(SudoTelephonyClientError(internalError: apiError)))
                return
            }
            
            guard let data = result?.data?.getPhoneNumber else {
                completion(.success(nil))
                return
            }
            
            let phoneNumber = PhoneNumber(id: data.id, phoneNumber: data.phoneNumber, state: PhoneNumber.State(internalState: data.state), version: data.version, created: Date(timeIntervalSince1970: data.createdAtEpochMs / 1000), updated: Date(timeIntervalSince1970: data.updatedAtEpochMs / 1000))
            completion(.success(phoneNumber))
        }
    }
    
    public func sendSMSMessage(localNumber: PhoneNumber, remoteNumber: String, body: String, completion: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Sending SMS Message")
        
        let input = SendMessageInput(from: localNumber.phoneNumber, to: remoteNumber, body: body)
        let mutation = SendMessageMutation(input: input)
        
        self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            let containerError = result?.errors?.first
            guard error == nil, containerError == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error ?? containerError)))
                return
            }

            guard let messageId = result?.data?.sendMessage else {
                completion(.failure(SudoTelephonyClientError.messageSendFailed))
                return
            }
            
            do {
                try self.getMessage(id: messageId, completion: completion)
            } catch {
                completion(.failure(.messageSendFailed))
                return
            }
        }
    }
    
    public func sendMMSMessage(localNumber: PhoneNumber, remoteNumber: String, body: String?, localUrl: URL, completion: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Sending MMS Message")

        // Create an s3 keypath where the file will be uploaded
        guard let s3KeyPath = self.s3KeyPath(s3Key: UUID().uuidString) else {
            // Creating an s3 keypath will fail if it's unable to get the identity id from SudoUserClient.
            completion(.failure(SudoTelephonyClientError.notSignedIn))
            return
        }

        // Upload the file to S3
        self.uploadFile(localUrl: localUrl, s3KeyPath: s3KeyPath, s3Bucket: self.transientS3Bucket) { error in

            if let error = error {
                completion(.failure(error))
                return
            }

            let mediaInput = S3MediaObjectInput(key: s3KeyPath, bucket: self.transientS3Bucket, region: self.s3Region)
            let clientRefId = UUID().uuidString
            let input = SendMessageInput(from: localNumber.phoneNumber, to: remoteNumber, body: body, media: [mediaInput], clientRefId: clientRefId)
            let mutation = SendMessageMutation(input: input)

            self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
                let containerError = result?.errors?.first
                guard error == nil, containerError == nil else {
                    completion(.failure(SudoTelephonyClientError(serviceError: error ?? containerError)))
                    return
                }
                guard let messageId = result?.data?.sendMessage else {
                    completion(.failure(SudoTelephonyClientError.messageSendFailed))
                    return
                }

                do {
                    try self.getMessage(id: messageId, completion: completion)
                } catch {
                    completion(.failure(SudoTelephonyClientError.messageSendFailed))
                    return
                }
            }
        }
    }
    
    public func getMessage(id: String, completion: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Getting Phone Message \(id)")
        
        guard let keyId = keyManager.getKeyId() else {
            return completion(.failure(.getMessageFailed))
        }
        
        let query = GetMessageQuery(id: id, keyId: keyId)
        self.graphQLClient.fetch(query: query, cachePolicy: .returnCacheDataElseFetch, queue: self.apiResultQueue) { (result, error) in
            if let error = error {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            if let error = result?.errors?.first {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            guard let data = result?.data?.getMessage else {
                return completion(.failure(.getMessageFailed))
            }

            switch Swift.Result(catching: {
                try PhoneMessage(decrypting: data.fragments.sealedMessage, keyManager: self.keyManager)
            }) {
            case .success(let message):
                return completion(.success(message))
            case .failure(let error as SudoTelephonyClientError):
                return completion(.failure(error))
            case .failure:
                return completion(.failure(.messageDecryptionFailed))
            }
        }
    }
    
    public func getMessages(localNumber: PhoneNumber, remoteNumber: String, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneMessage>, SudoTelephonyClientError>) -> Void) throws {
        guard let ownerId = try self.sudoUserClient.getSubject() else {
            completion(.failure(.getConversationFailed))
            return
        }
        
        let conversation = "tl-cnv-" + UUID.init(v5WithNameSpace: ownerId, name: localNumber.phoneNumber + remoteNumber).uuidString.lowercased()
        return try self.getMessages(conversationId: conversation, limit: limit, nextToken: nextToken, completion: completion)
    }
    
    public func getMessages(conversationId: String, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneMessage>, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Getting Phone Messages for conversation \(conversationId)")
        
        guard let keyId = keyManager.getKeyId() else {
            return completion(.failure(.getConversationFailed))
        }
        
        let filterInput = MessageFilterInput(conversation: IDFilterInput(eq: conversationId), keyId: IDFilterInput(eq: keyId))
        
        let query = ListMessagesQuery(filter: filterInput, limit: limit, nextToken: nextToken)
        self.graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: self.apiResultQueue) { (result, error) in
            guard error == nil else {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            if let error = result?.errors?.first {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }
            
            guard let result = result, let results = result.data?.listMessages else {
                return completion(.failure(.getMessageFailed))
            }
            
            do {
                let messages = try (results.items ?? []).compactMap {
                    try PhoneMessage(decrypting: $0.fragments.sealedMessage, keyManager: self.keyManager)
                }
                return completion(.success(TelephonyListToken<PhoneMessage>(
                    items: messages,
                    nextToken: results.nextToken
                )))
            } catch {
                return completion(.failure(.messageDecryptionFailed))
            }
        }
    }
    
    // returns the s3 key for the uploaded file
    private func uploadFile(localUrl: URL, s3KeyPath: String, s3Bucket: String, completion: @escaping (SudoTelephonyClientError?) -> Void) {
        self.logger.info("Uploading \(localUrl.lastPathComponent) to S3")
        
        let fileManager = FileManager.init()
        guard fileManager.fileExists(atPath: localUrl.path) else {
            completion(SudoTelephonyClientError.fileNotFound)
            return
        }
        
        let fileExtension = localUrl.pathExtension
        if fileExtension.count < 1 {
            completion(SudoTelephonyClientError.invalidFileFormat)
            return
        }
        guard let extUti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeRetainedValue() else {
            completion(SudoTelephonyClientError.invalidFileFormat)
            return
        }
        guard let mimeType = UTTypeCopyPreferredTagWithClass(extUti, kUTTagClassMIMEType)?.takeRetainedValue() as String? else {
            completion(SudoTelephonyClientError.invalidFileFormat)
            return
        }

        guard mimeType == "image/jpeg" || mimeType == "image/png" || mimeType == "image/gif" else {
            completion(SudoTelephonyClientError.unsupportedMediaContentType)
            return
        }

        let fileData = fileManager.contents(atPath: localUrl.path)!

        self.s3TransferUtility.uploadData(fileData, bucket: s3Bucket, key: s3KeyPath, contentType: mimeType, expression: nil) { (task, error) in
            // https://github.com/aws-amplify/aws-sdk-ios/issues/2053
            task.setCompletionHandler({ _,_ in })

            guard error == nil else {
                self.logger.error(error?.localizedDescription)
                let taskResult = task.response.debugDescription
                self.logger.error(taskResult)
                completion(SudoTelephonyClientError.fileUploadFailed)
                return
            }
            
            self.logger.info("File \(localUrl.lastPathComponent) successfully uploaded")
            completion(nil)
        }
    }
    
    public func downloadData(for media: MediaObject, completion: @escaping (Swift.Result<Data, SudoTelephonyClientError>) -> Void) {
        let s3Key = media.key
        self.logger.info("Downloading data \(s3Key)")

        self.s3TransferUtility.downloadData(fromBucket: media.bucket, key: s3Key, expression: nil) { (task, _, data, error) in
            // https://github.com/aws-amplify/aws-sdk-ios/issues/2053
            task.setCompletionHandler({ _,_,_,_ in })

            guard error == nil, let downloadedData = data else {
                if let e = error { self.logger.error(e.localizedDescription) }
                let taskResult = task.response.debugDescription
                self.logger.error(taskResult)
                completion(.failure(SudoTelephonyClientError.fileDownloadFailed))
                return
            }
            
            do {
                let decryptedData = try self.keyManager.decryptSealedData(data: downloadedData)
                self.logger.info("Data \(s3Key) successfully downloaded")
                completion(.success(decryptedData))
            } catch {
                completion(.failure(SudoTelephonyClientError.sealedDataDecryptionFailed))
            }
        }
    }

    public func subscribeToMessages(resultHandler: @escaping (Swift.Result<PhoneMessage, SudoTelephonyClientError>) -> Void) throws -> SubscriptionToken {
        guard let ownerId = try? self.sudoUserClient.getSubject() else {
            throw SudoTelephonyClientError.notSignedIn
        }

        let messageSubscription = OnMessageReceivedSubscription(owner: ownerId)

        let resultHandler: (GraphQLResult<OnMessageReceivedSubscription.Data>?, ApolloStore.ReadWriteTransaction?, Error?) -> Void = { (result, _, error) in
            let containerError = result?.errors?.first
            guard error == nil, containerError == nil else {
                return resultHandler(.failure(SudoTelephonyClientError(serviceError: error ?? containerError)))
            }
            guard let sealedMessage = result?.data?.onMessage else {
                self.logger.error("Sealed message data missing and no error was returned.")
                return
            }

            do {
                let phoneMessage = try PhoneMessage(
                    decrypting: sealedMessage.fragments.sealedMessage,
                    keyManager: self.keyManager
                )
                return resultHandler(.success(phoneMessage))
            } catch {
                return resultHandler(.failure(SudoTelephonyClientError.messageDecryptionFailed))
            }
        }

        guard let token = try? self.graphQLClient.subscribe(subscription: messageSubscription, resultHandler: resultHandler) else {
            throw SudoTelephonyClientError.messageSubscriptionFailed
        }

        subscriptionsAccessQueue.sync {
            subscriptions.append(.init(value: token))
        }

        return token
    }
    
    public func deleteMessage(id: String, completion: @escaping (Swift.Result<String, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Deleting phone message \(id)")
        let mutation = DeleteMessageMutation(id: id)
        self.graphQLClient.perform(mutation: mutation, queue: self.apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            let containerError = result?.errors?.first
            guard error == nil, containerError == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error ?? containerError)))
                return
            }
            
            completion(.success(result?.data?.deleteMessage ?? id))
        }
    }
    
    public func getConversation(conversationId: String, completion: @escaping (Swift.Result<PhoneMessageConversation, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Fetching conversation \(conversationId)")
        let query = GetConversationQuery(id: conversationId)
        
        self.graphQLClient.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, queue: self.apiResultQueue) { (result, error) in
            let containerError = result?.errors?.first
            guard error == nil, containerError == nil else {
                completion(.failure(SudoTelephonyClientError(serviceError: error ?? containerError)))
                return
            }
            
            guard let data = result?.data?.getConversation else {
                completion(.failure(.getConversationFailed))
                return
            }
            
            let conversation = data.fragments.conversation
            
            do {
                try self.getMessage(id: conversation.lastMessage) { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    case .success(let message):
                        let phoneMessageConversation = PhoneMessageConversation(
                            id: conversation.id,
                            owner: conversation.owner,
                            type: PhoneMessageConversation.MessageConversationType(internalType: conversation.type),
                            latestMessageId: conversation.lastMessage,
                            latestPhoneMessage: message,
                            created: Date(timeIntervalSince1970: conversation.createdAtEpochMs / 1000),
                            updated: Date(timeIntervalSince1970: conversation.updatedAtEpochMs / 1000)
                        )
                        completion(.success(phoneMessageConversation))
                    }
                }
            } catch {
                completion(.failure(.getConversationFailed))
            }
        }
    }
    
    public func getConversation(localNumber: PhoneNumber, remoteNumber: String, completion: @escaping (Swift.Result<PhoneMessageConversation, SudoTelephonyClientError>) -> Void) throws {
        guard let ownerId = try self.sudoUserClient.getSubject() else {
            completion(.failure(.getConversationFailed))
            return
        }
        
        let conversation = "tl-cnv-" + UUID.init(v5WithNameSpace: ownerId, name: localNumber.phoneNumber + remoteNumber).uuidString.lowercased()
        return try getConversation(conversationId: conversation, completion: completion)
    }
    
    public func getConversations(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<PhoneMessageConversation>, SudoTelephonyClientError>) -> Void) throws {
        self.logger.info("Fetching conversations")

        let numberFilter = IDFilterInput(eq: localNumber.id)
        let input: ConversationFilterInput = ConversationFilterInput(phoneNumberId: numberFilter, createdAtEpochMs: FloatFilterInput(ge: 0), updatedAtEpochMs: nil, and: nil, or: nil, not: nil)

        guard let keyId = keyManager.getKeyId() else {
            completion(.failure(.getConversationFailed))
            return
        }
        
        let conversationsOperation = ListConversationsOperation(input: input, keyId: keyId, limit: limit, nextToken: nextToken, appSyncClient: self.graphQLClient, keyManager: self.keyManager, logger: self.logger)
        let completionObserver = PlatformBlockObserver(finishHandler: { [weak self] operation, errors in
            guard !operation.isCancelled else {
                completion(.failure(.getConversationFailed))
                return
            }

            if let error = errors.first {
                self?.logger.error("Failed to get conversations: \(error)")
                completion(.failure(.getConversationFailed))
                return
            }

            guard let conversations = (operation as? ListConversationsOperation)?.result else {
                self?.logger.error("Unexpected error - no result or error received when getting conversations")
                completion(.failure(.getConversationFailed))
                return
            }

            guard !conversations.items.isEmpty else {
                self?.logger.error("Get conversations call succeeded, but no results were available")
                completion(.success(conversations))
                return
            }

            completion(.success(TelephonyListToken(items: conversations.items, nextToken: conversations.nextToken)))
            return
        })
        
        conversationsOperation.addObserver(completionObserver)
        conversationsOperation.addCondition(SignedInCondition(userClient: self.sudoUserClient))
        self.queue.addOperation(conversationsOperation)
    }

    // - MARK: Calling

    public func createVoiceCall(localNumber: PhoneNumber, remoteNumber: String, delegate: ActiveCallDelegate) throws {

        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }

        try calling.createVoiceCall(localNumber: localNumber, remoteNumber: remoteNumber, delegate: delegate)
    }

    public func registerForIncomingCalls(with token: Data, useSandbox: Bool, completion: ((SudoTelephonyClientError?) -> Void)?) throws {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }

        calling.registerForIncomingCalls(with: token, useSandbox: useSandbox, completion: completion)
    }

    public func deregisterForIncomingCalls(completion: ((SudoTelephonyClientError?) -> Void)?) throws {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }
        calling.deregisterForIncomingCalls(completion: completion)
    }

    public func handleIncomingPushNotificationPayload(_ payload: [AnyHashable: Any], notificationDelegate: IncomingCallNotificationDelegate) throws -> Bool {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }

        return calling.handleIncomingPushNotificationPayload(payload, notificationDelegate: notificationDelegate)
    }

    public func getCallRecord(callRecordId: String, completion: @escaping (Swift.Result<CallRecord, SudoTelephonyClientError>) -> Void) throws {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }

        calling.getCallRecord(callRecordId: callRecordId, completion: completion)
    }

    public func getCallRecords(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<CallRecord>, SudoTelephonyClientError>) -> Void) throws {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }

        calling.getCallRecords(localNumber: localNumber, limit: limit, nextToken: nextToken, completion: completion)
    }

    public func subscribeToCallRecords(resultHandler: @escaping (Swift.Result<CallRecord, SudoTelephonyClientError>) -> Void) throws -> SubscriptionToken {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }

        return try calling.subscribeToCallRecords(resultHandler: resultHandler)
    }

    public func deleteCallRecord(id: String, completion: @escaping (Swift.Result<String, SudoTelephonyClientError>) -> Void) throws {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }

        calling.deleteCallRecord(id: id, completion: completion)
    }

    public func getVoicemail(id: String, completion: @escaping (Swift.Result<Voicemail, SudoTelephonyClientError>) -> Void) {
        let query = GetVoicemailQuery(id: id)
        graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: apiResultQueue) { (result, error) in
            if let error = error {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            if let error = result?.errors?.first {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            guard let data = result?.data?.getVoicemail else {
                return completion(.failure(SudoTelephonyClientError.getVoicemailFailed))
            }

            let sealedVoicemail = data.fragments.sealedVoicemail

            do {
                let voicemail = try Voicemail(decrypting: sealedVoicemail, keyManager: self.keyManager)
                return completion(.success(voicemail))
            } catch let error {
                return completion(.failure(SudoTelephonyClientError.voicemailDecryptionFailed(error)))
            }
        }
    }

    public func getVoicemails(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<Voicemail>, SudoTelephonyClientError>) -> Void) {
        let query = ListVoicemailsQuery(
            key: VoicemailKeyInput(phoneNumberId: localNumber.id),
            limit: limit,
            nextToken: nextToken
        )
        graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: apiResultQueue) { (result, error) in
            if let error = error {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            if let error = result?.errors?.first {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            guard let results = result?.data?.listVoicemails else {
                return completion(.failure(SudoTelephonyClientError.getVoicemailFailed))
            }

            do {
                let voicemails = try (results.items ?? []).map {
                    try Voicemail(decrypting: $0.fragments.sealedVoicemail, keyManager: self.keyManager)
                }
                return completion(.success(TelephonyListToken<Voicemail>(
                    items: voicemails,
                    nextToken: results.nextToken
                )))
            } catch let error {
                return completion(.failure(.voicemailDecryptionFailed(error)))
            }
        }
    }

    public func deleteVoicemail(id: String, completion: @escaping (Swift.Result<Void, SudoTelephonyClientError>) -> Void) {
        let mutation = DeleteVoicemailMutation(id: id)
        graphQLClient.perform(mutation: mutation, queue: apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            if let error = error {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            if let error = result?.errors?.first {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            return completion(.success(()))
        }
    }

    public func subscribeToVoicemails(resultHandler: @escaping (Swift.Result<Voicemail, SudoTelephonyClientError>) -> Void) throws -> SubscriptionToken {
        guard let ownerId = try? sudoUserClient.getSubject() else {
            throw SudoTelephonyClientError.notSignedIn
        }

        let subscription = OnVoicemailSubscription(owner: ownerId)

        let resultHandler: SubscriptionResultHandler<OnVoicemailSubscription> = { (result, transaction, error) -> Void in
            if let error = error {
                return resultHandler(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            if let error = result?.errors?.first {
                return resultHandler(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            guard let sealedVoicemail = result?.data?.onVoicemail else {
                return
            }

            do {
                let voicemail = try Voicemail(
                    decrypting: sealedVoicemail.fragments.sealedVoicemail,
                    keyManager: self.keyManager
                )
                return resultHandler(.success(voicemail))
            } catch let error {
                return resultHandler(.failure(SudoTelephonyClientError.voicemailDecryptionFailed(error)))
            }
        }

        switch Swift.Result(catching: {
            try graphQLClient.subscribe(subscription: subscription, queue: apiResultQueue, statusChangeHandler: nil, resultHandler: resultHandler)
        }) {
        case .success(.some(let cancellable)):
            subscriptionsAccessQueue.sync {
                subscriptions.append(.init(value: cancellable))
            }
            return cancellable
        case .success(.none):
            throw SudoTelephonyClientError.voicemailSubscriptionFailed(nil)
        case .failure(let error):
            throw SudoTelephonyClientError.voicemailSubscriptionFailed(error)
        }
    }
}
