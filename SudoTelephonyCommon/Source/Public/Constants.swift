//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Values apps need when working with the telephony SDK.
public enum Constants {

    /// The keychain namespace the SDK stores its keys under unless overridden by caller. A consistent namespace is required for interoperation
    /// of import/export files across platforms.
    public static let defaultKeyNamespace = "sudo-telephony"

    /// The audience to request a Sudo ownership proof with, e.g. from SudoProfiles' `getOwnershipProof(sudoId:audience:)`,
    /// before provisioning a phone number for that Sudo.
    public static let ownershipProofAudience = "sudoplatform.telephony.phone-number"

    /// The issuer of an `Owner` that is a Sudo. Its `id` is the Sudo's ID.
    public static let sudoOwnerIssuer = "sudoplatform.sudoservice"

    /// The name the telephony service sends push notifications under. It is also the name of the
    /// service's section in `sudoplatformconfig.json`, which must set `"notifiable": true`.
    public static let serviceName = "telephonyService"
}
