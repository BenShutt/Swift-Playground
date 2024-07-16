//
//  AES+GCM.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 31/10/2020.
//

import CryptoSwift
import Foundation

extension AES {

    /// Use the given `key` and `iv` with :
    /// - `blockNode`: `GCM` with `iv` and `.combined` mode
    /// - `padding`: `.noPadding`
    ///
    /// - Parameters:
    ///   - key: `[Byte]`
    ///   - iv: `[Byte]`
    ///
    /// - Note:
    /// `GCM` instance is not intended to be reused.
    /// So you can't use the same GCM instance from encoding to also perform decoding.
    convenience init(key: [Byte], gcmIV: [Byte]) throws {
        try self.init(
            key: key,
            blockMode: GCM(iv: gcmIV, mode: .combined), // CBC alternative
            padding: .noPadding
        )
    }
}
