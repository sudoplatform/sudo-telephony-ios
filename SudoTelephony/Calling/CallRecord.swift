//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct CallRecord {
    /// Enum that represents the direction of the call.
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

    // Enum that represents the state of the call record.
    public enum State {
        case authorized
        case queued
        case ringing
        case answered
        case completed
        case unanswered
        case unknown

        init(internalState: CallState) {
            switch internalState {
            case .authorized:
                self = .authorized
            case .queued:
                self = .queued
            case .ringing:
                self = .ringing
            case .answered:
                self = .answered
            case .completed:
                self = .completed
            case .unanswered:
                self = .unanswered
            case .unknown:
                self = .unknown
            }
        }
    }

    /// Voicemail data belonging to a call record
    public struct VoicemailData {
        /// Unique ID of the voicemail record
        public let id: String
        /// The duration of the voicemail recording in seconds
        public let durationSeconds: UInt
        /// The media object that can be used to download the voicemail recording
        public let media: MediaObject
    }

    /// Unique ID of the call record
    public let id: String
    /// The user ID of the owner of the call record (also referred to as the subject)
    public let owner: String
    /// The ID of the sudo that made or received the call
    public let sudoOwner: String
    /// The ID of the `PhoneNumber` associated with the call record
    public let phoneNumberId: String
    /// The direction of the call. Either `outbound` or `inbound`
    public let direction: Direction
    /// The state of the call record
    public let state: State
    /// Timestamp that represents the last time the call was updated
    public let updated: Date
    /// Timestamp that represents the time the call was created
    public let created: Date
    /// The E164Number of the local phone number
    public let localPhoneNumber: String
    /// The E164Number of the remote phone number
    public let remotePhoneNumber: String
    /// The duration of the call in seconds
    public let durationSeconds: UInt32
    /// The voicemail data of this call record if it exists
    public let voicemail: VoicemailData?
}

extension CallRecord {
    /// Convenience function to parse and decrypt the `SealedCallRecord` GraphQL fragment into a `CallRecord`.
    ///
    /// - Parameter sealed: The sealed call record data
    /// - Parameter keyManager: The telephony key manager used to decrypt the sealed body.
    /// - Returns: A decrypted CallRecord
    /// - Throws: SudoTelephonyClient error if the sealed call record data cannot be processed into a CallRecord
    init(decrypting sealed: SealedCallRecord, keyManager: TelephonyKeyManager) throws {
        guard let sealedData = sealed.sealed.first(where: { $0.keyId == keyManager.getKeyId() }) else {
            throw SudoTelephonyClientError.internalError
        }

        let sealedVoicemailData = (sealed.voicemailId, sealedData.voicemail)
            as? (String, SealedCallRecord.Sealed.Voicemail)

        self.init(
            id: sealed.id,
            owner: sealed.owner,
            sudoOwner: sealed.sudoOwner,
            phoneNumberId: sealed.phoneNumberId,
            direction: Direction(internalDirection: sealed.direction),
            state: State(internalState: sealed.state),
            updated: Date(timeIntervalSince1970: sealed.updatedAtEpochMs / 1000),
            created: Date(timeIntervalSince1970: sealed.createdAtEpochMs / 1000),
            localPhoneNumber: try keyManager.decrypt(sealedData.localPhoneNumber),
            remotePhoneNumber: try keyManager.decrypt(sealedData.remotePhoneNumber),
            durationSeconds: try sealedData.durationSeconds.map { try keyManager.decrypt($0) } ?? 0,
            voicemail: try sealedVoicemailData.map { (voicemailId, sealedVoicemail) in
                VoicemailData(
                    id: voicemailId,
                    durationSeconds: UInt(try keyManager.decrypt(sealedVoicemail.durationSeconds)),
                    media: MediaObject(media: sealedVoicemail.media.fragments.s3MediaObject)
                )
            }
        )
    }
}
