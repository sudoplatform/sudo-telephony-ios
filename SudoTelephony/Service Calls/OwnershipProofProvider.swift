//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoProfiles

protocol OwnershipProofProviding: AnyObject {
    /// Resolves the users ownership proof for the provided sudo id.
    func getWithSudo(id: String, completion: @escaping ClientCompletion<String>)
}

/// Wrapper around `SudoProfilesClient` to fetch ownership proof
class OwnershipProofProvider: OwnershipProofProviding {

    // MARK: - Properties

    /// Audience attribute for resolving data with profiles client.
    let telephonyAudience = "sudoplatform.telephony.phone-number"

    /// SudoProfiles instance used to fetch data.
    unowned var profilesClient: SudoProfilesClient

    /// Initialize an instance of `OwnershipProofProvider`.
    init(profilesClient: SudoProfilesClient) {
        self.profilesClient = profilesClient
    }

    // MARK: - OwnershipProofProviding

    func getWithSudo(id: String, completion: @escaping ClientCompletion<String>) {
        let sudo = Sudo(id: id)
        do {
            try profilesClient.getOwnershipProof(sudo: sudo, audience: telephonyAudience) { result in
                switch result {
                case let .success(jwt):
                    completion(.success(jwt))
                case let .failure(cause):
                    completion(.failure(cause))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
