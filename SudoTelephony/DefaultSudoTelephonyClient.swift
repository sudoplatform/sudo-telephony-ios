
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
import CloudKit

/// Generic type associated with API completion/closures. Generic type O is the expected output result in a
/// success case.
typealias ClientCompletion<O> = (Swift.Result<O, Error>) -> Void


// MARK: Description
///
/// Default implementation of `SudoTelephonyClient`.
///
/// This class works in general by delegating work in layers starting with a use case.
/// Use cases are fetched from the factory, which is mocked for easy testing.
///
/// This class manages the lifecycle of core services that do things
/// for the use cases, e.g. a KeyManager for providing keys
/// and decryption services, a DoFoo object that does foo things and so forth.
///
///
/// For better or for worse error's are transformed here to SudoTelephonyClientError.
/// for the completion handlers.
///
public final class DefaultSudoTelephonyClient: SudoTelephonyClient {

    // MARK: Properties

    /// Operation Queue that API operations are executed on
    var queue = PlatformOperationQueue()

    /// Default logger for the client.
    private let logger: Logger = .telephony

    /// Set the global log level of the telephony SDK.
    static var logLevel: LogLevel {
        get {
            return Logger.telephonyDriver.logLevel
        }
        set {
            Logger.telephonyDriver.logLevel = newValue
        }
    }

    /// S3 Config values used by S3 transfer utility
    private let s3Config: S3ConfigProvider

    ///`SudoUserClient` instance required to issue authentication tokens
    unowned let sudoUserClient: SudoUserClient

    /// `SudoProfilesclient` instance required to get ownership proofs
    unowned let sudoProfilesClient: SudoProfilesClient

    /// GraphQL client for communicating with the Sudo  service.
    let graphQLClient: SudoApiClient

    /// Queue for processing API result.
    private let apiResultQueue = DispatchQueue(label: "com.sudoplatform.telephonyclient.api.result")

    /// Key used to instantiate the AWSS3TransferUtility.
    private let s3TransferUtilityKey = "com.sudoplatform.telephonyclient.s3TransferUtility"

    /// The key manager to use for creating telephony keys/passwords and performing cryptographic operations
    let keyManager: TelephonyKeyManager

    private let defaultFetchLimit: UInt = 10

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
            logger: self.logger
        )
    }()

    private var s3TransferUtility: AWSS3TransferUtility {
        if let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: s3TransferUtilityKey) {
            return transferUtility
        }

        // configure S3TransferUtility
        let s3RegionType = AWSRegionType.regionTypeForString(regionString: s3Config.region)
        let identityProviderManager = IdentityProviderManager(client: self.sudoUserClient,
                                                              region: s3Config.region,
                                                              poolId: s3Config.poolId)
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: s3RegionType,
                                                                identityPoolId: s3Config.identityPoolId,
                                                                identityProviderManager: identityProviderManager)
        // this constructor always returns a non-nil value
        let awsConfig = AWSServiceConfiguration(region: s3RegionType, credentialsProvider: credentialsProvider)!

        // register and retrieve the utility.
        // this retrieval will always succeed unless another thread calls reset()
        AWSS3TransferUtility.register(with: awsConfig, forKey: s3TransferUtilityKey)
        return AWSS3TransferUtility.s3TransferUtility(forKey: s3TransferUtilityKey)!
    }

    lazy var messageService: MessageService = {
        .init(graphQLClient: self.graphQLClient,
              queue: self.queue,
              logger: self.logger)
    }()

    lazy var messageMediaService: MessageMediaService = {
        return .init(s3TransferUtility: self.s3TransferUtility,
                     userClient: self.sudoUserClient,
                     transientBucket: s3Config.transientBucket,
                     region: s3Config.region,
                     logger: self.logger)
    }()

    lazy var conversationService: ConversationService = {
        return .init(graphQLClient: self.graphQLClient,
                     queue: self.queue,
                     logger: self.logger)
    }()

    lazy var phoneNumberService: PhoneNumberService = {
        return PhoneNumberService(graphQLClient: self.graphQLClient,
                                  queue: self.queue,
                                  logger: self.logger
        )
    }()

    lazy var subscriptionService: SubscriptionServices = {
        return SubscriptionService(graphQLClient: self.graphQLClient)
    }()

    lazy var ownerIdProvider: OwnerIdProvider = {
        return OwnerIdProvider(userClient: self.sudoUserClient)
    }()

    var useCaseFactory: UseCaseFactory = .init()

    // MARK: Lifecycle

    /// Initialize an instance of `DefaultSudoTelephonyClient`. It uses configuration parameters defined in `sudoplatformconfig.json` file located in the app
    /// bundle.
    /// - Parameters:
    ///   - keyNamespace: Namespace to use for the keys and passwords. This should be left as the default property.
    ///   - userClient: SudoUserClient instance used for authentication.
    ///   - profilesClient: SudoProfilesClient instance used for verifying sudo ownership proof.
    /// Throws:
    ///     - `SudoTelephonyClientError.invalidConfig` if invalid config.
    public convenience init(
        keyNamespace: String = "com.sudoplatform.telephony",
        userClient: SudoUserClient,
        profilesClient: SudoProfilesClient,
        callProviderConfiguration: CallProviderConfiguration?
    ) throws {

        // pull the S3 configuration values from the default config json.  This may not belong here,
        // but can be moved later.
        guard let configManager = DefaultSudoConfigManager(),
              let s3Config = S3ConfigProvider(configManager: configManager)
        else {
            throw SudoTelephonyClientError.invalidConfig
        }

        try self.init(
            config: nil,
            s3Config: s3Config,
            keyNamespace: keyNamespace,
            userClient: userClient,
            profilesClient: profilesClient,
            callProviderConfiguration: callProviderConfiguration
        )
    }

    convenience init(
        config: SudoTelephonyConfig?,
        s3Config: S3ConfigProvider,
        keyNamespace: String = "com.sudoplatform.telephony",
        userClient: SudoUserClient,
        profilesClient: SudoProfilesClient,
        callProviderConfiguration: CallProviderConfiguration?
    ) throws {
        let appSyncClient: SudoApiClient
        if let config = config {
            let authProvider = GraphQLAuthProvider(client: userClient)
            let cacheConfiguration = try AWSAppSyncCacheConfiguration()
            let appSyncConfig = try AWSAppSyncClientConfiguration(
                appSyncServiceConfig: config,
                userPoolsAuthProvider: authProvider,
                cacheConfiguration: cacheConfiguration)
            let client = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            appSyncClient = try SudoApiClient(appSyncClient: client)
        } else {
            guard let graphQLClient = try SudoApiClientManager.instance?.getClient(sudoUserClient: userClient) else {
                throw SudoTelephonyClientError.invalidConfig
            }
            appSyncClient = graphQLClient
        }

        let keyManager = DefaultTelephonyKeyManager(
            keyNamespace: keyNamespace,
            sudoUserClient: userClient,
            graphQLClient: appSyncClient,
            logger: .telephony
        )

        try self.init(
        sudoUserClient: userClient,
        sudoProfilesClient: profilesClient,
        callProviderConfiguration: callProviderConfiguration,
        s3Config: s3Config,
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
    ///   - callProviderConfiguration: Optional configuration object for calling related functionality.  If not provided, attempts to use calling features will throw an error.
    ///   - keyManager: `TelephonyKeyManager`
    ///   - graphQLClient: `AWSAppSyncClient`
    /// - Throws: `SudoTelephonyClientError.invalidConfig`
    internal init(
        sudoUserClient: SudoUserClient,
        sudoProfilesClient: SudoProfilesClient,
        callProviderConfiguration: CallProviderConfiguration?,
        s3Config: S3ConfigProvider,
        keyManager: TelephonyKeyManager,
        graphQLClient: SudoApiClient
    ) throws {

        #if DEBUG
        AWSDDLog.sharedInstance.logLevel = .verbose
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        #endif
        self.sudoUserClient = sudoUserClient
        self.sudoProfilesClient = sudoProfilesClient
        self.callProviderConfig = callProviderConfiguration
        self.s3Config = s3Config
        self.graphQLClient = graphQLClient
        self.keyManager = keyManager
    }

    // MARK: Reset

    public func reset() throws {
        logger.info("Resetting client state.")
        calling?.reset()
        AWSS3TransferUtility.remove(forKey: s3TransferUtilityKey)
        try graphQLClient.clearCaches(options: .init(clearQueries: true,
                                                     clearMutations: true,
                                                     clearSubscriptions: true))
        queue.cancelAllOperations()
        try keyManager.removeAllKeys()
        self.subscriptionService.clearSubscriptions()
    }

    // MARK: Supported Countries

    public func getSupportedCountries(completion: @escaping TelephonyClientCompletion<[String]>) {
        self.logger.info("Fetching supported countries")
        let useCase = useCaseFactory.generateGetSupportedCountriesUseCase(dataProvider: phoneNumberService)
        useCase.execute { result in
            completion(self.wrapInClientResult(result))
        }
    }

    // MARK: Search Phone Numbers

    public func searchAvailablePhoneNumbers(countryCode: String,
                                            limit: UInt?,
                                            completion: @escaping SudoTelephonySearchResult) {
        self.logger.info("Searching for available phone numbers for \(countryCode)")
        phoneNumberService.searchAvailablePhoneNumbers(countryCode: countryCode,
                                                            searchParams: nil,
                                                            limit: Int(limit ?? defaultFetchLimit)
        ) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func searchAvailablePhoneNumbers(countryCode: String,
                                            prefix: String,
                                            limit: UInt?,
                                            completion: @escaping SudoTelephonySearchResult) {
        // Searching will fail if the prefix is an empty string. Catch this case and send it to the sibling function that does not require a prefix
        guard !prefix.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return self.searchAvailablePhoneNumbers(countryCode: countryCode, limit: limit, completion: completion)
        }

        self.logger.info("Searching for available phone numbers for \(countryCode) and prefix \(prefix)")
        phoneNumberService.searchAvailablePhoneNumbers(countryCode: countryCode,
                                                            searchParams: .prefix(prefix),
                                                            limit: Int(limit ?? defaultFetchLimit)
        ) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func searchAvailablePhoneNumbers(countryCode: String,
                                            latitude: Double,
                                            longitude: Double,
                                            limit: UInt?,
                                            completion: @escaping SudoTelephonySearchResult) {
        self.logger.info("Searching for available phone numbers for \(countryCode) and latitude \(latitude), longitude \(longitude)")

        phoneNumberService.searchAvailablePhoneNumbers(countryCode: countryCode,
                                                            searchParams: .gps(.init(lat: latitude, long: longitude)),
                                                            limit: Int(limit ?? defaultFetchLimit)
        ) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    // MARK: Provision Number

    public func provisionPhoneNumber(countryCode: String,
                                     phoneNumber: String,
                                     sudoId: String,
                                     completion: @escaping TelephonyClientCompletion<PhoneNumber>) {
        self.logger.info("Provisioning phone number \(phoneNumber)")

        // Create dependencies
        let publicKeyGenerator = PublicKeyGenerator(keyManager: self.keyManager,
                                                    graphQLClient: self.graphQLClient)
        let ownershipProofProvider = OwnershipProofProvider(profilesClient: sudoProfilesClient)
        let identityProvider = IdentityIdProvider(userClient: sudoUserClient)

        // Generate use case
        let useCase = useCaseFactory.generateProvisionPhoneNumberUseCase(numberProvider: self.phoneNumberService,
                                                                         keyManager: self.keyManager,
                                                                         identityProvider: identityProvider,
                                                                         ownershipProofProvider: ownershipProofProvider,
                                                                         publicKeyGenerator: publicKeyGenerator)

        // Execute use case
        useCase.execute(provisioning: phoneNumber, countryCode: countryCode, sudoId: sudoId) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func deletePhoneNumber(phoneNumber: String,
                                  completion: @escaping TelephonyClientCompletion<String>) {
        self.logger.info("Deleting phone number \(phoneNumber)")
        let useCase = useCaseFactory.generateDeletePhoneNumberUseCase(service: phoneNumberService)
        useCase.execute(phoneNumber: phoneNumber) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    // MARK: List Numbers
    public func listPhoneNumbers(sudoId: String?,
                                 limit: Int?,
                                 nextToken: String?,
                                 completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneNumber>>) {
        self.logger.info("Listing phone numbers")

        let useCase = useCaseFactory.generateListPhoneNumbersUseCase(service: phoneNumberService)
        useCase.execute(sudoID: sudoId,
                        limit: limit,
                        nextToken: nextToken) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func getPhoneNumber(id: String,
                               completion: @escaping TelephonyClientCompletion<PhoneNumber?>) {
        self.logger.info("Getting phone number \(id)")

        let useCase = useCaseFactory.generateGetPhoneNumberUseCase(service: phoneNumberService)
        useCase.execute(id: id) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    // Small helper to deal with transformation of client error types.
    private func wrapInClientResult<T>(_ result: Swift.Result<T, Error>) -> Swift.Result<T, SudoTelephonyClientError> {
        return result.mapError({ error in
            ErrorTransformer.transform(error: error)
        })
    }

    // MARK: Send Message

    public func sendSMSMessage(localNumber: PhoneNumber,
                               remoteNumber: String,
                               body: String,
                               completion: @escaping TelephonyClientCompletion<PhoneMessage>) {
        self.logger.info("Sending SMS Message")

        let useCase = self.useCaseFactory.generateSendMessageUseCase(messageService: messageService,
                                                                     mediaService: self.messageMediaService,
                                                                     keyManager: self.keyManager)
        useCase.execute(localNumber: localNumber.phoneNumber,
                        remoteNumber: remoteNumber,
                        body: body) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func sendMMSMessage(localNumber: PhoneNumber,
                               remoteNumber: String,
                               body: String?,
                               localUrl: URL,
                               completion: @escaping TelephonyClientCompletion<PhoneMessage>) {
        self.logger.info("Sending MMS Message")
        let useCase = self.useCaseFactory.generateSendMessageUseCase(messageService: messageService,
                                                                     mediaService: self.messageMediaService,
                                                                     keyManager: self.keyManager)
        useCase.execute(localNumber: localNumber.phoneNumber,
                        remoteNumber: remoteNumber,
                        body: body,
                        mediaAttachment: localUrl) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    // MARK: Get Message

    public func getMessage(id: String,
                           completion: @escaping TelephonyClientCompletion<PhoneMessage>) {
        logger.info("Getting Phone Message \(id)")
        let useCase = useCaseFactory.generateGetMessageUseCase(messageService: messageService,
                                                                    keyManager: keyManager)
        useCase.execute(id: id) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func getMessages(localNumber: PhoneNumber,
                            remoteNumber: String,
                            limit: Int?,
                            nextToken: String?,
                            completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneMessage>>) {
        guard let ownerId = self.ownerIdProvider.resolveOwnerId() else {
            completion(.failure(.getConversationFailed))
            return
        }

        let useCase = useCaseFactory.generateListMessagesUseCase(messageService: messageService,
                                                                      keyManager: keyManager)

        useCase.execute(localNumber: localNumber.phoneNumber,
                        remoteNumber: remoteNumber,
                        ownerId: ownerId,
                        limit: limit,
                        nextToken: nextToken) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func getMessages(conversationId: String,
                            limit: Int?,
                            nextToken: String?,
                            completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneMessage>>) {
        self.logger.info("Getting Phone Messages for conversation \(conversationId)")

        guard let keyId = keyManager.getKeyId() else {
            return completion(.failure(.getConversationFailed))
        }

        let useCase = useCaseFactory.generateListMessagesUseCase(messageService: messageService,
                                                                 keyManager: keyManager)

        useCase.execute(conversationId: conversationId,
                        keyId: keyId,
                        limit: limit,
                        nextToken: nextToken) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func deleteMessage(id: String,
                              completion: @escaping TelephonyClientCompletion<String>) {
        self.logger.info("Deleting phone message \(id)")
        let useCase = DeleteMessageUseCase(messageService: messageService)
        useCase.execute(id: id) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    // MARK: Download Data

    public func downloadData(for media: MediaObject,
                             completion: @escaping TelephonyClientCompletion<Data>) {
        self.logger.info("Downloading data \(media.key)")
        let useCase = useCaseFactory.generateDownloadDataUseCase(service: messageMediaService,
                                                                 keyManager: keyManager)

        useCase.execute(with: media) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    // MARK: Subscriptions

    public func subscribeToMessages(statusObserver: SubscriptionHandler<SubscriptionStatus>?,
                                    resultHandler: @escaping SubscriptionHandler<PhoneMessage>) throws -> SubscriptionToken? {
        guard let ownerId = self.ownerIdProvider.resolveOwnerId() else {
            throw SudoTelephonyClientError.notSignedIn
        }
        let useCase = useCaseFactory.generateSubscribeToMessagesUseCase(service: subscriptionService,
                                                                        keyManager: keyManager)
        return try useCase.execute(ownerId: ownerId,
                                   statusObserver: statusObserver,
                                   resultHandler: resultHandler)
    }

    // MARK: Get Conversations

    public func getConversation(conversationId: String,
                                completion: @escaping TelephonyClientCompletion<PhoneMessageConversation>) {
        self.logger.info("Fetching conversation \(conversationId)")

        let useCase = useCaseFactory.generateGetConversationUseCase(conversationService: conversationService,
                                                                             messageService: messageService,
                                                                             keyManager: keyManager)

        useCase.execute(conversationId: conversationId) { result in
            completion(self.wrapInClientResult(result))
        }
    }

    public func getConversation(localNumber: PhoneNumber,
                                remoteNumber: String,
                                completion: @escaping TelephonyClientCompletion<PhoneMessageConversation>) {
        guard let ownerId = self.ownerIdProvider.resolveOwnerId() else {
            completion(.failure(.getConversationFailed))
            return
        }

        let id = ConversationIdGenerator.conversationIdWith(localNumber: localNumber.phoneNumber,
                                                            remoteNumber: remoteNumber,
                                                            ownerId: ownerId)
        
        return getConversation(conversationId: id, completion: completion)
    }

    public func getConversations(localNumber: PhoneNumber,
                                 limit: Int?,
                                 nextToken: String?,
                                 completion: @escaping TelephonyClientCompletion<TelephonyListToken<PhoneMessageConversation>>) {
        self.logger.info("Fetching conversations")

        let useCase = useCaseFactory.generateListConversationsUseCaseUseCase(conversationService: conversationService,
                                                                             messageService: messageService,
                                                                             keyManager: keyManager)

        useCase.execute(localNumberId: localNumber.id,
                        limit: limit,
                        nextToken: nextToken) { result in
            completion(self.wrapInClientResult(result))
        }
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
        do {
        try graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: apiResultQueue) { (result, error) in
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
        } catch {
            completion(.failure(SudoTelephonyClientError(serviceError: error)))
        }
    }

    public func getVoicemails(localNumber: PhoneNumber, limit: Int?, nextToken: String?, completion: @escaping (Swift.Result<TelephonyListToken<Voicemail>, SudoTelephonyClientError>) -> Void) {
        let query = ListVoicemailsQuery(
            key: VoicemailKeyInput(phoneNumberId: localNumber.id),
            limit: limit,
            nextToken: nextToken
        )
        do {
        try graphQLClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: apiResultQueue) { (result, error) in
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
        } catch {
            completion(.failure(SudoTelephonyClientError(serviceError: error)))
        }
    }

    public func deleteVoicemail(id: String, completion: @escaping (Swift.Result<Void, SudoTelephonyClientError>) -> Void) {
        let mutation = DeleteVoicemailMutation(id: id)
        do {
        try graphQLClient.perform(mutation: mutation, queue: apiResultQueue, optimisticUpdate: nil, conflictResolutionBlock: nil) { (result, error) in
            if let error = error {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            if let error = result?.errors?.first {
                return completion(.failure(SudoTelephonyClientError(serviceError: error)))
            }

            return completion(.success(()))
        }
        } catch {
            completion(.failure(SudoTelephonyClientError(serviceError: error)))
        }
    }

    public func subscribeToVoicemails(resultHandler: @escaping (Swift.Result<Voicemail, SudoTelephonyClientError>) -> Void) throws -> SubscriptionToken {
        guard let calling = self.calling else {
            throw CallConfigurationError.missingCallProviderConfiguration
        }
        return try calling.subscribeToVoicemails(resultHandler: resultHandler)
    }
}
