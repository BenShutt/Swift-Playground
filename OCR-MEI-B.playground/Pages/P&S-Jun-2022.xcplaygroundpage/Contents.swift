import Foundation
printExam("P&S-Jun-2022")

printQuestion("X")
let xSum: Double = 23_042
let x2Sum: Double = 2_591_716
let n: Double = 205
let mean: Double = xSum / n
print("Mean", value: mean)
let variance = 1 / (n - 1) * (x2Sum - n * mean * mean)
print("Variance", value: variance)
