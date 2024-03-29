import Foundation

public struct Formatter {

    private let numberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .halfUp
        formatter.minimumIntegerDigits = 1
        return formatter
    }()

    public init(
        maximumFractionDigits: Int = 3,
        plusSign: Bool = false
    ) {
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        if plusSign {
            numberFormatter.positivePrefix = numberFormatter.plusSign
        }
    }

    public func format(_ value: Double) -> String {
        let string = numberFormatter.string(from: value as NSNumber)
        if let string { return string }
        let format = "%.\(numberFormatter.maximumFractionDigits)f"
        return String(format: format, value)
    }
}
