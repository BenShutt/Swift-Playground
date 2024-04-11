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
