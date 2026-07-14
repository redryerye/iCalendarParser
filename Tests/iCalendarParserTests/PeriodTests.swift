import XCTest
@testable import iCalendarParser

final class PeriodTests: XCTestCase {
    func testBuildPeriodWithExplicitEnd() throws {
        let period = try XCTUnwrap(
            PropertyBuilder.buildPeriod(
                from: ICProperty("FREEBUSY", "20240801T120000Z/20240801T130000Z")
            )
        )

        XCTAssertNil(period.duration)
        XCTAssertNotNil(period.end)
        XCTAssertEqual(period.rawValue, "20240801T120000Z/20240801T130000Z")
        XCTAssertEqual(
            period.start.type.dateFormatter(tzId: period.start.tzId).string(from: period.start.date),
            "20240801T120000Z"
        )
        XCTAssertEqual(
            period.end?.type.dateFormatter(tzId: period.end?.tzId).string(from: try XCTUnwrap(period.end?.date)),
            "20240801T130000Z"
        )
    }

    func testBuildPeriodWithDuration() throws {
        let period = try XCTUnwrap(
            PropertyBuilder.buildPeriod(
                from: ICProperty("FREEBUSY", "20240801T120000Z/PT1H30M")
            )
        )

        XCTAssertNil(period.end)
        XCTAssertEqual(period.duration?.hours, 1)
        XCTAssertEqual(period.duration?.minutes, 30)
        XCTAssertEqual(period.rawValue, "20240801T120000Z/PT1H30M")
    }

    func testInvalidPeriodReturnsNil() {
        XCTAssertNil(PropertyBuilder.buildPeriod(from: ICProperty("FREEBUSY", "20240801T120000Z")))
        XCTAssertNil(PropertyBuilder.buildPeriod(from: ICProperty("FREEBUSY", "invalid/PT1H")))
        XCTAssertNil(PropertyBuilder.buildPeriod(from: ICProperty("FREEBUSY", "20240801T120000Z/invalid")))
    }
}
