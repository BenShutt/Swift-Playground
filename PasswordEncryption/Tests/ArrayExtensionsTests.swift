//
//  ArrayExtensionsTests.swift
//  PasswordEncryptionTests
//
//  Created by Ben Shutt on 17/10/2020.
//

@testable import PasswordEncryption
import XCTest

class ArrayExtensionsTests: XCTestCase {
    func test_splitInHalf() throws {
        assertSplitInHalfEqual(
            test: [Int](), expected: ([], [])
        )
        assertSplitInHalfEqual(
            test: [1], expected: ([], [1])
        )
        assertSplitInHalfEqual(
            test: [1, 2], expected: ([1], [2])
        )
        assertSplitInHalfEqual(
            test: [1, 2, 3], expected: ([1], [2, 3])
        )
        assertSplitInHalfEqual(
            test: [1, 2, 3, 4], expected: ([1, 2], [3, 4])
        )
        assertSplitInHalfEqual(
            test: [912, 4917, 143, 4871, 1408, 91_820],
            expected: ([912, 4917, 143], [4871, 1408, 91_820])
        )
        assertSplitInHalfEqual(
            test: [284_179, 120_486, 731, 83_230, 73_281, 10, 8_203_917_864],
            expected: (
                [284_179, 120_486, 731],
                [83_230, 73_281, 10, 8_203_917_864]
            )
        )
    }

    /// - Note:
    /// Required until `Tuple` can conform to `Equatable` when it's type does.
    /// I believe this work has been approved.
    private func assertSplitInHalfEqual<Element>(
        test: [Element],
        expected: (front: [Element], back: [Element])
    ) where Element: Equatable {
        let components = test.splitInHalf
        XCTAssertEqual(components.x, expected.front)
        XCTAssertEqual(components.y, expected.back)
    }
}
