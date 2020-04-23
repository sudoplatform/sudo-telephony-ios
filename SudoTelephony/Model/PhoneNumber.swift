//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

// Object that represents a phone number either provisioned, in the process of getting provisioned or that has been deleted.
public struct PhoneNumber {

    public enum State: Equatable {

        case complete
        case provisioning
        case deprovisioning
        case failed
        case unknown

        init(internalState: PhoneNumberState) {
            switch internalState {
            case .complete:
                self = .complete
            case .deprovisioning:
                self = .deprovisioning
            case .failed:
                self = .failed
            case .provisioning:
                self = .provisioning
            default:
                self = .unknown
            }
        }
    }

    // ID to uniquely identify the phone number
    public let id: String
    // E.164 formatted number. For more detail visit https://en.wikipedia.org/wiki/E.164
    public let phoneNumber: String
    // State of the phone number that represents the state of being provisioned by the service.
    public let state: State
    // Version of the phone number that represents how much has been updated for conflict resolution.
    public let version: Int
    // Created timestamp
    public let created: Date
    // Updated timestamp
    public let updated: Date
}


