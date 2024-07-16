//
//  Data+Byte.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 17/10/2020.
//

import Foundation

// MARK: - Data + Byte

extension Data {

    /// `Data` to `Array` of `Byte`s
    var bytes: [Byte] {
        [Byte](self)
    }
}

// MARK: - Byte + Data

extension Array where Element == Byte {

    /// `Array` of `Byte`s to `Data`
    var data: Data {
        Data(self)
    }
}
