import Combine
import PlaygroundSupport

// MARK: - LazyTask

actor LazyTask<Output: Sendable> {
    private let operation: () async throws -> Output
    private var task: Task<Output, Error>?

    init(operation: @escaping () async throws -> Output) {
        self.operation = operation
    }

    func get() async throws -> Output {
        if let task {
            return try await task.value
        }

        let task = Task { try await operation() }
        self.task = task
        return try await task.value
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}

// MARK: - CustomerSetup

/// An expensive task that loads a customer
struct CustomerSetup {
    struct Customer {
        var customerId: String
    }

    func load() async throws -> Customer {
        try await Task.sleep(for: .seconds(3)) // Expensive task
        return Customer(customerId: "123")
    }
}

// MARK: - AnalyticsSetup

/// An expensive task that loads analytics which depend on the customer
@MainActor
struct AnalyticsSetup {
    var customer: LazyTask<CustomerSetup.Customer> {
        StartupManager.shared.customer
    }

    func load() async throws {
        let customer = try await customer.get() // Use customer
        try await Task.sleep(for: .seconds(3)) // Expensive task
    }
}

// MARK: - IgnoredSetup

/// This task will not be called upon in main so should be ignored
struct IgnoredSetup {
    func load() async throws {
        try await Task.sleep(for: .seconds(3)) // Expensive task
    }
}

// MARK: - ReportSetup

/// An expensive task that loads analytics which depend on the customer
@MainActor
struct ReportSetup {
    struct Report {
        var isComplete = false
    }

    var customer: LazyTask<CustomerSetup.Customer> {
        StartupManager.shared.customer
    }

    func load() async throws -> Report {
        let customer = try await customer.get() // Use customer
        try await Task.sleep(for: .seconds(3)) // Expensive task
        return Report(isComplete: true)
    }
}

// MARK: - Loadable

protocol Loadable {
    associatedtype Output
    func load() async throws -> Output
}

extension CustomerSetup: Loadable {}
extension AnalyticsSetup: Loadable {}
extension IgnoredSetup: Loadable {}
extension ReportSetup: Loadable {}

extension Loadable {
    func loadAndPrint() async throws -> Output {
        print("Begin loading \(Self.self)")
        defer { print("End loading \(Self.self)") }
        return try await load()
    }
}

extension LazyTask {
    init<T: Loadable>(_ loadable: T) where T.Output == Output {
        self.init(operation: loadable.loadAndPrint)
    }
}

// MARK: - StartupManager

@MainActor
struct StartupManager {
    static let shared = StartupManager()
    private init() {}

    let customer = LazyTask(CustomerSetup())
    let analytics = LazyTask(AnalyticsSetup())
    let ignored = LazyTask(IgnoredSetup())
    let report = LazyTask(ReportSetup())
}

// MARK: - TaskPublisher

struct TaskPublisher<Output: Sendable>: Publisher, Sendable {
    typealias Failure = Error
    typealias Operation = @Sendable () async throws -> Output

    private let operation: Operation

    public init(_ operation: @escaping Operation) {
        self.operation = operation
    }

    public func receive<S>(
        subscriber: S
    ) where S: Subscriber, S.Failure == Failure, S.Input == Output, S: Sendable {
        subscriber.receive(subscription: TaskSubscription(
            subscriber: subscriber,
            operation: operation
        ))
    }
}

// MARK: - TaskPublisher.TaskSubscription

extension TaskPublisher {

    /// A Subscription that runs an asynchronous operation when initialized
    final class TaskSubscription<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure, S: Sendable {
        private var subscriber: S?
        private var task: Task<Void, Error>?

        init(subscriber: S, operation: @escaping Operation) {
            self.subscriber = subscriber
            task = Task { @MainActor in
                do {
                    let output = try await operation()
                    try Task.checkCancellation()
                    _ = subscriber.receive(output) // Demand ignored
                    subscriber.receive(completion: .finished)
                } catch {
                    subscriber.receive(completion: .failure(error))
                }
            }
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            task?.cancel()
            task = nil
            subscriber = nil
        }
    }
}

// MARK: - LazyTask + Publisher

extension LazyTask {
    @MainActor
    var publisher: AnyPublisher<Output, Error> {
        TaskPublisher(get)
            .eraseToAnyPublisher()
    }
}

// MARK: - Combine Main

@MainActor
func observe<T>(
    task: LazyTask<T>,
    cancellables: inout Set<AnyCancellable>
) {
    task.publisher
        .sink(receiveCompletion: { completion in
            print("Completion \(completion)")
        }, receiveValue: { value in
            print("Value \(value)")
        })
        .store(in: &cancellables)
}

// MARK: - Main

// Setup Playground for concurrency
PlaygroundPage.current.needsIndefiniteExecution = true
defer {
    PlaygroundPage.current.finishExecution()
}

// Create Set of Combine cancellables
var cancellables = Set<AnyCancellable>()

// Add Combine observer which (also) triggers demand
print("Observing Report from Combine")
observe(
    task: StartupManager.shared.report,
    cancellables: &cancellables
)

// Load analytics, which will load customer before
try await StartupManager.shared.analytics.get()

// Report is already loaded, observe from Combine after
try await Task.sleep(for: .seconds(4))
print("Observing Report from Combine [2]")
observe(
    task: StartupManager.shared.report,
    cancellables: &cancellables
)

// Allow Combine completion to print
try await Task.sleep(for: .seconds(1))
