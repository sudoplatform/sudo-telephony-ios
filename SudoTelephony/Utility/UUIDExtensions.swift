//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CommonCrypto

extension UUID {
    init(v5WithNameSpace nameSpace: String, name: String) {
        // Get UUID bytes from namespace
        let newUUID = UUID(uuidString: nameSpace)

        //TODO: remove this force unwrapped optional.
        let spaceUID = newUUID!.uuid
        var localVar = spaceUID
        var data = withUnsafePointer(to: &localVar) {
            Data(bytes: $0, count: MemoryLayout.size(ofValue: spaceUID))
        }

        // Append name string in UTF-8 encoding:
        data.append(contentsOf: name.utf8)

        // Compute digest
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            CC_SHA1(ptr.baseAddress, CC_LONG(data.count), &digest)
        }

        // Set version bits:
        digest[6] &= 0x0F
        digest[6] |= UInt8(5) << 4
        // Set variant bits:
        digest[8] &= 0x3F
        digest[8] |= 0x80

        // Create UUID from digest:
        self = NSUUID(uuidBytes: digest) as UUID
    }
}
