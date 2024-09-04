import Foundation

public extension Array where Element: Comparable {

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
