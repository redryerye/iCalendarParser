import XCTest
@testable import iCalendarParser

final class DurationTests: XCTestCase {

    func testBuildWeekDuration() throws {
        let duration = try XCTUnwrap(PropertyBuilder.buildDuration(from: ICProperty("DURATION", "P2W")))

        XCTAssertFalse(duration.isNegative)
        XCTAssertEqual(duration.weeks, 2)
        XCTAssertNil(duration.days)
        XCTAssertNil(duration.hours)
        XCTAssertNil(duration.minutes)
        XCTAssertNil(duration.seconds)
        XCTAssertEqual(duration.rawValue, "P2W")
    }

    func testBuildDateTimeDuration() throws {
        let duration = try XCTUnwrap(PropertyBuilder.buildDuration(from: ICProperty("DURATION", "P1DT2H30M15S")))

        XCTAssertFalse(duration.isNegative)
        XCTAssertNil(duration.weeks)
        XCTAssertEqual(duration.days, 1)
        XCTAssertEqual(duration.hours, 2)
        XCTAssertEqual(duration.minutes, 30)
        XCTAssertEqual(duration.seconds, 15)
        XCTAssertEqual(duration.rawValue, "P1DT2H30M15S")
    }

    func testBuildTimeOnlyDuration() throws {
        let duration = try XCTUnwrap(PropertyBuilder.buildDuration(from: ICProperty("DURATION", "PT45M")))

        XCTAssertNil(duration.days)
        XCTAssertEqual(duration.minutes, 45)
    }

    func testBuildSignedDuration() throws {
        let duration = try XCTUnwrap(PropertyBuilder.buildDuration(from: ICProperty("DURATION", "-PT15M")))

        XCTAssertTrue(duration.isNegative)
        XCTAssertEqual(duration.minutes, 15)
    }

    func testInvalidDurationReturnsNil() {
        XCTAssertNil(PropertyBuilder.buildDuration(from: ICProperty("DURATION", "P1M")))
        XCTAssertNil(PropertyBuilder.buildDuration(from: ICProperty("DURATION", "PT1M2H")))
        XCTAssertNil(PropertyBuilder.buildDuration(from: ICProperty("DURATION", "P1DT")))
    }
}
