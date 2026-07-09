//
//  State.swift
//  SwiftyMockyExample
//
//  Created by Ben Shutt on 03/01/2025.
//

// MARK: - Observer

// sourcery: AutoMockable
protocol Observer {
    func update(value: Int)
}

// MARK: - State

/// Storage of a state which publishes to observers.
///
/// Simply for example purposes.
final class State {
    var observers: [Observer] = []

    var value = 0 {
        didSet {
            observers.forEach {
                $0.update(value: value)
            }
        }
    }
}
