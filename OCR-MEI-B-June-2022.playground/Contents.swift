import Foundation

// 5b
let tension = 3 * g / cos(radians(25))
print("5b - Tension", value: tension, unit: "N")
let force = tension * sin(radians(25))
print("5b - Force", value: force, unit: "N")

// 6b
let nBricks = (150 / g - 5) / 2.3
print("6b - NBricks", value: nBricks)
print("6b - Max NBricks \(Int(nBricks))")

// 7b
let t = QuadraticFormula(a: -2 * g, b: 7, c: 5).maxReal()!
let distance = 14 * t
print("7b - Distance", value: distance, unit: "m")

// 13a
let forward = 5 - (2 * 0.8)
let acceleration = forward / (0.5 + 0.4)
let velocity = 1.5 * acceleration
print("13a - Velocity", value: velocity, unit: "m/s")

// 14a
let k = -log(27.0 / 82) / 5
print("14a - k", value: k)

// 14d
let θ = exp(3.4)
print("14d - θ", value: θ, unit: "°C")
let rate = θ * -0.08
print("14d - Rate", value: rate, unit: "°C / min")

// 14e
let time = log(θ / 82) / (0.08 - k)
print("14e - Time", value: time, unit: "min")
let temperature1 = 82 * exp(-k * time)
let temperature2 = θ * exp(-0.08 * time)
print("14e - temperature1", value: temperature1, unit: "°C")
print("14e - temperature2", value: temperature2, unit: "°C")
