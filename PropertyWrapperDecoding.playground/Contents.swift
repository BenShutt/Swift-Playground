import Foundation

// MARK: - Trimmable

public protocol Trimmable {
    init(untrimmed: Self)
}

// MARK: - String + Trimmable

extension String: Trimmable {
    public init(untrimmed: Self) {
        self = untrimmed.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - String? + Trimmable

extension Optional: Trimmable where Wrapped: Trimmable {
    public init(untrimmed: Self) {
        if let untrimmed {
            self = .some(.init(untrimmed: untrimmed))
        } else {
            self = .none
        }
    }
}

// MARK: - Trimmed

@propertyWrapper
struct Trimmed<Value: Trimmable & Decodable>: Decodable {
    let wrappedValue: Value

    init(wrappedValue: Value) {
        self.wrappedValue = .init(untrimmed: wrappedValue)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(wrappedValue: container.decode(Value.self))
    }
}

// MARK: - KeyedDecodingContainer + Extensions

// https://forums.swift.org/t/using-property-wrappers-with-codable/29804/12
extension KeyedDecodingContainer {
    func decode<T: Trimmable>(
        _ type: Trimmed<T?>.Type,
        forKey key: Self.Key
    ) throws -> Trimmed<T?> {
        try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: nil)
    }
}

// MARK: - Model

struct Model: Decodable {
    @Trimmed var key: String?
}

// MARK: - TestError

enum TestError: Error {
    case valueForKey
}

// MARK: - Helper

func test(json: String, expected: String?) throws {
    let jsonData = Data(json.utf8)
    let model = try JSONDecoder().decode(Model.self, from: jsonData)
    guard model.key == expected else {
        throw TestError.valueForKey
    }
}

// MARK: - Main

try test(json: "{\"key\":\"X\"}", expected: "X")
try test(json: "{\"key\":\" X \"}", expected: "X")
try test(json: "{\"key\":null}", expected: nil)
try test(json: "{}", expected: nil)

print("Success")
