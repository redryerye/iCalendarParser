import XCTest
@testable import iCalendarParser

final class FormatterTests: XCTestCase {
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
