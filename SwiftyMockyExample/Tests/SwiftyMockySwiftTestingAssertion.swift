//
//  SwiftyMockySwiftTestingAssertion.swift
//  SwiftyMockyExample
//
//  Created by Ben Shutt on 03/01/2025.
//

@preconcurrency import SwiftyMocky
import Testing

/// Update the `MockyAssertion` handler to use Swift Testing's `#expect` macro instead
/// of `XCTAssert` when XCTest can be imported
struct SwiftyMockySwiftTestingAssertion: SuiteTrait {
    func prepare(for test: Test) async throws {
        MockyAssertion.handler = { expression, message, _, line in
            #expect(
                expression,
                .init(rawValue: message),
                sourceLocation: .init(
                    fileID: test.sourceLocation.fileID,
                    filePath: test.sourceLocation._filePath,
                    line: Int(line),
                    column: 0
                )
            )
        }
    }
}

extension SuiteTrait where Self == SwiftyMockySwiftTestingAssertion {
    static var useSwiftyMockySwiftTestingAssertion: SwiftyMockySwiftTestingAssertion { .init() }
}
