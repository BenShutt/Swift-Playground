import Foundation
printExam("P&S-Oct-2021")

printQuestion("2b")
let deg = degrees(0.211)
print("Degrees", value: deg)

printQuestion("5a")
let n = 32
let p = 0.4
let pEqual12 = binomial(n: n, r: 12, p: p)
print("Probability X = 12", value: pEqual12)

printQuestion("5b")
let pAtLeast8 = 1 - binomialSum(n: n, r: 7, p: p)
print("Probability X ≥ 8", value: pAtLeast8)

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
let denominator = 9.0 * 8 * 7 * 6
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
