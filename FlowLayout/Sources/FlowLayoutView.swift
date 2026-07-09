//
//  FlowLayoutView.swift
//  FlowLayout
//
//  Created by Ben Shutt on 20/08/2024.
//

import SwiftUI

public struct FlowLayoutView<Element: FlowLayoutSized & View>: View {
    private typealias Layout = FlowLayout<Element>

    @State private var lastCriteria = RedrawCriteria()
    @State private var flowLayout = Layout()

    public var elements: [Element]
    public var configuration: FlowLayoutConfiguration
    public var width: Width

    public init(
        _ elements: [Element],
        configuration: FlowLayoutConfiguration = .init(),
        width: Width = .infinity
    ) {
        self.elements = elements
        self.configuration = configuration
        self.width = width
    }

    private var frames: [Layout.Frame] {
        flowLayout.frames.flatMap { $0 }
    }

    private func sizes(in boundsSize: CGSize) -> [CGSize] {
        elements.map { $0.size(in: boundsSize) }
    }

    private func redraw(size: CGSize) {
        let criteria = RedrawCriteria(
            width: size.width,
            sizes: sizes(in: size)
        )
        guard criteria != lastCriteria else { return }
        lastCriteria = criteria

        flowLayout = FlowLayoutBuilder(
            collectionViewSize: size,
            configuration: configuration
        )
        .build(elements: elements)
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(frames) { item in
                item.element
                    .frame(
                        width: item.frame.width,
                        height: item.frame.height
                    )
                    .clipped()
                    .position(
                        x: item.frame.origin.x + item.frame.width * 0.5,
                        y: item.frame.origin.y + item.frame.height * 0.5
                    )
            }
        }
        .frame(width: width.width)
        .frame(maxWidth: width.maxWidth)
        .background {
            GeometryReader { metrics in
                Color.clear.onAppear {
                    redraw(size: metrics.size)
                }
            }
        }
        .frame(height: flowLayout.contentSize.height)
    }
}

// MARK: - FlowLayoutView.Width

public extension FlowLayoutView {
    enum Width: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
        case value(CGFloat)
        case infinity

        public init(integerLiteral value: IntegerLiteralType) {
            self = .value(CGFloat(value))
        }

        public init(floatLiteral value: FloatLiteralType) {
            self = .value(value)
        }

        public var width: CGFloat? {
            switch self {
            case .value(let value): value
            case .infinity: nil
            }
        }

        public var maxWidth: CGFloat? {
            switch self {
            case .value: nil
            case .infinity: .infinity
            }
        }
    }
}

// MARK: - RedrawCriteria

private struct RedrawCriteria: Equatable {
    var width: CGFloat = 0
    var sizes: [CGSize] = []

    static func == (lhs: RedrawCriteria, rhs: RedrawCriteria) -> Bool {
        lhs.width.equals(rhs.width) && lhs.sizes == rhs.sizes
    }
}

// MARK: - CGFloat + Extensions

private extension CGFloat {
    func equals(
        _ other: CGFloat,
        precision ε: CGFloat = 0.0001
    ) -> Bool {
        abs(self - other) < ε
    }
}

// MARK: - Preview

private struct ColorView: FlowLayoutSized, View {
    var width: CGFloat
    var height: CGFloat
    var color: Color

    var body: some View {
        color
    }

    func size(in boundsSize: CGSize) -> CGSize {
        .init(width: width, height: height)
    }
}

#Preview {
    FlowLayoutView([
        ColorView(width: 85, height: 40, color: .blue),
        ColorView(width: 100, height: 30, color: .red),
        ColorView(width: 100, height: 50, color: .yellow),
        ColorView(width: 90, height: 25, color: .gray),
        ColorView(width: 20, height: 25, color: .green),
        ColorView(width: 30, height: 50, color: .black),
        ColorView(width: 60, height: 30, color: .orange),
        ColorView(width: 80, height: 40, color: .purple),
        ColorView(width: 70, height: 20, color: .pink)
    ], configuration: .init(
        hSpacing: 5,
        vSpacing: 10,
        padding: .init(top: 5, leading: 5, bottom: 5, trailing: 5)
    ))
    .background(Color.black.opacity(0.05))
}
