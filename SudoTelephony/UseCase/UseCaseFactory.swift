//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging
import SudoOperations

///
/// Use cases take services and perform actions for the client.  These could be multi-step processes
/// like sending an SMS message or downloading a list of messages.  Or it could be simple like deleting
/// a number (i.e. a simple pass through).  The factory facilitates mocking for the client so we can
/// test it without the business logic of use cases running.
///
class UseCaseFactory {
    func generateGetSupportedCountriesUseCase(dataProvider: PhoneNumberServices) -> GetSupportedCountriesUseCase {
        return GetSupportedCountriesUseCase(dataProvider: dataProvider)
    }

    func generateProvisionPhoneNumberUseCase(numberProvider: PhoneNumberServices,
                                             keyManager: TelephonyKeyManager,
                                             identityProvider: IdentityIdProviding,
                                             ownershipProofProvider: OwnershipProofProviding,
                                             publicKeyGenerator: PublicKeyGenerating,
                                             logger: Logger = .telephony)
        -> ProvisionPhoneNumberUseCase
    {
        return ProvisionPhoneNumberUseCase(numberProvider: numberProvider,
                                           keyManager: keyManager,
                                           identityProvider: identityProvider,
                                           ownershipProofProvider: ownershipProofProvider,
                                           publicKeyGenerator: publicKeyGenerator,
                                           logger: logger)
    }

    func generateSendMessageUseCase(messageService: MessageServices,
                                    mediaService: MessageMediaServices,
                                    keyManager: TelephonyKeyManager) -> SendMessageUseCase {
        return SendMessageUseCase(messageService: messageService,
                                  mediaService: mediaService,
                                  keyManager: keyManager)
    }

    func generateGetMessageUseCase(messageService: MessageServices,
                                   keyManager: TelephonyKeyManager) -> GetMessageUseCase {
       return GetMessageUseCase(messageService: messageService,
                                keyManager: keyManager)
    }

    func generateListMessagesUseCase(messageService: MessageServices,
                                     keyManager: TelephonyKeyManager) -> ListMessagesUseCase {
        return ListMessagesUseCase(messageService: messageService, keyManager: keyManager)
    }

    func generateDeleteMessageUseCase(messageService: MessageServices) -> DeleteMessageUseCase {
        return DeleteMessageUseCase(messageService: messageService)
    }

    func generateDownloadDataUseCase(service: MessageMediaService,
                                     keyManager: TelephonyKeyManager) -> DownloadDataUseCase {
        return DownloadDataUseCase(service: service, keyManager: keyManager)
    }

    func generateGetPhoneNumberUseCase(service: PhoneNumberService) -> GetPhoneNumberUseCase {
        return GetPhoneNumberUseCase(service: service)
    }

    func generateListPhoneNumbersUseCase(service: PhoneNumberService) -> ListPhoneNumbersUseCase {
        return ListPhoneNumbersUseCase(service: service)
    }

    func generateDeletePhoneNumberUseCase(service: PhoneNumberService) -> DeletePhoneNumberUseCase {
        return DeletePhoneNumberUseCase(service: service)
    }

    func generateSubscribeToMessagesUseCase(service: SubscriptionServices,
                                            keyManager: TelephonyKeyManager) -> SubscribeToMessagesUseCase {
        return SubscribeToMessagesUseCase(service: service, keyManager: keyManager)
    }

    func generateListConversationsUseCaseUseCase(conversationService: ConversationServices,
                                                 messageService: MessageServices,
                                                 keyManager: TelephonyKeyManager) -> ListConversationsUseCase {
        return ListConversationsUseCase(conversationService: conversationService,
                                        messageService: messageService,
                                        keymanager: keyManager)
    }

    func generateGetConversationUseCase(conversationService: ConversationServices,
                                                 messageService: MessageServices,
                                                 keyManager: TelephonyKeyManager) -> GetConversationUseCase {
        return GetConversationUseCase(conversationService: conversationService,
                                        messageService: messageService,
                                        keymanager: keyManager)
    }
}
