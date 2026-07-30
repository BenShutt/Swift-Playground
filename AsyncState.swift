actor AsyncState<Success: Sendable> {
    private enum State {
        case idle
        case loading(Task<Success, any Error>)
        case result(Result<Success, any Error>)
    }

    // Public facing state with in-flight task removed
    enum Value {
        case idle
        case loading
        case result(Result<Success, any Error>)
    }

    private var state: State = .idle
    var value: Value {
        switch state {
        case .idle: .idle
        case .loading: .loading
        case let .result(result): .result(result)
        }
    }

    // Be mindful that the Task which runs operation is stored.
    // (this) AsyncState -> Task -> operation.
    // So if operation strongly captures (this) AsyncState, that is a retain cycle.
    // The cycle is broken when the task finishes.
    func load(
        operation: @escaping () async throws -> Success,
    ) async {
        invalidate()
        let task = Task<Success, any Error> {
            let success = try await operation()
            try Task.checkCancellation()
            return success
        }
        state = .loading(task)
        let result = await withTaskCancellationHandler {
            await task.result
        } onCancel: {
            task.cancel()
        }
        guard isCurrentTask(task) else { return }
        state = .result(result)
    }

    func cancel() {
        invalidate()
        state = .idle
    }

    private func invalidate() {
        switch state {
        case .idle, .result:
            break
        case let .loading(task):
            task.cancel()
        }
    }

    private func isCurrentTask(_ task: Task<Success, any Error>) -> Bool {
        guard case .loading(let current) = state else { return false }
        return current == task
    }
}
