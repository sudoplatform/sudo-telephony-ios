//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// A page of results from a list operation.
public struct ListOutput<T> {

    /// The items on this page.
    public let items: [T]

    /// An opaque token to fetch the next page, or `nil` when there are no more.
    public let nextToken: String?

    /// Create a page of results.
    public init(items: [T], nextToken: String? = nil) {
        self.items = items
        self.nextToken = nextToken
    }
}

extension ListOutput: Equatable where T: Equatable {}
extension ListOutput: Sendable where T: Sendable {}

/// An item that could only be partly read, for example a message whose content couldn't be unsealed, with the reason.
public struct PartialResult<P> {

    /// What could be read of the item.
    public let partial: P

    /// Why the rest couldn't be read.
    public let error: any Error & Sendable

    /// Create a partial result.
    public init(partial: P, error: any Error & Sendable) {
        self.partial = partial
        self.error = error
    }
}

/// A page from a list operation whose items are unsealed on the device. If every item could be read, the result is `success`;
/// if some couldn't, it's `partial`, so one unreadable item doesn't stop the rest of the page from being returned.
public enum ListAPIResult<T, P> {

    /// A page where every item was read.
    public struct ListSuccessResult {

        /// The items on this page.
        public let items: [T]

        /// An opaque token to fetch the next page, or `nil` when there are no more.
        public let nextToken: String?

        /// Create a successful page.
        public init(items: [T], nextToken: String? = nil) {
            self.items = items
            self.nextToken = nextToken
        }
    }

    /// A page where some items could only be partly read.
    public struct ListPartialResult {

        /// The items that were read in full.
        public let items: [T]

        /// The items that could only be partly read, with the reason for each.
        public let failed: [PartialResult<P>]

        /// An opaque token to fetch the next page, or `nil` when there are no more.
        public let nextToken: String?

        /// Create a partial page.
        public init(items: [T], failed: [PartialResult<P>], nextToken: String?) {
            self.items = items
            self.failed = failed
            self.nextToken = nextToken
        }
    }

    /// Every item on the page was read.
    case success(ListSuccessResult)

    /// Some items on the page could only be partly read.
    case partial(ListPartialResult)
}

extension PartialResult: Sendable where P: Sendable {}
extension ListAPIResult: Sendable where T: Sendable, P: Sendable {}
extension ListAPIResult.ListSuccessResult: Sendable where T: Sendable {}
extension ListAPIResult.ListPartialResult: Sendable where T: Sendable, P: Sendable {}
