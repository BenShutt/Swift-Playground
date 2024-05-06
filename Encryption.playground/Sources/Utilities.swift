import Foundation

public func printElapsed(since startDate: Date) {
    let endDate = Date()
    let elapsedSeconds = endDate.timeIntervalSince(startDate)
    let formattedSeconds = String(format: "%.3f", elapsedSeconds)
    print("Elapsed time \(formattedSeconds)s")
}
