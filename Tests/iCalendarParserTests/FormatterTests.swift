import XCTest
@testable import iCalendarParser

final class FormatterTests: XCTestCase {
    func testFormatCalendarWithEvent() throws {
        let stamp = try XCTUnwrap(DateTimeType.dateTime.dateFormatter().date(from: "20240728T120000Z"))
        let start = try XCTUnwrap(DateTimeType.date.dateFormatter().date(from: "20240729"))
        let calendar = ICalendar(
            events: [
                ICEvent(
                    categories: ["Board, Executive", "Planning"],
                    description: "Line 1\nLine 2",
                    dtStamp: stamp,
                    dtStart: .date(from: start),
                    location: "Room 1; East",
                    summary: "Board, product; roadmap",
                    uid: "format-test",
                    url: URL(string: "https://example.com/events/1?source=calendar")
                )
            ],
            productId: ICProductIdentifier("-//Example Inc//Calendar//EN")
        )

        let formatted = ICFormatter.format(calendar)

        XCTAssertTrue(formatted.contains("BEGIN:VCALENDAR\r\n"))
        XCTAssertTrue(formatted.contains("VERSION:2.0\r\n"))
        XCTAssertTrue(formatted.contains("PRODID:-//Example Inc//Calendar//EN\r\n"))
        XCTAssertTrue(formatted.contains("BEGIN:VEVENT\r\n"))
        XCTAssertTrue(formatted.contains("UID:format-test\r\n"))
        XCTAssertTrue(formatted.contains("DTSTAMP:20240728T120000Z\r\n"))
        XCTAssertTrue(formatted.contains("DTSTART;VALUE=DATE:20240729\r\n"))
        XCTAssertTrue(formatted.contains("SUMMARY:Board\\, product\\; roadmap\r\n"))
        XCTAssertTrue(formatted.contains("DESCRIPTION:Line 1\\nLine 2\r\n"))
        XCTAssertTrue(formatted.contains("LOCATION:Room 1\\; East\r\n"))
        XCTAssertTrue(formatted.contains("CATEGORIES:Board\\, Executive,Planning\r\n"))
        XCTAssertTrue(formatted.contains("URL:https://example.com/events/1?source=calendar\r\n"))
        XCTAssertTrue(formatted.hasSuffix("END:VCALENDAR"))

        let parsed = try XCTUnwrap(ICParser().calendar(from: formatted))
        XCTAssertEqual(parsed.events.first?.uid, "format-test")
    }

    func testFoldLineKeepsShortLineUnchanged() {
        let line = "SUMMARY:Board meeting"

        XCTAssertEqual(ICFormatter.foldLine(line), line)
    }

    func testFoldLineWrapsLongLineWithContinuationSpace() {
        let line = "SUMMARY:" + String(repeating: "A", count: 80)
        let folded = ICFormatter.foldLine(line)
        let lines = folded.components(separatedBy: "\r\n")

        XCTAssertEqual(lines.count, 2)
        XCTAssertEqual(lines[0].utf8.count, 75)
        XCTAssertEqual(lines[1].first, " ")
        XCTAssertEqual(lines[1].utf8.count, 14)
        XCTAssertEqual(folded.replacingOccurrences(of: "\r\n ", with: ""), line)
    }

    func testFoldLineCountsUtf8Octets() {
        let line = "SUMMARY:" + String(repeating: "é", count: 40)
        let folded = ICFormatter.foldLine(line)
        let lines = folded.components(separatedBy: "\r\n")

        XCTAssertEqual(lines.count, 2)
        XCTAssertLessThanOrEqual(lines[0].utf8.count, 75)
        XCTAssertLessThanOrEqual(lines[1].utf8.count, 75)
        XCTAssertEqual(lines[1].first, " ")
        XCTAssertEqual(folded.replacingOccurrences(of: "\r\n ", with: ""), line)
    }

    func testFoldLinesFoldsEachLine() {
        let lines = [
            "SUMMARY:Short",
            "DESCRIPTION:" + String(repeating: "A", count: 80)
        ]

        let folded = ICFormatter.foldLines(lines)

        XCTAssertTrue(folded.contains("SUMMARY:Short\r\nDESCRIPTION:"))
        XCTAssertTrue(folded.contains("\r\n "))
    }

    func testEscapeTextValueEscapesReservedCharacters() {
        let value = "Board, product; roadmap \\ review"

        XCTAssertEqual(
            ICFormatter.escapeTextValue(value),
            "Board\\, product\\; roadmap \\\\ review"
        )
    }

    func testEscapeTextValueEscapesLineBreaks() {
        let value = "Line 1\r\nLine 2\rLine 3\nLine 4"

        XCTAssertEqual(
            ICFormatter.escapeTextValue(value),
            "Line 1\\nLine 2\\nLine 3\\nLine 4"
        )
    }
}
