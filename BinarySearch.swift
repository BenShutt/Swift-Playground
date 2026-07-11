import Foundation

extension Array where Element: Comparable {

    /// Perform a binary search to find the index of `value` in this instance.
    /// This instance does not need to be sorted before calling this function;
    /// this function sorts it before executing the search.
    /// - Parameter value: The value to search for in this instance
    /// - Returns: The index of `value` or `nil` if not found
    func binarySearch(for value: Element) -> Int? {
        sorted().binarySearch(
            value: value,
            lowerIndex: startIndex,
            upperIndex: index(before: endIndex)
        )
    }

    private func binarySearch(
        value: Element,
        lowerIndex: Int,
        upperIndex: Int
    ) -> Int? {
        // Check if the bounding indices have a middle index.
        // If not, return nil
        guard lowerIndex <= upperIndex else { return nil }

        // Get the index in the middle of the lower and upper indices.
        // Use the floor function to take the lower of the middle indices
        // when there is 2.
        let index = (upperIndex + lowerIndex) / 2

        // Update the search indices based on the value of this middle index
        if self[index] == value {
            // Success, return the index
            return index
        } else if self[index] > value {
            // The value at this index is too large.
            // Search to the left from [lowerIndex, index - 1]
            return binarySearch(
                value: value,
                lowerIndex: lowerIndex,
                upperIndex: index - 1
            )
        } else {
            // The value at this index is too small.
            // Search to the right from [index + 1, upperIndex]
            return binarySearch(
                value: value,
                lowerIndex: index + 1,
                upperIndex: upperIndex
            )
        }
    }
}

private func testBinarySearch<Element: Comparable>(
    _ array: [Element],
    value: Element,
    expectedIndex: Int?
) {
    let index = array.binarySearch(for: value)
    if index == expectedIndex {
        print("Success")
    } else {
        let actual = index?.description ?? "nil"
        let expected = expectedIndex?.description ?? "nil"
        print("Failure, returned \(actual) but expected \(expected)")
    }
}

// Integers, empty or one
testBinarySearch([], value: 0, expectedIndex: nil)
testBinarySearch([1], value: 0, expectedIndex: nil)
testBinarySearch([100], value: 100, expectedIndex: 0)

// Integers, basic
testBinarySearch([1, 2, 3], value: 0, expectedIndex: nil)
testBinarySearch([1, 2, 3], value: 1, expectedIndex: 0)
testBinarySearch([1, 2, 3], value: 2, expectedIndex: 1)
testBinarySearch([1, 2, 3], value: 3, expectedIndex: 2)
testBinarySearch([1, 2, 3], value: 4, expectedIndex: nil)

// Strings, basic
testBinarySearch(["a", "b", "c"], value: "", expectedIndex: nil)
testBinarySearch(["a", "b", "c"], value: "a", expectedIndex: 0)
testBinarySearch(["a", "b", "c"], value: "b", expectedIndex: 1)
testBinarySearch(["a", "b", "c"], value: "c", expectedIndex: 2)
testBinarySearch(["a", "b", "c"], value: "d", expectedIndex: nil)

// Integers, basic, unsorted
testBinarySearch([3, 1, 2], value: 1, expectedIndex: 0)
testBinarySearch([3, 1, 2], value: 2, expectedIndex: 1)
testBinarySearch([3, 1, 2], value: 3, expectedIndex: 2)

// Integers
testBinarySearch([1, 5, 9, 12, 17], value: 1, expectedIndex: 0)
testBinarySearch([1, 5, 9, 12, 17], value: 5, expectedIndex: 1)
testBinarySearch([1, 5, 9, 12, 17], value: 9, expectedIndex: 2)
testBinarySearch([1, 5, 9, 12, 17], value: 12, expectedIndex: 3)
testBinarySearch([1, 5, 9, 12, 17], value: 17, expectedIndex: 4)
testBinarySearch([1, 5, 9, 12, 17], value: 0, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 2, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 4, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 6, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 8, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 10, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 11, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 13, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 16, expectedIndex: nil)
testBinarySearch([1, 5, 9, 12, 17], value: 18, expectedIndex: nil)
