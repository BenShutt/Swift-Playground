import Foundation

/// Example of making a thread safe class using GCD
final class ThreadSafe<Stored: Sendable>: @unchecked Sendable {

    /// Concurrent dispatch queue
    private let queue = DispatchQueue(
        label: "\(ThreadSafe.self)",
        attributes: .concurrent
    )

    /// A property that is thread safe and accessed only on the queue
    private var storedValue: Stored
    
    /// Memberwise initializer
    /// - Parameter storedValue: The vlaue to store
    init(storing storedValue: Stored) {
        self.storedValue = storedValue
    }

    /// Get and set the stored value in a thread safe manner
    var value: Stored {
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

// Check initiailizer
let first = UUID()
let lock = ThreadSafe<UUID>(storing: first)
assert(lock.value == first)

// Check set
let second = UUID()
lock.value = second
assert(lock.value == second)

// Check regular writes
let group = DispatchGroup()
(1...100).forEach { _ in
    group.enter()
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: .random(in: 1...3))
        lock.value = UUID()
        group.leave()
    }
}

group.wait()
print("Success")
