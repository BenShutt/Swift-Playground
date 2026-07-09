import Foundation

// MARK: - Trimmable

protocol Trimmable {
    func trim() -> Self
}

// MARK: - String + Trimmable

extension String: Trimmable {
    func trim() -> Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - String? + Trimmable

extension Optional: Trimmable where Wrapped: Trimmable {
    func trim() -> Self {
        switch self {
        case let .some(wrapped): wrapped.trim()
        case .none: nil
        }
    }
}

// MARK: - Trimmed

@propertyWrapper
struct Trimmed<Value: Trimmable & Decodable>: Decodable {
    let wrappedValue: Value

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue.trim()
    }

    init(from decoder: any Decoder) throws {
        let value = try Value(from: decoder)
        self.init(wrappedValue: value)
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
