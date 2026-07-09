import Foundation

public struct Vector2d: CustomStringConvertible {
    var x: Double
    var y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public var description: String {
        "(\(format(x)), \(format(y)))"
    }
}
