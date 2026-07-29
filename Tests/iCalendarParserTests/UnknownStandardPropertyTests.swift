import XCTest
@testable import iCalendarParser

final class UnknownStandardPropertyTests: XCTestCase {
    func testEventPreservesUnknownStandardPropertyAndParameters() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:unknown-standard-property-test\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240728T120000Z\r
        COLOR;VALUE=TEXT:turquoise\r
        END:VEVENT\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: iCalString))
        let event = try XCTUnwrap(calendar.events.first)
        let color = try XCTUnwrap(event.properties?.first { $0.baseName == "COLOR" })

        XCTAssertEqual(color.value, "turquoise")
        XCTAssertEqual(color.parameters.first { $0.name == "VALUE" }?.value, "TEXT")
    }
}
