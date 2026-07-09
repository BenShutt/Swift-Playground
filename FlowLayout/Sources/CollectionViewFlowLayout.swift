//
//  CollectionViewFlowLayout.swift
//  FlowLayout
//
//  Created by Ben Shutt on 19/08/2024.
//

#if canImport(UIKit)
import UIKit

/// A `UICollectionViewLayout` for building a flow layout
open class CollectionViewFlowLayout<Element: FlowLayoutSized>: UICollectionViewLayout {

    /// Alias to a flow layout with the generic element
    public typealias Layout = FlowLayout<Element>

    /// Map an index path to its corresponding layout attributes
    public typealias AttributesMap = [IndexPath: UICollectionViewLayoutAttributes]

    /// Configuration properties of the flow layout
    open var configuration = FlowLayoutConfiguration()

    /// The elements and their associated frames
    private var flowLayout = Layout()

    /// Cache of the layout attributes
    private var attributes: AttributesMap = [:]

    /// Sized data to layout
    open var elements: [Element] = [] {
        didSet {
            redrawLayout()
            invalidateLayout()
        }
    }

    // MARK: - Collection Delegate

    open var numberOfSections: Int {
        flowLayout.frames.count
    }

    open func numberOfItemsInSection(section: Int) -> Int {
        flowLayout.frames[section].count
    }

    // MARK: - UICollectionViewLayout

    override open func prepare() {
        super.prepare()
        redrawLayout()
    }

    override open var collectionViewContentSize: CGSize {
        flowLayout.contentSize
    }

    override open func shouldInvalidateLayout(
        forBoundsChange newBounds: CGRect
    ) -> Bool {
        guard let collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }

    override open func layoutAttributesForItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        attributes[indexPath]
    }

    override open func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        attributes.values.filter { attributes in
            rect.intersects(attributes.frame)
        }
    }

    // MARK: - Layout

    /// Recompute the layout properties
    open func redrawLayout() {
        guard let collectionView else {
            flowLayout = .init()
            attributes = [:]
            return
        }

        flowLayout = FlowLayoutBuilder(
            collectionViewSize: collectionView.bounds.size,
            configuration: configuration
        )
        .build(elements: elements)

        attributes = flowLayout.frames
            .flatMap { $0 }
            .reduce(into: [:]) { map, frame in
                map[frame.id] = .init(
                    indexPath: frame.id,
                    frame: frame.frame
                )
            }
    }

    /// Subscript mapping index path into 2D array
    open subscript(indexPath: IndexPath) -> Layout.Frame {
        flowLayout[indexPath]
    }
}

// MARK: - UICollectionViewLayoutAttributes + Extensions

private extension UICollectionViewLayoutAttributes {
    convenience init(indexPath: IndexPath, frame: CGRect) {
        self.init(forCellWith: indexPath)
        self.frame = frame
    }
}
#endif
