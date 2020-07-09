//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// A Message that has been either received or sent by the user.
public struct PhoneMessage {
    
    /// Enum that represents the direction of the message.
    public enum Direction {
        case inbound
        case outbound
        case unknown
        
        init(internalDirection: SudoTelephony.Direction) {
            switch internalDirection {
            case .inbound:
                self = .inbound
            case .outbound:
                self = .outbound
            case .unknown:
                self = .unknown
            }
        }
    }
    
    /// The state of the message
    public enum State {
        case queued
        case sent
        case delivered
        case undelivered
        case failed
        case received
        case unknown
        
        init(internalState: MessageState) {
            switch internalState {
            case .queued:
                self = .queued
            case .sent:
                self = .sent
            case .delivered:
                self = .delivered
            case .undelivered:
                self = .undelivered
            case .failed:
                self = .failed
            case .received:
                self = .received
            case .unknown:
                self = .unknown
            }
        }
    }
    
    /// Unique ID of the message
    public let id: String
    /// The ID of the owner of the message
    public let owner: String
    /// The conversation ID that this message belongs to
    public let conversation: String
    /// Timestamp that represents the last time the message got updated
    public let updated: Date
    /// Timestamp that represents the time the message got created
    public let created: Date
    /// The E164Number of the local phone number
    public let localPhoneNumber: String
    /// The E164Number of the remote phone number
    public let remotePhoneNumber: String
    /// The body of the message
    public let body: String
    /// The direction of the message. Either `outbound` or `inbound`
    public let direction: Direction
    /// The state of the sending of the message.
    public let state: State
    /// Media Attachments
    public let media: [MediaObject]
}

/// A remote media object
public struct MediaObject {
    public let key: String
    public let bucket: String
    public let region: String

    internal init(media: S3MediaObject) {
        self.key = media.key
        self.bucket = media.bucket
        self.region = media.region
    }
}

extension PhoneMessage {

    /// Convenience function to parse and decrypt the getMessageQuery data into a PhoneMessage.
    /// ideally this is a convenience init, but structs don't allow this.
    ///
    /// - Parameter Data: The sealed message data
    /// - Parameter client: The telephony client used to decrypt the sealed body.
    /// - Returns: A decrypted PhoneMessage
    /// - Throws: SudoTelephonyClient error if the sealed message data cannot be processed into a PhoneMessage
    static func createFrom(data: GetMessageQuery.Data.GetMessage, client: DefaultSudoTelephonyClient) throws -> PhoneMessage {

        guard let sealedBody = data.body,
            let sealedBodyData = Data(base64Encoded: sealedBody, options: .ignoreUnknownCharacters),
            let sealedRemoteData = Data(base64Encoded: data.remotePhoneNumber, options: .ignoreUnknownCharacters),
            let sealedLocalData = Data(base64Encoded: data.localPhoneNumber, options: .ignoreUnknownCharacters) else {
                throw SudoTelephonyClientError.sealedDataDecryptionFailed
        }

        do {
            let decryptedBody = try client.decryptSealedData(data: sealedBodyData)
            let decryptedRemote = try client.decryptSealedData(data: sealedRemoteData)
            let decryptedLocal = try client.decryptSealedData(data: sealedLocalData)
            let bodyText = String(decoding: decryptedBody, as: UTF8.self)
            let remote = String(decoding: decryptedRemote, as: UTF8.self)
            let local = String(decoding: decryptedLocal, as: UTF8.self)

            let phoneMessage = PhoneMessage(id: data.id,
                                                owner: data.owner,
                                                conversation: data.conversation,
                                                updated: Date(timeIntervalSinceNow: TimeInterval(data.updatedAtEpochMs / 1000)),
                                                created: Date(timeIntervalSinceNow: TimeInterval(data.createdAtEpochMs / 1000)),
                                               localPhoneNumber: local,
                                                remotePhoneNumber: remote,
                                                body: bodyText,
                                                direction: PhoneMessage.Direction(internalDirection: data.direction),
                                                state: PhoneMessage.State(internalState: data.state),
                                                media: data.media?.map { MediaObject(media: $0.fragments.s3MediaObject) } ?? [])

            return phoneMessage
        } catch {
            throw SudoTelephonyClientError.messageDecryptionFailed
        }
    }
}



