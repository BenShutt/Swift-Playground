import Foundation

// MARK: - TravelTimeZone

enum TravelTimeZone: String, CaseIterable {
  case bst
  case pdt
  case hst

  var abbreviation: String {
    rawValue.uppercased()
  }

  var utcOffset: Int {
    switch self {
    case .bst: 1
    case .pdt: -7
    case .hst: -10
    }
  }

  var name: String {
    switch self {
    case .bst: "British Summer Time"
    case .pdt: "Pacific Daylight Time"
    case .hst: "Hawaii–Aleutian Time"
    }
  }

  var timeZone: TimeZone! {
    TimeZone(abbreviation: abbreviation)
  }
}

enum Airport: String {
  case lhr
  case lax
  case ogg

  var code: String {
    rawValue.uppercased()
  }

  var name: String {
    switch self {
    case .lhr: "London Heathrow Airport"
    case .lax: "Los Angeles International Airport"
    case .ogg: "Maui Kahului Airport"
    }
  }
}

// MARK: - TravelType

enum TravelType: String {
  case departure
  case arrival

  var name: String {
    rawValue.capitalized
  }

  var prefix: String {
    switch self {
    case .departure: "Depart from"
    case .arrival: "Arrive at"
    }
  }
}

// MARK: - TravelPoint

struct TravelPoint {
  var airport: Airport
  var type: TravelType
  var date: Date

  init(airport: Airport, type: TravelType, date: String) {
    self.airport = airport
    self.type = type
    self.date = ISO8601DateFormatter().date(from: date)!
  }
}

// MARK: - Definitions

private func time(from fromDate: Date, to toDate: Date) -> String {
  let timeInterval = toDate.timeIntervalSince(fromDate)
  let date = Date(timeIntervalSince1970: timeInterval)

  let formatter = DateFormatter()
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  formatter.timeZone = .gmt
  formatter.dateFormat = "HH:mm"

  return formatter.string(from: date)
}

// MARK: - Main (2)

struct Trip {
  let mauiNights = 5
  let honoluluNights = 9
  let travelHours = 19

  var departLHR: Date
  var arriveOGG: Date
  var departMaui: Date
  var departOGG: Date
  var arriveLHR: Date

  var departLHRF: String {
    string(from: departLHR, zone: .bst)
  }

  var arriveOGGF: String {
    string(from: arriveOGG, zone: .hst)
  }

  var departMauiF: String {
    string(from: departMaui, zone: .hst)
  }

  var departOGGF: String {
    string(from: departOGG, zone: .hst)
  }

  var arriveLHRF: String {
    string(from: arriveLHR, zone: .bst)
  }

  init(departure: String) {
    departLHR = ISO8601DateFormatter().date(from: departure)!
    arriveOGG = Calendar.current.date(
      byAdding: .hour,
      value: travelHours,
      to: departLHR
    )!

    departMaui = Calendar.current.date(
      byAdding: .day,
      value: mauiNights,
      to: arriveOGG
    )!

    departOGG = Calendar.current.date(
      byAdding: .day,
      value: honoluluNights,
      to: departMaui
    )!

    arriveLHR = Calendar.current.date(
      byAdding: .hour,
      value: travelHours,
      to: departOGG
    )!
  }

  private func string(from date: Date, zone: TravelTimeZone) -> String {
    // let formatter = ISO8601DateFormatter()
    // formatter.timeZone = zone.timeZone

    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = zone.timeZone
    formatter.dateFormat = "dd MMM HH:mm"
    formatter.timeZone = zone.timeZone

    return formatter.string(from: date)
  }

  func printTrip() {
    print("\(departLHRF) - Depart LHR")
    print("\(arriveOGGF) - Arrive OGG")
    print("\(departMauiF) - Depart Maui after sleeping \(mauiNights) nights")
    print("\(departOGGF) - Depart OGG after sleeping \(honoluluNights) nights")
    print("\(arriveLHRF) - Arrive LHR")
  }
}

struct Hawaii {
  let lhrDeparture = TravelPoint(
    airport: .lhr,
    type: .departure,
    date: "2023-08-15T12:45:00+01:00"
  )

  let laxArrival = TravelPoint(
    airport: .lax,
    type: .arrival,
    date: "2023-08-15T15:55:00-07:00" // 11:10 hours later
  )

  let laxDeparture = TravelPoint(
    airport: .lax,
    type: .departure,
    date: "2023-08-15T17:55:00-07:00" // 02:00 hours later
  )

  let oggArrival = TravelPoint(
    airport: .ogg,
    type: .arrival,
    date: "2023-08-15T20:35:00-10:00" // 05:40 hours later
  )

  let points: [TravelPoint]

  init() {
    points = [
      lhrDeparture,
      laxArrival,
      laxDeparture,
      oggArrival
    ]
  }

  func duration() {
    print("Running \(#function)")

    var lastDate: Date?
    points.forEach { point in
      var string = "\(point.type.prefix) \(point.airport.name)"
      if let lastDate {
        let time = time(from: lastDate, to: point.date)
        string += ", \(time) hours later"
      }
      print(string)
      lastDate = point.date
    }

    let startDate = points.first!.date
    let endDate = points.last!.date
    let totalTime = time(from: startDate, to: endDate)
    print("Total time: \(totalTime) hours")
  }

  func trip() {
    print("Running \(#function)")

    Trip(departure: "2025-08-13T13:00:00+01:00")
      .printTrip()
  }

  func run() {
    duration()
    print("")
    trip()
  }
}

// MARK: - DateTests

struct DateTests {
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

  init() {}

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

  func test() {
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

// MARK: - Run

Hawaii().run()
print("")
DateTests().test()
