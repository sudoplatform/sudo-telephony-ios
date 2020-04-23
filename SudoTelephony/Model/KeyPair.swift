//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation


/// Represents an assymetric cryptographic key pair for using with each phone number.
public struct KeyPair {
    /// Public Key of the key pair.
    let publicKey: Data
    /// Private Key of the key pair.
    let privateKey: Data
}
