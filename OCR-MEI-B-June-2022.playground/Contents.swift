import Foundation

printQuestion("3b", newLine: false)
private func f(x: Radians) -> Vector2d {
    Vector2d(
        x: x,
        y: 3 * sin(x) * cos(x)
    )
}
print("Point 1", number: f(x: -.pi / 2))
print("Point 2", number: f(x: .pi / 2))
print("Point 3", number: f(x: atan(1 / 3)))
print("Point 4", number: f(x: atan(1 / 3) - .pi))

printQuestion("5b")
let tension = 3 * g / cos(radians(25))
print("Tension", value: tension, unit: "N")
let force = tension * sin(radians(25))
print("Force", value: force, unit: "N")

printQuestion("6b")
let nBricks = (150 / g - 5) / 2.3
print("NBricks", value: nBricks)
let maxBricks = Int(nBricks)
print("Max NBricks", number: maxBricks)

printQuestion("6d")
let torqueDistance = (0.8 * 75 - 5 * 0.4 * g) / (2.3 * Double(maxBricks) * g)
print("TorqueDistance", value: torqueDistance, unit: "m")

printQuestion("7b")
QuadraticFormula(a: -g / 2, b: 7, c: 5).printSolutions()
let t = QuadraticFormula(a: -g / 2, b: 7, c: 5).maxReal()!
let distance = 14 * t
print("Distance", value: distance, unit: "m")

printQuestion("8c")
QuadraticFormula(a: 3, b: 2, c: -8).printSolutions()

printQuestion("13a")
let forward = 5 - (2 * 0.8)
let acceleration = forward / (0.5 + 0.4)
let velocity = 1.5 * acceleration
print("Velocity", value: velocity, unit: "m/s")

printQuestion("13d")
let numerator = 10 - 5.5 - 0.9 * g * sin(radians(20))
let resistance = numerator / 2
print("Resistance", value: resistance, unit: "N")

printQuestion("14a")
let k = -log(27.0 / 82) / 5
print("k", value: k)

printQuestion("14c")
let a = log(82.0)
print("a", value: a)
print("b", value: k)

printQuestion("14d")
let θ = exp(3.4)
print("θ", value: θ, unit: "°C")
let rate = θ * -0.08
print("Rate", value: rate, unit: "°C / min")

printQuestion("14e")
let time = log(θ / 82) / (0.08 - k)
print("Time", value: time, unit: "min")
let temperature1 = 82 * exp(-k * time)
let temperature2 = θ * exp(-0.08 * time)
assert(doubleEqual(temperature1, temperature2))
print("Temperature", value: temperature1, unit: "°C")
