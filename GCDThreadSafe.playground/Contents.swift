import Foundation

/// Example of making a thread safe class using GCD
@propertyWrapper
final class Atomic<Stored: Sendable>: @unchecked Sendable {

    /// Concurrent dispatch queue
    private let queue = DispatchQueue(
        label: "\(Atomic.self)",
        attributes: .concurrent
    )

    /// A property that is thread safe and accessed only on the queue
    private var storedValue: Stored
    
    /// Memberwise initializer
    /// - Parameter wrappedValue: The value to store
    init(wrappedValue: Stored) {
        storedValue = wrappedValue
    }

    /// Get and set the stored value in a thread safe manner
    var wrappedValue: Stored {
        get {
            // Add operation to the queue.
            // Wait for the operation to finish.
            queue.sync {
                storedValue
            }
        }
        set {
            // Add operation to the queue.
            // Stop anything else running on the queue while this operation runs.
            // Do not wait for the operation to finish.
            queue.async(flags: .barrier) { [weak self] in
                self?.storedValue = newValue
            }
        }
    }
}

// Check initializer
let first = UUID()
let lock = Atomic<UUID>(wrappedValue: first)
assert(lock.wrappedValue == first)

// Check set
let second = UUID()
lock.wrappedValue = second
assert(lock.wrappedValue == second)

// Check regular writes
let group = DispatchGroup()
(1...100).forEach { _ in
    group.enter()
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: .random(in: 1...3))
        lock.wrappedValue = UUID()
        group.leave()
    }
}

group.wait()
print("Success")
