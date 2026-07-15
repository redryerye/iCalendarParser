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
}
