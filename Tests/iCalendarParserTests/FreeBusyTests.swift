import XCTest
@testable import iCalendarParser

final class FreeBusyTests: XCTestCase {
    func testParserBuildsFreeBusyComponent() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VFREEBUSY\r
        UID:freebusy-test\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240729T090000Z\r
        DTEND:20240729T170000Z\r
        ORGANIZER:mailto:organizer@example.com\r
        FREEBUSY:20240729T100000Z/20240729T110000Z,\r
         20240729T130000Z/PT30M\r
        URL:https://example.com/freebusy/freebusy-test\r
        END:VFREEBUSY\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: iCalString))
        let freeBusy = try XCTUnwrap(calendar.freeBusy.first)

        XCTAssertEqual(calendar.freeBusy.count, 1)
        XCTAssertEqual(freeBusy.uid, "freebusy-test")
        XCTAssertEqual(freeBusy.organizer, "mailto:organizer@example.com")
        XCTAssertEqual(freeBusy.url?.absoluteString, "https://example.com/freebusy/freebusy-test")
        XCTAssertEqual(freeBusy.freeBusy?.count, 2)
        XCTAssertEqual(format(freeBusy.freeBusy?.first?.start), "20240729T100000Z")
        XCTAssertEqual(format(freeBusy.freeBusy?.first?.end), "20240729T110000Z")
        XCTAssertEqual(freeBusy.freeBusy?[1].duration?.minutes, 30)
    }

    private func format(
        _ dateTime: ICDateTime?
    ) -> String? {
        dateTime.map {
            $0.type.dateFormatter(tzId: $0.tzId).string(from: $0.date)
        }
    }
}
