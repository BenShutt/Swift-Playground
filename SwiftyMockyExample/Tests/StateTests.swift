//
//  StateTests.swift
//  SwiftyMockyExample
//
//  Created by Ben Shutt on 03/01/2025.
//

import Testing
@testable import SwiftyMockyExample

@Suite("Unit tests of State", .useSwiftyMockySwiftTestingAssertion)
struct StateTests {
    @Test func test() {
        let observer = ObserverMock()

        let state = State()
        state.observers.append(observer)
        state.value = 1

        observer.verify(
            .update(value: .value(1)),
            count: .exactly(1)
        )
    }
}
