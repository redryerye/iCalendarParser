import XCTest
@testable import iCalendarParser

final class ToDoTests: XCTestCase {
    func testParserBuildsToDoComponent() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VTODO\r
        UID:todo-test\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240729T090000Z\r
        DUE:20240730T170000Z\r
        SUMMARY:Submit report\r
        DESCRIPTION:Prepare quarterly update\r
        STATUS:IN-PROCESS\r
        PERCENT-COMPLETE:50\r
        PRIORITY:3\r
        END:VTODO\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(ICParser().calendar(from: iCalString))
        let todo = try XCTUnwrap(calendar.todos.first)

        XCTAssertEqual(calendar.todos.count, 1)
        XCTAssertEqual(todo.uid, "todo-test")
        XCTAssertEqual(todo.summary, "Submit report")
        XCTAssertEqual(todo.description, "Prepare quarterly update")
        XCTAssertEqual(todo.status, "IN-PROCESS")
        XCTAssertEqual(todo.percentComplete, 50)
        XCTAssertEqual(todo.priority, 3)
        XCTAssertEqual(format(todo.dtStart), "20240729T090000Z")
        XCTAssertEqual(format(todo.due), "20240730T170000Z")
        XCTAssertNotNil(todo.properties?.first { $0.baseName == "SUMMARY" })
    }

    private func format(
        _ dateTime: ICDateTime?
    ) -> String? {
        dateTime.map {
            $0.type.dateFormatter(tzId: $0.tzId).string(from: $0.date)
        }
    }
}
