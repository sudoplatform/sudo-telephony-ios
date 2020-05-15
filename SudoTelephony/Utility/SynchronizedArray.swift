//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Simple wrapper of an array that provides thread safe synchronized access.
class SynchronizedArray<Element> {

    private var elements: [Element]
    private let syncQueue = DispatchQueue(label: "com.sudotelephony.syncarray")

    init() {
        elements = [Element]()
    }

    var first: Element? {
        return syncQueue.sync { elements.first }
    }

    var last: Element? {
        return syncQueue.sync { elements.last }
    }

    var contents: [Element] {
        syncQueue.sync { return elements }
    }

    var count: Int {
        syncQueue.sync { return elements.count }
    }

    func append(_ newElement: Element) {
        elements.append(contentsOf: [])
        syncQueue.sync { elements.append(newElement) }
    }

    func append<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence {
        syncQueue.sync { elements.append(contentsOf: newElements) }
    }

    subscript(index: Int) -> Element {
        get {
            syncQueue.sync { elements[index] }
        }
        set {
            syncQueue.sync { elements[index] = newValue }
        }
    }
}
