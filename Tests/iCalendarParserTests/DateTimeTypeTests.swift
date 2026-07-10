import XCTest
@testable import iCalendarParser

final class DateTimeTypeTests: XCTestCase {
    func testBuildDateTime() {
        let property = ICProperty("DTSTART", "19700329T020000")
        let dateTime = PropertyBuilder.buildDateTime(from: property)

        XCTAssertNotNil(dateTime)
        XCTAssertNotNil(dateTime?.date)
        XCTAssertEqual(dateTime?.type, .dateTime)
    }

    func testDateTimeWithCorrectDate() {
        let property = ICProperty("DTSTART", "19700329T020000")
        let dateTime = PropertyBuilder.buildDateTime(from: property)!

        let date = dateTime.type.dateFormatter().date(from: "19700329T020000")
        XCTAssertEqual(dateTime.date, date)
    }

    func testDateTimeWithWrongDate() {
        let property = ICProperty("DTSTART", "19700329T020000")
        let dateTime = PropertyBuilder.buildDateTime(from: property)!

        let wrongDate = dateTime.type.dateFormatter().date(from: "19700327T020000")
        XCTAssertNotEqual(dateTime.date, wrongDate)
    }

    func testDateFormatterUsesFixedLocale() throws {
        let formatter = DateTimeType.dateTime.dateFormatter(tzId: "UTC")

        XCTAssertEqual(formatter.locale.identifier, "en_US_POSIX")

        let date = try XCTUnwrap(formatter.date(from: "19700329T020000"))
        let components = Calendar(identifier: .gregorian).dateComponents(
            in: try XCTUnwrap(TimeZone(identifier: "UTC")),
            from: date
        )

        XCTAssertEqual(components.year, 1970)
        XCTAssertEqual(components.month, 3)
        XCTAssertEqual(components.day, 29)
        XCTAssertEqual(components.hour, 2)
    }
}
