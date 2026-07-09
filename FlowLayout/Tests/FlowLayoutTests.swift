import SwiftUI
import XCTest
@testable import FlowLayout

final class FlowLayoutTests: XCTestCase {
    private let collectionViewSize = CGSize(width: 100, height: 500)
    private let padding = EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    private let vSpacing: CGFloat = 20
    private let hSpacing: CGFloat = 10

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func test() {
        // Row 1, maxY = 30
        let a1 = makeCell(x: 5, y: 5, width: 20, height: 15)
        let a2 = makeCell(x: 35, y: 5, width: 40, height: 10)
        let a3 = makeCell(x: 85, y: 5, width: 5, height: 25)

        // Row 2, maxY = 65
        let b1 = makeCell(x: 5, y: 50, width: 5, height: 15)
        let b2 = makeCell(x: 20, y: 50, width: 75, height: 15)

        // Invalid row (too wide)
        let invalid1 = makeCell(x: 5, y: 85, width: 95, height: 50)

        // Row 3, maxY = 100
        let c1 = makeCell(x: 5, y: 85, width: 90, height: 15)

        // Row 4, maxY = 170
        let d1 = makeCell(x: 5, y: 120, width: 75, height: 50)
        let d2 = makeCell(x: 90, y: 120, width: 5, height: 20)

        // Row 5, maxY = 210
        let e1 = makeCell(x: 5, y: 190, width: 5, height: 5)
        let e2 = makeCell(x: 20, y: 190, width: 5, height: 20)
        let e3 = makeCell(x: 35, y: 190, width: 15, height: 5)
        let e4 = makeCell(x: 60, y: 190, width: 35, height: 10)

        // Row 6, maxY = 240
        let f1 = makeCell(x: 5, y: 230, width: 30, height: 10)
        let f2 = makeCell(x: 45, y: 230, width: 30, height: 10)

        // Invalid row (zero width)
        let invalid2 = makeCell(x: 5, y: 260, width: 0, height: 100)

        // Invalid row (zero height)
        let invalid3 = makeCell(x: 5, y: 260, width: 10, height: 0)

        // Row 7, maxY = 320
        let g1 = makeCell(x: 5, y: 260, width: 15, height: 20)
        let g2 = makeCell(x: 30, y: 260, width: 50, height: 60)
        let g3 = makeCell(x: 90, y: 260, width: 5, height: 30)

        // Make the cells
        let cells = [
            a1,
            a2,
            a3,

            b1,
            b2,

            invalid1,

            c1,

            d1,
            d2,

            e1,
            e2,
            e3,
            e4,

            f1,
            f2,

            invalid2,

            invalid3,

            g1,
            g2,
            g3
        ]

        let result = FlowLayoutBuilder(
            collectionViewSize: collectionViewSize,
            configuration: .init(
                hSpacing: hSpacing,
                vSpacing: vSpacing,
                padding: padding
            )
        )
        .build(elements: cells)

        let frames = result.frames
        XCTAssertEqual(frames.count, 7)

        XCTAssertEqual(frames[0].count, 3)
        a1.assertEquals(frames[0][0])
        a2.assertEquals(frames[0][1])
        a3.assertEquals(frames[0][2])

        XCTAssertEqual(frames[1].count, 2)
        b1.assertEquals(frames[1][0])
        b2.assertEquals(frames[1][1])

        XCTAssertEqual(frames[2].count, 1)
        c1.assertEquals(frames[2][0])

        XCTAssertEqual(frames[3].count, 2)
        d1.assertEquals(frames[3][0])
        d2.assertEquals(frames[3][1])

        XCTAssertEqual(frames[4].count, 4)
        e1.assertEquals(frames[4][0])
        e2.assertEquals(frames[4][1])
        e3.assertEquals(frames[4][2])
        e4.assertEquals(frames[4][3])

        XCTAssertEqual(frames[5].count, 2)
        f1.assertEquals(frames[5][0])
        f2.assertEquals(frames[5][1])

        XCTAssertEqual(frames[6].count, 3)
        g1.assertEquals(frames[6][0])
        g2.assertEquals(frames[6][1])
        g3.assertEquals(frames[6][2])

        XCTAssertEqual(
            result.contentSize,
            CGSize(width: 100, height: 325)
        )
    }

    // MARK: - Make

    private func makeCell(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> TestCell {
        .init(frame: .init(
            x: x,
            y: y,
            width: width,
            height: height
        ))
    }
}

// MARK: - TestCell

private struct TestCell: FlowLayoutSized, Equatable {
    var frame: CGRect

    func size(in boundsSize: CGSize) -> CGSize {
        frame.size
    }

    func assertEquals(_ cellFrame: FlowLayout<TestCell>.Frame) {
        XCTAssertEqual(cellFrame.element, self)
        XCTAssertEqual(cellFrame.frame, frame)
    }
}
