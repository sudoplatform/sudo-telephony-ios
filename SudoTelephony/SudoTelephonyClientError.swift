//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync

/// List of possible errors thrown by `SudoTelephonyClient`.
public enum SudoTelephonyClientError: Error, LocalizedError {
    /// Not signed in to the service
    case notSignedIn
    /// Bad configuration, something went wrong setting this up.
    case invalidConfig
    /// Authentication failed, meaning the user is not signed in or registered.
    case authenticationFailed(Error)
    /// Request to the backend failed for some reason.
    case requestFailed
    /// Internal error that could mean data was not returned or parsed properly.
    case internalError
    /// Number provisioning Failed
    case numberProvisioningFailed
    /// Country provided for the request is not supported.
    case countryNotSupported(String)
    /// Message send failed
    case messageSendFailed
    /// Message retrieval failed
    case getMessageFailed
    /// Message subscription failed
    case messageSubscriptionFailed
    /// Conversation retrieval failed
    case getConversationFailed
    /// CallRecord retrieval failed
    case getCallRecordFailed
    /// CallRecord decryption failed
    case callRecordDecryptionFailed
    /// CallRecord subscription failed
    case callRecordSubscriptionFailed
    /// `Voicemail` retrieval failed
    case getVoicemailFailed
    /// `Voicemail` decryption failed
    case voicemailDecryptionFailed(Error)
    /// `Voicemail` subscription failed
    case voicemailSubscriptionFailed(Error?)
    /// One or more invalid inputs were passed on the request.
    case invalidInput
    /// Key Pair failed to be generated for new phone number.
    case keyGenerationFailed
    /// Key Pair failed to be deleted for phone number.
    case keyDeletionFailed
    /// Failed to get ownership proof when provisioning a number
    case ownershipProofFailed
    /// User has no public keys
    case noPublicKey
    /// Sealed data decryption failed
    case sealedDataDecryptionFailed
    /// File not found at provided path
    case fileNotFound
    /// Invalid file format
    case invalidFileFormat
    /// MMS file upload failed
    case fileUploadFailed
    /// File download failed
    case fileDownloadFailed
    /// Message decryption failed
    case messageDecryptionFailed
    /// Collective size of message media exceeds limit
    case messageMediaTooLarge
    /// Insufficient entitlements to perform the requested action.
    case insufficientEntitlement
    /// Invalid GPS or Area Code prefix provided
    case invalidSearchError
    /// Ownership attestation resulted in unauthorized
    case failedOwnershipCheck
    /// Exceeded the number of media objects allowed.
    case maximumMediaObject
    /// Unsupported media type
    case unsupportedMediaContentType
    /// Service configuration error
    case configurationError
    /// Unknown Error ocurred
    case unknown

    public var errorDescription: String? {
        switch self {
        case .notSignedIn:
            return "Not signed in"
        case .invalidConfig:
            return "Invalid AWS configuration"
        case .authenticationFailed(let error):
            return "Failed to authenticate: \(error.localizedDescription)."
        case .requestFailed:
            return "GraphQL request failed"
        case .internalError:
            return "An internal error ocurred. Please try again later."
        case .numberProvisioningFailed:
            return "Failed to provision a phone number"
        case .countryNotSupported(let countryCode):
            return "Unsupported country \(countryCode) used for operation."
        case .messageSendFailed:
            return "Failed to send message"
        case .getMessageFailed:
            return "Failed to get phone message"
        case .messageSubscriptionFailed:
            return "Failed to subscribe to message events"
        case .getConversationFailed:
            return "Failed to get conversation"
        case .getCallRecordFailed:
            return "Failed to get call record"
        case .callRecordDecryptionFailed:
            return "Failed to decrypt the sealed data"
        case .callRecordSubscriptionFailed:
            return "Failed to subscribe to call record events"
        case .getVoicemailFailed:
            return "Failed to get voicemail"
        case .voicemailDecryptionFailed(let error):
            return "Failed to decrypt voicemail: \(error.localizedDescription)"
        case .voicemailSubscriptionFailed(let error):
            return "Failed to subscribe to voicemail events\(error.map { ": \($0.localizedDescription)" } ?? "")"
        case .invalidInput:
            return "One or more invalid inputs were passed on the request."
        case .keyGenerationFailed:
            return "Key pair failed to be generated on new phone number."
        case .keyDeletionFailed:
            return "Key pair failed to be deleted for phone number."
        case .ownershipProofFailed:
            return "Failed to get ownership proof for number provisioning."
        case .noPublicKey:
            return "User has no public keys"
        case .sealedDataDecryptionFailed:
            return "Failed to decrypt the sealed data"
        case .fileNotFound:
            return "File not found at provided path"
        case .invalidFileFormat:
            return "Invalid file format"
        case .fileUploadFailed:
            return "Failed to upload file"
        case .fileDownloadFailed:
            return "Failed to download file"
        case .messageDecryptionFailed:
            return "Failed to decrypt message data"
        case .messageMediaTooLarge:
            return "Message media too large"
        case .insufficientEntitlement:
            return "Resource limit exceeded"
        case .invalidSearchError:
            return "Invalid GPS or Area Code prefix provided"
        case .failedOwnershipCheck:
            return "Ownership attestation resulted in unauthorized"
        case .maximumMediaObject:
            return "Exceeded the number of media objects allowed."
        case .unsupportedMediaContentType:
            return "Unsupported media type"
        case .configurationError:
            return "Service configuration error"
        case .unknown:
            return "An unknown error has ocurred. Please try again later."
        }
    }

    init(internalError: GraphQLError) {
        guard let errorType = internalError["errorType"] as? String else {
            self = .unknown
            return
        }

        switch errorType {
        case "sudoplatform.telephony.UnsupportedCountryError":
            self = .countryNotSupported("")
        case "ValidationException", "sudoplatform.DecodingError":
            self = .invalidInput
        case "sudoplatform.telephony.NoPhoneNumberEntitlementError":
            self = .insufficientEntitlement
        case "sudoplatform.telephony.MessageMediaTooLarge":
            self = .messageMediaTooLarge
        case "sudoplatform.telephony.InvalidSearchError":
            self = .invalidSearchError
        case "sudoplatform.telephony.FailedOwnershipCheck":
            self = .failedOwnershipCheck
        case "sudoplatform.telephony.MaximumMediaObject":
            self = .maximumMediaObject
        case "sudoplatform.telephony.UnsupportedMediaContentType":
            self = .unsupportedMediaContentType
        case "sudoplatform.telephony.NoPublicKeyError":
            self = .noPublicKey
        case "sudoplatform.telephony.ConfigurationError":
            self = .configurationError
        default:
            self = .unknown
        }
    }

    /// Initializes a SudoTelephonyClientError from an error retured by the service.
    /// Will convert GraphQLError as well.
    ///
    /// - Parameters:
    ///   - serviceError: Error returned by the service.
    init(serviceError: Error?) {

        guard let error = serviceError else {
            self = .unknown
            return
        }

        switch error {
        case AWSAppSyncClientError.authenticationError(let error):
            self = SudoTelephonyClientError.authenticationFailed(error)
        case AWSAppSyncClientError.requestFailed:
            self = SudoTelephonyClientError.requestFailed
        case let error as GraphQLError:
            self = SudoTelephonyClientError(internalError: error)
        default:
            self = SudoTelephonyClientError.internalError
        }
    }
}
