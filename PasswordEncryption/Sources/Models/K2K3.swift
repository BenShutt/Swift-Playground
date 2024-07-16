//
//  K2K3.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 17/10/2020.
//

import Foundation

/// k2 and k3 keys when using `PBKDF2`
struct K2K3: CustomStringConvertible {

    /// `Key` first component
    var k2: [Byte]

    /// `Key` second component
    var k3: [Byte]

    /// Initialize by splitting `key` in half, the first half assigned to `k2`, second half to `k3`
    ///
    /// - Parameter key: `Key`
    init(key: [Byte]) {
        let split = key.splitInHalf
        k2 = split.x
        k3 = split.y
    }

    // MARK: - CustomStringConvertible

    var description: String {
        return "{k2=\(k2), k3=\(k3)}"
    }
}
