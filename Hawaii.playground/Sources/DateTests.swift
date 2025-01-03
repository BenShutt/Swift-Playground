import Foundation

public struct DateTests {
  private let formatter = {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = .gmt
    return formatter
  }()

  private let calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_GB")
    calendar.timeZone = .gmt
    return calendar
  }()

  public init() {}

  private func parseISO8601(from dateString: String) throws -> Date {
    guard let date = formatter.date(from: dateString) else {
      throw DateTestsError.parseISO8601
    }
    return date
  }

  private func addSeconds(_ value: Int, to date: Date) throws -> Date {
    let date = calendar.date(
      byAdding: .second,
      value: value,
      to: date
    )
    guard let date else {
      throw DateTestsError.calendar
    }
    return date
  }

  private func iso8601TimeZone(
    dateString: String,
    expectedISO8601: String
  ) throws {
    let date = try parseISO8601(from: dateString)
    let iso8601 = formatter.string(from: date)
    guard iso8601 == expectedISO8601 else {
      throw DateTestsError.iso8601Equality(iso8601, expectedISO8601)
    }
  }

  func testTimeZonePlusFive() throws {
    try iso8601TimeZone(
      dateString: "2024-11-27T10:00:00+05:00",
      expectedISO8601: "2024-11-27T05:00:00Z"
    )
    print("\(#function) success")
  }

  func testTimeZoneMinusFive() throws {
    try iso8601TimeZone(
      dateString: "2024-11-27T10:00:00-05:00",
      expectedISO8601: "2024-11-27T15:00:00Z"
    )
    print("\(#function) success")
  }

  /// Clocks go back
  /// - From: Sunday 26 October 2025 2AM BST
  /// - To: Sunday 26 October 2025 1AM GMT
  /// Although it is only in how we _represent_ the time.
  func testDST() throws {
    let secondBeforeDateStringBST = "2025-10-26T01:59:59+01:00"
    let dateStringBST = "2025-10-26T02:00:00+01:00"
    let dateStringGMT = "2025-10-26T01:00:00Z"

    let secondBeforeDate = try parseISO8601(from: secondBeforeDateStringBST)
    let date = try addSeconds(1, to: secondBeforeDate)

    let gmtFormatter = formatter
    let gmtActual = gmtFormatter.string(from: date)
    guard gmtActual == dateStringGMT else {
      throw DateTestsError.iso8601Equality(gmtActual, dateStringGMT)
    }

    let bstFormatter = formatter
    bstFormatter.timeZone = TimeZone(secondsFromGMT: 3600)
    let bstActual = bstFormatter.string(from: date)
    guard bstActual == dateStringBST else {
      throw DateTestsError.iso8601Equality(bstActual, dateStringBST)
    }

    let gmtTimeInterval = try parseISO8601(from: dateStringGMT)
      .timeIntervalSince(secondBeforeDate)
    guard gmtTimeInterval == 1 else {
      throw DateTestsError.timeInterval(gmtTimeInterval)
    }

    let bstTimeInterval = try parseISO8601(from: dateStringBST)
      .timeIntervalSince(secondBeforeDate)
    guard bstTimeInterval == 1 else {
      throw DateTestsError.timeInterval(bstTimeInterval)
    }

    print("\(#function) success")
  }

  public func test() {
    do {
      try DateTests().testTimeZonePlusFive()
      try DateTests().testTimeZoneMinusFive()
      try DateTests().testDST()

    } catch {
      print("Error: \(error)")
    }
  }
}

// MARK: - DateTestsError

enum DateTestsError: Error {
  case parseISO8601
  case calendar
  case iso8601Equality(_ actual: String, _ expected: String)
  case timeInterval(TimeInterval)
}
