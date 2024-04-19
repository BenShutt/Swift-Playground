import Foundation

// https://github.com/apple/swift-collections/blob/main/Documentation/Deque.md
// Use Dequeue so removeFirst() is more efficient

/// A range bounded by two time intervals
typealias TimeRange = Range<TimeInterval>

/// A time interval range with a count.
///
/// May be used to, say, count overlaps across an array of time intervals.
struct RangeCount: Equatable {

    /// The range bounded by two time intervals
    var range: TimeRange

    /// How many occurrences are counted for this range
    var count: Int
    
    /// Iterate over the given ranges and return the counts which they overlap
    /// - Parameter ranges: The ranges to iterate over
    /// - Returns: The overlap counts and their ranges
    static func count(ranges: [TimeRange]) -> [RangeCount] {
        var iterator = RangeIterator(ranges: ranges)
        while iterator.processNextValue() {}
        return iterator.counts
    }
}

// MARK: - RangeIterator

/// Given a range of time intervals, iterate over the range's lower and upper bounds processing
/// each critical point from lowest to highest.
/// At each point, increment the counter and remove from the bounds arrays accordingly.
private struct RangeIterator {

    /// The lower bounds from a given range, sorted
    var lowerBounds: [TimeInterval]

    /// The upper bounds from a given range, sorted
    var upperBounds: [TimeInterval]

    /// The count of the current range since the last critical point
    var count = 0

    /// The value of the last critical point
    var lastValue: TimeInterval?

    /// An accumulation of the ranges and their overlap counts while processing
    var counts: [RangeCount] = []

    /// At a critical point, commit a range from the last value to the current value
    /// with the accumulated count.
    /// Set `lastValue` to the given value on function exit.
    /// - Parameter value: The new critical point value
    mutating func commit(value: TimeInterval) {
        defer { lastValue = value }
        guard let lastValue else { return }
        counts.append(RangeCount(
            range: lastValue..<value,
            count: count
        ))
    }

    /// Move to the next critical point, calculate the lowest value and update properties
    /// - Returns: Whether a critical point has been processed.
    mutating func processNextValue() -> Bool {
        // Query (but do not remove) the smallest values of the upper and lower bounds.
        // Take the value and count of the lowest (or merging both if equal).
        // Only remove if the value is used.
        // If upper bounds is empty, we are done iterating.
        guard let upper = upperBounds.firstValueCount() else { return false }
        let lower = lowerBounds.firstValueCount()

        // Given the lowest value, compute the property offsets
        let value = BoundValue(lower: lower, upper: upper)

        // Mark a new critical point at this (lowest) value
        commit(value: value.value)

        // Lower bounds add one, upper bound remove one.
        // Update by the offset of all the bounds that were used.
        count += value.difference

        // Remove all the values that were used
        if value.removeFromLower > 0 {
            lowerBounds.removeFirst(value.removeFromLower)
        }
        if value.removeFromUpper > 0 {
            upperBounds.removeFirst(value.removeFromUpper)
        }
        return true
    }
    
    /// Initialize with ranges of time intervals.
    /// - Parameter ranges: The ranges, does not need to be sorted.
    init(ranges: [TimeRange]) {
        let nonEmptyRanges = ranges.filter { !$0.isEmpty }
        lowerBounds = nonEmptyRanges.map { $0.lowerBound }.sorted()
        upperBounds = nonEmptyRanges.map { $0.upperBound }.sorted()
    }
}

// MARK: - BoundValue

/// A critical point where a collection of lower and/or upper bounds may be resolved.
/// The minimum is selected each time.
private struct BoundValue {

    /// The value at the bound
    var value: TimeInterval

    /// The amount to offset the count
    var difference: Int

    /// Number of lower bounds involved in the calculation
    var removeFromLower = 0

    /// Number of upper bounds involved in the calculation
    var removeFromUpper = 0
    
    /// Take the smallest value of the given lower and upper bound.
    /// An upper bound of a range may be less than a lower bound of an other.
    /// If the bounds have equal value, merge the two and calculate the difference/offset.
    /// - Parameters:
    ///   - lower: The smallest lower bound and how often it occurs. May be `nil`.
    ///   - upper: The smallest upper bound and how often it occurs
    init(lower: ValueCount?, upper: ValueCount) {
        if let lower, lower.value == upper.value {
            // Values are the same, calculate the difference and remove from both
            value = lower.value
            difference = lower.count - upper.count
            removeFromLower = lower.count
            removeFromUpper = upper.count
        } else if let lower, lower.value < upper.value {
            // Lower value is less, only take lower
            value = lower.value
            difference = lower.count
            removeFromLower = lower.count
        } else { 
            // Upper value is less, only take upper
            value = upper.value
            difference = -upper.count // Note the minus
            removeFromUpper = upper.count
        }
    }
}

// MARK: - ValueCount

/// A value and the number of times it occurs.
///
/// For example, an array such as `[1,1,1,2,3,4]` might have `value` equal
/// to `1` and `count` equal to `3`.
private struct ValueCount: Equatable {

    /// A value which has been counted
    var value: TimeInterval

    /// The number of occurrences of the value
    var count: Int
}

// MARK: - Array + ValueCount

private extension Array where Element == TimeInterval {

    /// Get and count the number of occurrences of the first value.
    /// - Warning: This array instance must be *sorted* before calling this function.
    /// - Returns: The first value and how many occurrences it has. `nil` if empty.
    func firstValueCount() -> ValueCount? {
        guard let first else { return nil }
        var firstCount = 1
        for index in 1..<count {
            guard self[index] == first else { break }
            firstCount += 1
        }
        return ValueCount(value: first, count: firstCount)
    }
}

// MARK: - ========== TESTS ==========

private func test(ranges: [TimeRange], expected: [RangeCount]) {
    let actual = RangeCount.count(ranges: ranges)
    if actual == expected {
        print("Success")
    } else {
        print("Failure:")
        print(rangeCounts: actual)
    }
}

test(ranges: [
    1..<5,
    2..<5,
    3..<5,
    4..<5
], expected: [
    .init(range: 1..<2, count: 1),
    .init(range: 2..<3, count: 2),
    .init(range: 3..<4, count: 3),
    .init(range: 4..<5, count: 4)
])

test(ranges: [
    1..<10,
    2..<8,
    3..<4,
    3..<11,
    8..<12,
    14..<15
], expected: [
    .init(range: 1..<2, count: 1),
    .init(range: 2..<3, count: 2),
    .init(range: 3..<4, count: 4),
    .init(range: 4..<8, count: 3),
    .init(range: 8..<10, count: 3),
    .init(range: 10..<11, count: 2),
    .init(range: 11..<12, count: 1),
    .init(range: 12..<14, count: 0),
    .init(range: 14..<15, count: 1)
])

test(ranges: [
    3..<6,
    2..<10,
    5..<6,
    6..<7,
    12..<13,
    4..<9,
    8..<11,
    1..<2,
    4..<14,
    1..<2,
    1..<2,
    2..<3,
    16..<20,
    23..<25
], expected: [
    .init(range: 1..<2, count: 3),
    .init(range: 2..<3, count: 2),
    .init(range: 3..<4, count: 2),
    .init(range: 4..<5, count: 4),
    .init(range: 5..<6, count: 5),
    .init(range: 6..<7, count: 4),
    .init(range: 7..<8, count: 3),
    .init(range: 8..<9, count: 4),
    .init(range: 9..<10, count: 3),
    .init(range: 10..<11, count: 2),
    .init(range: 11..<12, count: 1),
    .init(range: 12..<13, count: 2),
    .init(range: 13..<14, count: 1),
    .init(range: 14..<16, count: 0),
    .init(range: 16..<20, count: 1),
    .init(range: 20..<23, count: 0),
    .init(range: 23..<25, count: 1)
])

test(ranges: [
    1..<1.5,
    1.6..<2,
    2..<2.6,
    2.5..<3
], expected: [
    .init(range: 1..<1.5, count: 1),
    .init(range: 1.5..<1.6, count: 0),
    .init(range: 1.6..<2, count: 1),
    .init(range: 2..<2.5, count: 1),
    .init(range: 2.5..<2.6, count: 2),
    .init(range: 2.6..<3, count: 1)
])

test(ranges: [
    3..<5,
    2..<4,
    8..<11,
    4..<8,
    1..<13,
    11..<13,
    9..<13,
    8..<13,
    3..<6,
    3..<5,
    3..<4,
    1..<8,
    14..<15
], expected: [
    .init(range: 1..<2, count: 2),
    .init(range: 2..<3, count: 3),
    .init(range: 3..<4, count: 7),
    .init(range: 4..<5, count: 6),
    .init(range: 5..<6, count: 4),
    .init(range: 6..<8, count: 3),
    .init(range: 8..<9, count: 3),
    .init(range: 9..<11, count: 4),
    .init(range: 11..<13, count: 4),
    .init(range: 13..<14, count: 0),
    .init(range: 14..<15, count: 1)
])

private func print(rangeCounts: [RangeCount]) {
    rangeCounts.forEach { item in
        print("Count=\(item.count) - \(item.range.description)")
    }
}
