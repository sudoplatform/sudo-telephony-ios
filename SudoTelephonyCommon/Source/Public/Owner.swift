//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Something that owns a resource, identified by an ID and the service that issued it.
///
/// A phone number provisioned with a Sudo ownership proof is owned by that Sudo: its
/// `owners` include an owner whose `issuer` is `"sudoplatform.sudoservice"` and whose
/// `id` is the Sudo's ID.
public struct Owner: Hashable, Sendable {

    /// ID of the owner, for example a Sudo ID.
    public let id: String

    /// The service that issued the owner's ID, for example `"sudoplatform.sudoservice"`.
    public let issuer: String

    /// Create an owner.
    public init(id: String, issuer: String) {
        self.id = id
        self.issuer = issuer
    }
}
