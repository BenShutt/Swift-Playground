import Foundation

public typealias Degrees = Double
public typealias Radians = Double

public let π: Double = .pi
public let g = 9.80665 // m/s²

public func radians(_ degrees: Degrees) -> Radians {
    degrees / 180 * π
}

public func format(
    _ value: Double,
    plusSign: Bool = false
) -> String {
    Formatter(plusSign: plusSign).format(value)
}

public func doubleEqual(_ a: Double, _ b: Double) -> Bool {
    fabs(a - b) < .ulpOfOne
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

public func printQuestion(_ name: String, newLine: Bool = true) {
    print("\(newLine ? "\n" : "")Q) \(name)")
}
