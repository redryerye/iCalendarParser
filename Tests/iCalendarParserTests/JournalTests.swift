import XCTest
@testable import iCalendarParser

final class JournalTests: XCTestCase {
    func testParserBuildsJournalComponent() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VJOURNAL\r
        UID:journal-test\r
        DTSTAMP:20240728T120000Z\r
        DTSTART;VALUE=DATE:20240729\r
        SUMMARY:Daily note\r
        DESCRIPTION:Retrospective notes\r
        STATUS:FINAL\r
        END:VJOURNAL\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: iCalString))
        let journal = try XCTUnwrap(calendar.journals.first)

        XCTAssertEqual(calendar.journals.count, 1)
        XCTAssertEqual(journal.uid, "journal-test")
        XCTAssertEqual(journal.summary, "Daily note")
        XCTAssertEqual(journal.description, "Retrospective notes")
        XCTAssertEqual(journal.status, "FINAL")
        XCTAssertEqual(journal.dtStart?.type, .date)
        XCTAssertNotNil(journal.properties?.first { $0.baseName == "SUMMARY" })
    }
}
