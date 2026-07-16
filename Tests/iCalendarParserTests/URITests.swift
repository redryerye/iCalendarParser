import XCTest
@testable import iCalendarParser

final class URITests: XCTestCase {

    func testBuildURI() throws {
        let uri = try XCTUnwrap(ICURI(rawValue: "https://example.com/events/1?source=calendar"))

        XCTAssertEqual(uri.rawValue, "https://example.com/events/1?source=calendar")
        XCTAssertEqual(uri.url.absoluteString, "https://example.com/events/1?source=calendar")
    }

    func testBuildURIRequiresScheme() {
        XCTAssertNil(ICURI(rawValue: "example.com/events/1"))
    }

    func testParserBuildsEventURLFromURIValue() throws {
        let ics = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Test//iCalendarParser//EN\r
        BEGIN:VEVENT\r
        UID:uri-test\r
        DTSTAMP:20240728T120000Z\r
        URL:https://example.com/events/1?source=calendar\r
        END:VEVENT\r
        END:VCALENDAR\r
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: ics))
        let event = try XCTUnwrap(calendar.events.first)

        XCTAssertEqual(event.url?.absoluteString, "https://example.com/events/1?source=calendar")
    }
}
