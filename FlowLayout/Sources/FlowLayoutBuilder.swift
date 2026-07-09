//
//  FlowLayoutBuilder.swift
//  FlowLayout
//
//  Created by Ben Shutt on 19/08/2024.
//

import SwiftUI

/// Given a configuration, compute a collection of sized elements into their frames in flow layout
@MainActor
open class FlowLayoutBuilder<Element: FlowLayoutSized> {

    /// Alias to a flow layout with the generic element
    public typealias Layout = FlowLayout<Element>

    /// Alias to a frame with the generic element
    public typealias Frame = Layout.Frame

    /// Size of the collection view bounds
    open var collectionViewSize: CGSize

    /// The configuration properties of the layout
    open var configuration: FlowLayoutConfiguration

    /// Storage of the accumulated X origin value (for the next element)
    private var originX: CGFloat = 0

    /// Storage of the accumulated Y origin value (for the next element)
    private var originY: CGFloat = 0

    /// Storage of the committed rows that have been built
    private var frames: [[Frame]] = []

    /// Storage of the bottom uncommitted row being built
    private var currentRow: [Frame] = []

    // MARK: - Shorthand

    /// Shorthand to get the `hSpacing` of `configuration`
    private var hSpacing: CGFloat { configuration.hSpacing }

    /// Shorthand to get the `vSpacing` of `configuration`
    private var vSpacing: CGFloat { configuration.vSpacing }

    /// Shorthand to get the `padding` of `configuration`
    private var padding: EdgeInsets { configuration.padding }

    // MARK: - Init

    /// Public memberwise initializer
    public init(
        collectionViewSize: CGSize,
        configuration: FlowLayoutConfiguration = .init()
    ) {
        self.collectionViewSize = collectionViewSize
        self.configuration = configuration
    }

    // MARK: - Calculation

    /// Revert properties back to their defaults
    private func reset() {
        originX = padding.leading
        originY = padding.top
        frames = []
        currentRow = []
    }

    /// Add the current row to the frames and start a new line
    private func commitCurrentLine() {
        originX = padding.leading
        originY = (currentRow.maxY ?? 0) + vSpacing
        frames.append(currentRow)
        currentRow = []
    }
    
    /// Commit an element to the current row
    /// - Parameters:
    ///   - element: The element to commit
    ///   - size: The size of the element
    private func commit(element: Element, size: CGSize) {
        currentRow.append(.init(
            id: .init(
                item: currentRow.count,
                section: frames.count
            ),
            element: element,
            frame: CGRect(
                x: originX,
                y: originY,
                width: size.width,
                height: size.height
            )
        ))
        originX += size.width + hSpacing
    }
    
    /// Layout the given element into its respective row
    /// - Parameter element: Element to layout
    private func add(element: Element) {
        let size = element.size(in: collectionViewSize)

        // Check that the element will fit
        guard size.width > 0, size.height > 0 else { return }

        // Available width to layout in.
        // Elements with a width more than this will not be added
        let hPadding = padding.leading + padding.trailing
        let maxWidth = collectionViewSize.width - hPadding
        guard size.width <= maxWidth else { return }

        // Check if it fits on this existing row
        let maxX = originX + size.width
        if maxX <= collectionViewSize.width - padding.trailing {
            commit(element: element, size: size)
            return
        }

        // Start a new line
        commitCurrentLine()
        commit(element: element, size: size)
    }

    // MARK: - Build
    
    /// Build a flow layout from the given elements
    /// - Parameter elements: The elements to layout
    /// - Returns: The elements and their associated frames
    open func build(elements: [Element]) -> Layout {
        // Iterate through the elements and compute their frames
        reset()
        elements.forEach { add(element: $0) }
        if !currentRow.isEmpty {
            commitCurrentLine()
        }

        // Get the maxY coordinate of the last row.
        // If there are no elements return empty
        guard let maxY = frames.last?.maxY else { return .init() }

        // Return the build result
        return .init(
            contentSize: .init(
                width: collectionViewSize.width,
                height: maxY + padding.bottom
            ),
            frames: frames
        )
    }
}


// MARK: - Array + Framed

private protocol Framed {
    var frame: CGRect { get }
}

extension FlowLayout.Frame: Framed {}

private extension Array where Element: Framed {
    var maxY: CGFloat? {
        self.max { $0.frame.maxY < $1.frame.maxY }?.frame.maxY
    }
}
