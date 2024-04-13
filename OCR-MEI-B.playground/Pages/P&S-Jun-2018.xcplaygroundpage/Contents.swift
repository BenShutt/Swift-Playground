import Foundation
printExam("P&S-Jun-2018")

printQuestion("4i")
let households = [8.0, 22, 31, 27, 7]
let nHouseholds = households.reduce(0, +)
let nCars = households.enumerated().reduce(0) { sum, item in
    sum + Double(item.offset) * item.element
}
let mean = nCars / nHouseholds
print("Mean", value: mean)

printQuestion("4ii")
let sumX2 = households.enumerated().reduce(0) { sum, item in
    let x = Double(item.offset * item.offset)
    return sum + x * item.element
}
let variance = 1 / (nHouseholds - 1) * (sumX2 - nHouseholds * mean * mean)
print("Standard Deviation", value: sqrt(variance))

printQuestion("6i")
let R = sqrt(7 * 7 + 24 * 24)
print("R", value: R)
let θ = atan(24.0 / 7)
print("θ", value: θ)

printQuestion("8i")
let n = 20
let p = 0.7
let exactlyFourteenWins = binomial(n: n, r: 14, p: p)
print("P(X = 14)", value: exactlyFourteenWins)

let lessThanFourteenWins = binomialSum(n: n, r: 13, p: p)
print("P(X ≥ 14)", value: 1 - lessThanFourteenWins)

printQuestion("8iv")
let lowerQuartile = 61.0
let upperQuartile = 88.0
let lowerTail = lowerQuartile - 1.5 * (upperQuartile - lowerQuartile)
print("Lower tail", value: lowerTail)
