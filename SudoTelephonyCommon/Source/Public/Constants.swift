//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Values apps need when working with the telephony SDK.
public enum Constants {

    /// The keychain namespace the SDK stores its keys under unless the app chooses another.
    public static let defaultKeyNamespace = "sudo-telephony"

    /// The audience to request a Sudo ownership proof with, e.g. from SudoProfiles' `getOwnershipProof(sudoId:audience:)`,
    /// before provisioning a phone number for that Sudo.
    public static let ownershipProofAudience = "sudoplatform.telephony.phone-number"

    /// The issuer of an `Owner` that is a Sudo. Its `id` is the Sudo's ID.
    public static let sudoOwnerIssuer = "sudoplatform.sudoservice"
}
