import Foundation

// MARK: - Constants

let numbers = Array(0..<100_000)
let numberOfTests = 10_000
let numberOfTestsF = TimeInterval(numberOfTests)

// MARK: - Algorithms

func forDouble(_ numbers: [Int]) -> [Int] {
    var doubles = [Int]()
    for number in numbers {
        doubles.append(number * 2)
    }
    return doubles
}

func forEnumeratedDouble(_ numbers: [Int]) -> [Int] {
    var doubles = [Int](repeating: 0, count: numbers.count)
    for (i, number) in numbers.enumerated() {
        doubles[i] = number * 2
    }
    return doubles
}

func mapDouble(_ numbers: [Int]) -> [Int] {
    numbers.map { $0 * 2 }
}

// MARK: - Helper

func test(
    operation: ([Int]) -> [Int],
    name: String
) {
    var average: Duration = .zero
    (0..<numberOfTests).forEach { _ in
        let time = ContinuousClock().measure { _ = operation(numbers) }
        average += time / numberOfTestsF
    }
    print("\(name) \(average.formattedMicroSeconds)")
}

extension ContinuousClock.Duration {
    var formattedMicroSeconds: String {
        formatted(.units(
            allowed: [.microseconds],
            maximumUnitCount: 1
        ))
    }
}

// MARK: - Main

try await Task.sleep(for: .seconds(1))
test(operation: forDouble, name: "forDouble")
test(operation: forEnumeratedDouble, name: "forEnumeratedDouble")
test(operation: mapDouble, name: "mapDouble")
