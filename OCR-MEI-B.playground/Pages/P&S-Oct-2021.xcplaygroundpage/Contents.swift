import Foundation
printExam("P&S-Oct-2021")

printQuestion("2b")
let deg = degrees(0.211)
print("Degrees", value: deg)

printQuestion("5a")
var n = 32
var p = 0.4
let pEqual12 = binomial(n: n, r: 12, p: p)
print("P(X = 12)", value: pEqual12)

printQuestion("5b")
let pAtLeast8 = 1 - binomialSum(n: n, r: 7, p: p)
print("P(X ≥ 8)", value: pAtLeast8)

printQuestion("6a")
let dx = 7.0
let dy = 24.0
let magnitude = sqrt(dx * dx + dy * dy)
print("Magnitude", value: magnitude)

printQuestion("6b")
let angle = atan(dy / dx)
print("Angle (radians)", value: angle)
print("Angle (degrees)", value: degrees(angle))

printQuestion("8")
let meanX = 42.0
let varianceX = 6.8
let meanY = 57.2
let varianceY = 11.492
let b = sqrt(varianceY / varianceX)
print("b", value: b)
let a = meanY - b * meanX
print("a", value: a)

printQuestion("9a")
var numerator = 5.0 * 4 * 4 * 3
var denominator = 9.0 * 8 * 7 * 6
let exactly3Females = 4 * numerator / denominator
print("Exactly 3 Females", value: exactly3Females)

printQuestion("9b")
numerator = 4.0 * 3 * 2 * 5
let exactly3Black = 4 * numerator / denominator
numerator = 4.0 * 3 * 2 * 1
let allBlack = 4 * 3 * 2 * 1 / denominator
let atLeast3Black = exactly3Black + allBlack
print("At Least 3 Black", value: atLeast3Black)

printQuestion("9c")
// 3BF + 1M
numerator = 4.0 * 3 * 2 * 1
let case1 = 4 * numerator / denominator
// 1BM + 2BF + 1NBF
numerator = 3.0 * 2 * 2 * 1
let case2 = 12 * numerator / denominator
print("P(3F|≥3B)", value: (case1 + case2) / atLeast3Black)

printQuestion("11c")
let z = (161.9 - 161.6) / (1.96 / sqrt(200))
let xBar = 1.645 * sqrt(1.96 / 200) + 161.6
print("xBar", value: xBar)

printQuestion("12f")
let waist = 2.16 * 24.9 + 33
print("Waist", value: waist)

printQuestion("13a")
let count = 100.0
numerator = 35.0 + 56 + 39 + 20
let mean  = numerator / count
print("Mean", value: mean)

var sumX2 = 35 * 1 * 1
sumX2 += 28 * 2 * 2
sumX2 += 13 * 3 * 3
sumX2 += 5 * 4 * 4
let prefix = 1 / (count - 1)
let variance = prefix * (Double(sumX2) - count * mean * mean)
print("Standard Deviation", value: sqrt(variance))

printQuestion("13c")
n = 10
p = 0.15
let zero = binomial(n: n, r: 0, p: p) * count
print("p(X = 0)", value: zero)
let one = binomial(n: n, r: 1, p: p) * count
print("p(X = 1)", value: one)
let two = binomial(n: n, r: 2, p: p) * count
print("p(X = 2)", value: two)
let three = binomial(n: n, r: 3, p: p) * count
print("p(X = 3)", value: three)
let four = binomial(n: n, r: 4, p: p) * count
print("p(X = 4)", value: four)
var five = binomialSum(n: n, r: 10, p: p)
five -= binomialSum(n: n, r: 4, p: p)
print("p(X ≥ 5)", value: five * count)

printQuestion("15a")
let sum = (1...312).reduce(0) { sum, r in
    sum + pow(0.99, Double(r) - 1) * 0.01
}
print("p(X = r)", value: sum)
