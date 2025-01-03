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

public struct Hawaii {
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

  public init() {
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

  public func run() {
    duration()
    print("")
    trip()
  }
}
