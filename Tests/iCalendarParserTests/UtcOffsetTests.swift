import XCTest
@testable import iCalendarParser

final class UtcOffsetTests: XCTestCase {
    func testBuildPositiveUtcOffset() throws {
        let offset = try XCTUnwrap(
            PropertyBuilder.buildUtcOffset(from: ICProperty("TZOFFSETTO", "+0530"))
        )

        XCTAssertFalse(offset.isNegative)
        XCTAssertEqual(offset.hours, 5)
        XCTAssertEqual(offset.minutes, 30)
        XCTAssertNil(offset.seconds)
        XCTAssertEqual(offset.totalSeconds, 19_800)
        XCTAssertEqual(offset.rawValue, "+0530")
    }

    func testBuildNegativeUtcOffsetWithSeconds() throws {
        let offset = try XCTUnwrap(
            PropertyBuilder.buildUtcOffset(from: ICProperty("TZOFFSETFROM", "-033045"))
        )

        XCTAssertTrue(offset.isNegative)
        XCTAssertEqual(offset.hours, 3)
        XCTAssertEqual(offset.minutes, 30)
        XCTAssertEqual(offset.seconds, 45)
        XCTAssertEqual(offset.totalSeconds, -12_645)
    }

    func testInvalidUtcOffsetReturnsNil() {
        XCTAssertNil(PropertyBuilder.buildUtcOffset(from: ICProperty("TZOFFSETTO", "0530")))
        XCTAssertNil(PropertyBuilder.buildUtcOffset(from: ICProperty("TZOFFSETTO", "+2460")))
        XCTAssertNil(PropertyBuilder.buildUtcOffset(from: ICProperty("TZOFFSETTO", "+053060")))
        XCTAssertNil(PropertyBuilder.buildUtcOffset(from: ICProperty("TZOFFSETTO", "+05:30")))
    }
}
