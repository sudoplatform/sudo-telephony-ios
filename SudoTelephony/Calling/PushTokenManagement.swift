//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import AWSAppSync
import CallKit
import Foundation
import SudoLogging
import SudoOperations
import SudoUser
import TwilioVoice

class PushTokenManagement {

    /// Push token must be cached locally in order to unregister with voice providers.
    var lastRecievedVoipPushToken: (token: Data, useSandbox: Bool)? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "SudoTelephonyCall.voipPushToken.data"),
                let sandbox = UserDefaults.standard.object(forKey: "SudoTelephonyCall.voipPushToken.useSandbox") as? Bool else {
                    return nil
            }
            return (token: data, useSandbox: sandbox)
        }
        set {
            UserDefaults.standard.set(newValue?.token, forKey: "SudoTelephonyCall.voipPushToken.data")
            UserDefaults.standard.set(newValue?.useSandbox, forKey: "SudoTelephonyCall.voipPushToken.useSandbox")
        }
    }

    let graphQLClient: AWSAppSyncClient
    let apiResultQueue: DispatchQueue
    let sudoUserClient: SudoUserClient
    let logger: Logger
    let operationQueue = PlatformOperationQueue()

    /// Instantiates the calling feature.
    init(
        graphQLClient: AWSAppSyncClient,
        apiResultQueue: DispatchQueue,
        sudoUserClient: SudoUserClient,
        logger: Logger
    ) {
        self.graphQLClient = graphQLClient
        self.apiResultQueue = apiResultQueue
        self.sudoUserClient = sudoUserClient
        self.logger = logger
    }

    func registerForIncomingCalls(with token: Data, useSandbox: Bool, completion: ((SudoTelephonyClientError?) -> Void)?) {
        // Cache the push token so it can be access later when de-registering
        self.lastRecievedVoipPushToken = (token: token, useSandbox: useSandbox)

        self.logger.info("Registering for incoming calls.")

        let operation = WaitForUserSignInOperation(sudoUserClient: self.sudoUserClient, logger: self.logger)
        operation.completionBlock = {
            self.getPushProviderAccessToken(register: true, useSandbox: useSandbox) { (result) in
                switch result {
                case .success(let auths):
                    self.registerPushToken(data: token, vendorAuthorizations: auths, completion: completion)
                case .failure(let error):
                    self.logger.info("Failed to register for incoming calls.")
                    completion?(error)
                }
            }
        }

        self.operationQueue.addOperation(operation)
    }

    private func registerPushToken(data: Data, vendorAuthorizations: [DeviceRegistrationOutput.VendorAuthorization], completion: ((SudoTelephonyClientError?) -> Void)?) {

        if let twilioAuth = vendorAuthorizations.filter({ $0.vendor == "Twilio" }).first {
            TwilioVoice.register(withAccessToken: twilioAuth.accessToken, deviceToken: data) { (error) in

                if let error = error {
                    self.logger.error("Failed to register push token with provider: \(error)")
                }
                else {
                    self.logger.info("Registered push token with provider")
                }

                // return a generic error rather than exposing a Twilio error.
                completion?(error.map { _ in return SudoTelephonyClientError.requestFailed })
            }
        }
    }

    func deregisterForIncomingCalls(completion: ((SudoTelephonyClientError?) -> Void)?) {
        self.logger.info("Deregistering voip push token with providers")
        guard let pushToken = self.lastRecievedVoipPushToken else {
            self.logger.warning("Attempt to deregister voip push token with providers, but no cached token found.")
            completion?(.internalError)
            return
        }

        let operation = WaitForUserSignInOperation(sudoUserClient: self.sudoUserClient, logger: self.logger)
        operation.completionBlock = {
            self.getPushProviderAccessToken(register: false, useSandbox: pushToken.useSandbox) { (result) in
                switch result {
                case .success(let auths):
                    self.deregisterPushToken(data: pushToken.token, vendorAuthorizations: auths, completion: completion)
                case .failure(let error):
                    self.logger.info("Failed to de-register voip push token with providers.")
                    completion?(error)
                }
            }
        }

        self.operationQueue.addOperation(operation)
    }

    private func deregisterPushToken(data: Data, vendorAuthorizations: [DeviceRegistrationOutput.VendorAuthorization], completion: ((SudoTelephonyClientError?) -> Void)?) {

        if let twilioAuth = vendorAuthorizations.filter({ $0.vendor == "Twilio" }).first {
            TwilioVoice.unregister(withAccessToken: twilioAuth.accessToken, deviceToken: data) { (maybeError) in
                if let error = maybeError {
                    self.logger.error("Failed to de-register push token with provider: \(error)")
                }
                else {
                    self.logger.info("de-registered push token with provider")
                }

                // return a generic error rather than exposing a Twilio error.
                completion?(maybeError.map { _ in return SudoTelephonyClientError.requestFailed })
            }
        }
    }

    /// Does the work to get an access token from the service to register/deregister.  Handles the different code paths for the register and unregister mutations.
    /// - Parameter register: Switches between getting a token for registering and unregistering.
    /// - Parameter useSandbox: tells the service to use the APNS sandbox or not.
    /// - Parameter completion: mutation independent handler to handle parsing the errors or access tokens from the response.
    private func getPushProviderAccessToken(register: Bool,
                                            useSandbox: Bool,
                                            completion: @escaping (Swift.Result<[DeviceRegistrationOutput.VendorAuthorization], SudoTelephonyClientError>) -> Void) -> Void {

        let isSignedIn = (try? self.sudoUserClient.isSignedIn()) ?? false
        guard isSignedIn else {
            self.logger.error("Attempted to get push provider access tokens, but client is not logged in as expected.")
            completion(.failure(SudoTelephonyClientError.internalError))
            return
        }

        let service: PushNotificationService = useSandbox ? PushNotificationService.apnsSandbox : PushNotificationService.apns

        let input = DeviceRegistrationInput(pushNotificationService: service)


        // generic handler to handle the response for register and unregister.
        func handler(data: DeviceRegistrationOutput?, error: Error?) {
            guard error == nil else {
                let clientError = SudoTelephonyClientError(serviceError: error)
                self.logger.error("Error fetching access token to update push token: \(clientError)")
                completion(.failure(clientError))
                return
            }

            guard let result = data else {
                self.logger.error("Error fetching push provider access tokens.  Service returned success but no authorizations found.")
                completion(.failure(SudoTelephonyClientError.requestFailed))
                return
            }

            self.logger.info("Successfully fetched push provider access tokens")

            let authorizations = result.vendorAuthorizations.compactMap({ return $0 })
            completion(.success(authorizations))
        }

        if register {
            let register = RegisterForIncomingCallsMutation(input: input)
            self.graphQLClient.perform(mutation: register, queue: self.apiResultQueue) { (result, error) in
                let output = result?.data?.registerDeviceForIncomingCalls.fragments.deviceRegistrationOutput
                handler(data: output, error: error ?? result?.errors?.first)
            }
        }
        else {
            let unregister = UnregisterForIncomingCallsMutation(input: input)
            self.graphQLClient.perform(mutation: unregister, queue: self.apiResultQueue) { (result, error) in
                let output = result?.data?.unregisterDeviceForIncomingCalls.fragments.deviceRegistrationOutput
                handler(data: output, error: error ?? result?.errors?.first)
            }
        }
    }
}
