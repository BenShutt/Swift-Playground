import Foundation

public struct QuadraticFormula {

    public var a: Double
    public var b: Double
    public var c: Double

    public init(a: Double, b: Double, c: Double) {
        assert(a != 0)
        self.a = a
        self.b = b
        self.c = c
    }

    private var discriminant: Double {
        b * b - 4 * a * c
    }

    private var first: Double {
        -b / (2 * a)
    }

    private func second(discriminant: Double) -> Double {
        sqrt(abs(discriminant)) / (2 * a)
    }

    private func make(sign: Double) -> Number {
        if discriminant > 0 {
            .real(first + second(discriminant: discriminant))
        } else {
            .complex(
                real: first,
                imaginary: sign * second(discriminant: discriminant)
            )
        }
    }

    public func solutions() -> [Number] {
        if doubleEqual(discriminant, 0) {
            [.real(first)]
        } else {
            [make(sign: 1), make(sign: -1)]
        }
    }

    public func printSolutions() {
        let solutions = solutions()
        solutions.enumerated().forEach { i, number in
            let prefix = solutions.count == 1 ? "Only Root" : "Root \(i + 1)"
            print(prefix, number: number)
        }
    }

    public func maxReal() -> Double? {
        solutions()
            .compactMap {
                guard case .real(let real) = $0 else { return nil }
                return real
            }
            .max()
    }
}

// MARK: - Double + Extensions

private func doubleEqual(_ a: Double, _ b: Double) -> Bool {
    return fabs(a - b) < Double.ulpOfOne
}
