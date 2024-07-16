//
//  Array+Extensions.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 17/10/2020.
//

import Foundation

extension Array {

    /// Split an `Array` instance in half.
    /// If `count` is odd, then the additional `Element` will be added to the `y`
    /// component of the returned `Vector2<[Element]>`
    var splitInHalf: Vector2<[Element]> {
        let index = count / 2
        return Vector2(
            x: Array(self[startIndex ..< index]),
            y: Array(self[index ..< endIndex])
        )
    }
}
