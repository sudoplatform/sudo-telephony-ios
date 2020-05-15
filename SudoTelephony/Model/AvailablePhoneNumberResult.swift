//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

// Object that represents the list of available numbers from a search along with the search criteria.
public struct AvailablePhoneNumberResult {

    /// Phone number search states.
    internal enum State {
      internal typealias RawValue = String
      case searching
      case complete
      case failed
      case unknown(RawValue)

      internal init(rawValue: RawValue) {
        switch rawValue {
          case "SEARCHING": self = .searching
          case "COMPLETE": self = .complete
          case "FAILED": self = .failed
          default: self = .unknown(rawValue)
        }
      }

      internal var rawValue: RawValue {
        switch self {
          case .searching: return "SEARCHING"
          case .complete: return "COMPLETE"
          case .failed: return "FAILED"
          case .unknown(let value): return value
        }
      }
    }

    // ID of the search performed. For internal use only.
    let id: String
    // List of numbers avaiable.
    public let numbers: [String]
    // Coutry code used for searching for available phone numbers.
    public let countryCode: String
    // Prefix or Area Code used to search for available phone numbers.
    public let prefix: String?
    let state: State

    init(data: AvailablePhoneNumbersFinishedSubscription.Data.OnSearch) {
        id = data.id
        numbers = data.results ?? []
        countryCode = data.country
        prefix = data.prefix
        state = State(rawValue: data.state.rawValue)
    }
    
    init(id: String, numbers: [String], countryCode: String, prefix: String? = nil, state: PhoneNumberSearchState) {
        self.id = id
        self.numbers = numbers
        self.countryCode = countryCode
        self.prefix = prefix
        self.state = State(rawValue: state.rawValue)
    }
}
