//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

/// A voicemail record.
public struct Voicemail {
    /// Unique ID of the voicemail record
    public let id: String
    /// The ID of the Sudo Platform user that owns the voicemail.
    public let owner: String
    /// The ID of the Sudo that received the voicemail.
    public let sudoOwner: String
    /// The ID of the `PhoneNumber` associated with the voicemail.
    public let phoneNumberId: String
    /// The ID of the `CallRecord` associated with the voicemail.
    public let callRecordId: String?
    /// Timestamp that represents the time the voicemail was created.
    public let created: Date
    /// Timestamp that represents the last time the voicemail was updated.
    public let updated: Date
    /// The E.164 formatted phone number that received the voicemail.
    public let localPhoneNumber: String
    /// The E.164 formatted phone number of the caller.
    public let remotePhoneNumber: String
    /// The duration of the voicemail recording in seconds.
    public let durationSeconds: UInt
    /// The media object that can be used to download the voicemail recording.
    public let media: MediaObject
}

extension Voicemail {
    init(decrypting sealed: SealedVoicemail, keyManager: TelephonyKeyManager) throws {
        guard let sealedData = sealed.sealed.first(where: { $0.keyId == keyManager.getKeyId() }) else {
            throw SudoTelephonyClientError.internalError
        }

        self.init(
            id: sealed.id,
            owner: sealed.owner,
            sudoOwner: sealed.sudoOwner,
            phoneNumberId: sealed.phoneNumberId,
            callRecordId: sealed.callRecordId,
            created: Date(timeIntervalSince1970: sealed.createdAtEpochMs / 1000),
            updated: Date(timeIntervalSince1970: sealed.updatedAtEpochMs / 1000),
            localPhoneNumber: try keyManager.decrypt(sealedData.localPhoneNumber),
            remotePhoneNumber: try keyManager.decrypt(sealedData.remotePhoneNumber),
            durationSeconds: UInt(try keyManager.decrypt(sealedData.durationSeconds)),
            media: MediaObject(media: sealedData.media.fragments.s3MediaObject)
        )
    }
}
