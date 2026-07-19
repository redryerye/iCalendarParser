import XCTest
@testable import iCalendarParser

final class AlarmTests: XCTestCase {
    func testParserBuildsEventAlarmComponent() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:alarm-event-test\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240729T090000Z\r
        SUMMARY:Standup\r
        BEGIN:VALARM\r
        ACTION:DISPLAY\r
        TRIGGER:-PT15M\r
        DESCRIPTION:Standup reminder\r
        DURATION:PT5M\r
        REPEAT:2\r
        END:VALARM\r
        END:VEVENT\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: iCalString))
        let event = try XCTUnwrap(calendar.events.first)
        let alarm = try XCTUnwrap(event.alarms?.first)

        XCTAssertEqual(event.alarms?.count, 1)
        XCTAssertEqual(alarm.action, "DISPLAY")
        XCTAssertEqual(alarm.trigger, "-PT15M")
        XCTAssertEqual(alarm.description, "Standup reminder")
        XCTAssertEqual(alarm.duration?.minutes, 5)
        XCTAssertEqual(alarm.repeatCount, 2)
        XCTAssertNotNil(alarm.properties?.first { $0.baseName == "TRIGGER" })
    }
}
