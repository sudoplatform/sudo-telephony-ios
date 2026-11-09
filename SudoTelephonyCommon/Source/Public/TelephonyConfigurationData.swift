//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// How the telephony service is configured, so an app can follow its rules without hard-coding them.
public struct TelephonyConfigurationData: Equatable, Sendable {

    /// Whether provisioning a phone number requires a Sudo ownership proof. When `false`, a number provisioned without a proof
    /// belongs to the user only.
    public let sudoOwnershipProofRequired: Bool

    /// The number of results a phone number search returns when it sets no limit.
    public let phoneNumberSearchDefaultLimit: Int

    /// The largest limit a phone number search accepts. A larger limit is rejected with `SudoTelephonyError.limitExceeded`.
    public let phoneNumberSearchMaxLimit: Int

    /// How long after a search its results can be provisioned, in seconds.
    public let phoneNumberSearchLifetime: TimeInterval

    /// The page size of the list operations when they set no limit.
    public let listDefaultLimit: Int

    /// The largest page the list operations return. A larger limit returns this many items at most.
    public let listMaxLimit: Int

    /// The most message IDs one `deletePhoneMessages(withInput:)` call may name.
    public let deletePhoneMessagesLimit: Int

    /// The most message IDs one `updatePhoneMessages(withInput:)` call may name.
    public let updatePhoneMessagesLimit: Int

    /// Create configuration data.
    public init(
        sudoOwnershipProofRequired: Bool,
        phoneNumberSearchDefaultLimit: Int,
        phoneNumberSearchMaxLimit: Int,
        phoneNumberSearchLifetime: TimeInterval,
        listDefaultLimit: Int,
        listMaxLimit: Int,
        deletePhoneMessagesLimit: Int,
        updatePhoneMessagesLimit: Int
    ) {
        self.sudoOwnershipProofRequired = sudoOwnershipProofRequired
        self.phoneNumberSearchDefaultLimit = phoneNumberSearchDefaultLimit
        self.phoneNumberSearchMaxLimit = phoneNumberSearchMaxLimit
        self.phoneNumberSearchLifetime = phoneNumberSearchLifetime
        self.listDefaultLimit = listDefaultLimit
        self.listMaxLimit = listMaxLimit
        self.deletePhoneMessagesLimit = deletePhoneMessagesLimit
        self.updatePhoneMessagesLimit = updatePhoneMessagesLimit
    }
}
