import XCTest
@testable import iCalendarParser

final class NonStandardPropertyTests: XCTestCase {
    func testEventExposesNonStandardPropertyParameters() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:x-property-test\r
        DTSTAMP:20240728T120000Z\r
        X-APPLE-STRUCTURED-LOCATION;VALUE=URI;X-ADDRESS="1 Infinite Loop":geo:37.3317,-122.0301\r
        END:VEVENT\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: iCalString))
        let event = try XCTUnwrap(calendar.events.first)
        let property = try XCTUnwrap(event.nonStandardPropertyDetails?.first)

        XCTAssertEqual(property.baseName, "X-APPLE-STRUCTURED-LOCATION")
        XCTAssertEqual(property.value, "geo:37.3317,-122.0301")
        XCTAssertEqual(property.parameters.first(where: { $0.name == "VALUE" })?.value, "URI")
        XCTAssertEqual(property.parameters.first(where: { $0.name == "X-ADDRESS" })?.value, "1 Infinite Loop")
    }

    func testTimeZoneExposesNonStandardPropertyParameters() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VTIMEZONE\r
        TZID:America/Los_Angeles\r
        X-LIC-LOCATION;LANGUAGE=en:America/Los_Angeles\r
        BEGIN:STANDARD\r
        DTSTART:20241103T020000\r
        TZOFFSETFROM:-0700\r
        TZOFFSETTO:-0800\r
        END:STANDARD\r
        END:VTIMEZONE\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: iCalString))
        let timeZone = try XCTUnwrap(calendar.timeZones.first)
        let property = try XCTUnwrap(timeZone.nonStandardPropertyDetails?.first)

        XCTAssertEqual(property.baseName, "X-LIC-LOCATION")
        XCTAssertEqual(property.value, "America/Los_Angeles")
        XCTAssertEqual(property.parameters.first(where: { $0.name == "LANGUAGE" })?.value, "en")
    }
}
