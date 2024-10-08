import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
defer {
    print("Finishing execution")
    PlaygroundPage.current.finishExecution()
}

// Check we are on the main queue
dispatchPrecondition(condition: .onQueue(.main))

// Define logic to count seconds off the main queue
struct Background {
    func sleep(seconds: Int = 10) async throws {
        dispatchPrecondition(condition: .notOnQueue(.main))
        for second in 1...seconds {
            try await Task.sleep(for: .seconds(1)) // Observes cancellations
            print(second)
        }
    }
}

// Start a task that counts seconds in the background
let task = Task {
    try await Background().sleep()
}

// Wait for 5 seconds
try await Task.sleep(for: .seconds(5))

// Cancel the task
task.cancel()
let result = await task.result
print(result)
assert(result.isFailure)

// Wait for 5 seconds
try await Task.sleep(for: .seconds(5))

// Complete
print("Success")

// MARK: - Result + Extensions

extension Result {
    var isFailure: Bool {
        if case .failure = self { true } else { false }
    }
}
