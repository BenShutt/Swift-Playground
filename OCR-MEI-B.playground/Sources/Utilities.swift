import Foundation

// MARK: - Constants

public let π: Double = .pi
public let g = 9.80665 // m/s²

// MARK: - Angles

public typealias Degrees = Double
public typealias Radians = Double

public func radians(_ degrees: Degrees) -> Radians {
    degrees * π / 180
}

public func degrees(_ radians: Radians) -> Degrees {
    radians * 180 / π
}

// MARK: - Statistics

/// `C(n, r)` combination function. AKA `n` choose `r`.
/// - Parameters:
///   - n: (Natural) number of elements or 0
///   - r: (Natural) number of combinations or 0
/// - Returns: Function value, returns a `Double` due to `Int` overflow
public func combination(n: Int, r: Int) -> Double {
    precondition(n >= r)
    let numerator = factorial(n: n)
    let denominator = factorial(n: n - r) * factorial(n: r)
    return numerator / denominator
}

/// Factional function.
/// `n! = n * (n - 1) * ... * 2 * 1`
/// - Parameter n: (Natural) number or 0
/// - Returns: Function value, returns a `Double` due to max `Int` size
public func factorial(n: Int) -> Double {
    precondition(n >= 0)
    guard n > 0 else { return 1 }
    return (1...n).map(Double.init).reduce(1, *)
}

/// The binomial distribution function
/// `p(X = r) = C(n, r) * p^r * p^(n - r)`
/// - Parameters:
///   - n: (Natural) number of trials or 0
///   - r: (Natural) number of successful trials or 0
///   - p: Probability of success of a single trial
/// - Returns: The binomial distribution function value
public func binomial(n: Int, r: Int, p: Double) -> Double {
    precondition((0...1).contains(p))
    let combination = combination(n: n, r: r) // Check preconditions
    let powerP = pow(p, Double(r))
    let powerQ = pow(1 - p, Double(n - r))
    return combination * powerP * powerQ
}

/// Sum the binomial distribution functions from `1` to `r`
/// `p(X ≤ r) = ∑p(X = i)` where `1 ≤ i ≤ r`
/// - Parameters:
///   - n: (Natural) number of trials or 0
///   - r: (Natural) number of successful trials or 0
///   - p: Probability of success of a single trial
/// - Returns: The sum of the binomial distribution function values
public func binomialSum(n: Int, r: Int, p: Double) -> Double {
    precondition(r >= 0)
    return (0...r).reduce(0) { sum, i in
        sum + binomial(n: n, r: i, p: p)
    }
}

// MARK: - Double

public func doubleEqual(_ a: Double, _ b: Double) -> Bool {
    fabs(a - b) < .ulpOfOne
}

// MARK: - Printing

public func format(
    _ value: Double,
    plusSign: Bool = false
) -> String {
    Formatter(plusSign: plusSign).format(value)
}

public func printExam(_ name: String) {
    print("========== EXAM - \(name.uppercased()) ==========")
}

public func printQuestion(_ name: String, newLine: Bool = true) {
    print("\(newLine ? "\n" : "")Q) \(name)")
}

public func print(
    _ name: String,
    value: Double,
    unit: String = ""
) {
    print(name, number: format(value), unit: unit)
}

public func print(
    _ name: String,
    number: CustomStringConvertible,
    unit: String = ""
) {
    print("\(name): \(number)\(unit)")
}
