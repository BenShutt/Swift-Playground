import Foundation

public enum Number: ExpressibleByFloatLiteral, CustomStringConvertible {
    case real(Double)
    case complex(real: Double, imaginary: Double)

    public init(floatLiteral value: FloatLiteralType) {
        self = .real(value)
    }

    public var description: String {
        switch self {
        case let .real(value):
            format(value)
        case let .complex(real, imaginary):
            format(real) + format(imaginary, plusSign: true) + "i"
        }
    }
}
