// A recreation of SwiftUI's State and Binding
// Crosscheck: https://gist.github.com/AliSoftware/ecb5dfeaa7884fc0ce96178dfdd326f8

// MARK: - Binding

@propertyWrapper
struct Binding<Value> {
    let get: () -> Value
    let set: (Value) -> Void

    var wrappedValue: Value {
        get {
            get()
        }
        nonmutating set {
            set(newValue)
        }
    }
}

// MARK: - State

// In SwiftUI, State is a struct.
// This can be achieved by wrapping a, say, "Storage" class
// in a similar way to Binding. For now, opt for simplicity.
@propertyWrapper
class State<Value> {
    var wrappedValue: Value

    private var binding: Binding<Value> {
        .init(get: {
            self.wrappedValue
        }, set: {
            self.wrappedValue = $0
        })
    }

    // For the $ operator
    var projectedValue: Binding<Value> { binding }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: - Value

enum Value {
    case initial // State will start with this value
    case updated // Binding will change to this value
}

// MARK: - Parent

struct Parent {
    @State private var value: Value = .initial

    func update() {
        let child = Child(value: $value)
        child.update()
        guard case .updated = value else { fatalError() }
        print("Value is \(value)")
    }
}

// MARK: - Child

struct Child {
    @Binding var value: Value

    func update() {
        value = .updated
    }
}

// MARK: - Main

let parent = Parent()
parent.update()
