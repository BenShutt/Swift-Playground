//
//  PreviewView.swift
//  FlowLayout
//
//  Created by Ben Shutt on 20/08/2024.
//

#if canImport(UIKit)
import SwiftUI

// MARK: - Block

private struct Block: FlowLayoutSized {
    var width: CGFloat
    var height: CGFloat
    var color: Color

    func size(in boundsSize: CGSize) -> CGSize {
        .init(width: width, height: height)
    }
}

// MARK: - Blocks

@MainActor private final class BlockManager: ObservableObject {
    @Published private(set) var blocks: [Block] = []

    func build() async {
        blocks = (1...100).map { _ in
            Block(
                width: CGFloat(Int.random(in: 20...200)),
                height: CGFloat(Int.random(in: 30...100)),
                color: .init(
                    red: .random(in: 0...1),
                    green: .random(in: 0...1),
                    blue: .random(in: 0...1)
                )
            )
        }
    }
}

// MARK: - BlockView

private struct BlockView: View {
    var block: Block

    private var title: String {
        "\(Int(block.width)), \(Int(block.height))"
    }

    var body: some View {
        block.color.opacity(0.2)
            .overlay {
                Text(title)
                    .font(.system(size: 20))
                    .lineLimit(1)
                    .minimumScaleFactor(0.25)
                    .foregroundStyle(Color.black)
                    .padding(2)
            }
            .clipShape(.rect(cornerRadius: 5))
    }
}

// MARK: - CollectionViewController

private class CollectionViewController: UICollectionViewController {
    typealias Layout = CollectionViewFlowLayout<Block>

    private let reuseIdentifier = "FlowLayoutCell"
    private var layout: Layout {
        collectionViewLayout as! Layout
    }

    // MARK: - Init

    init(configuration: FlowLayoutConfiguration) {
        let layout = Layout()
        layout.configuration = configuration
        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        layout.numberOfSections
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        layout.numberOfItemsInSection(section: section)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let model = layout[indexPath].element

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        )
        cell.contentConfiguration = UIHostingConfiguration {
            Button(action: {
                // Implement...
            }, label: {
                BlockView(block: model)
            })
            .buttonStyle(PlainButtonStyle())
        }
        .background(Color.clear)
        .margins(.all, 0)
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // Cell button handles the tap
        collectionView.deselectItem(
            at: indexPath,
            animated: false
        )
    }

    // MARK: - Redraw

    func redraw(blocks: [Block]) {
        layout.elements = blocks
        guard isViewLoaded else { return }
        collectionView.reloadData()
    }
}

// MARK: - CollectionView

private struct CollectionView: UIViewControllerRepresentable {
    @ObservedObject var manager: BlockManager

    func makeUIViewController(context: Context) -> CollectionViewController {
        CollectionViewController(configuration: .init(
            hSpacing: 10,
            vSpacing: 20,
            padding: .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        ))
    }

    func updateUIViewController(
        _ viewController: CollectionViewController,
        context: Context
    ) {
        viewController.redraw(blocks: manager.blocks)
    }
}

// MARK: - PreviewView

private struct PreviewView: View {
    @StateObject private var manager = BlockManager()

    var body: some View {
        CollectionView(manager: manager)
            .task {
                await manager.build()
            }
    }
}

// MARK: - Preview

#Preview {
    PreviewView()
}
#endif
