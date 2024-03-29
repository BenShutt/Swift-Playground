import Foundation

public let g = 9.80665 // m/s²

public func radians(_ degrees: Double) -> Double {
    degrees / 180 * Double.pi
}

public func format(
    _ value: Double,
    plusSign: Bool = false
) -> String {
    Formatter(plusSign: plusSign).format(value)
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
