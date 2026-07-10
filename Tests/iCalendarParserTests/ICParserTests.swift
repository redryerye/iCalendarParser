//
//  ICParserTests.swift
//  
//
//  Created by Adrian Bolinger on 7/28/24.
//

import XCTest

@testable import iCalendarParser

final class ICParserTests: XCTestCase {

    var sut: ICParser!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ICParser()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testICParser() throws {
        let iCalString = try getContents(of: "uf-full-calendar", ext: "txt")
        let calendar = sut.calendar(from: iCalString)
        XCTAssertEqual(calendar?.events.count, 295)
    }

    func testICParserCategories() throws {
        let iCalString = try getContents(of: "ufl-all-events", ext: "txt")
        guard let calendar = sut.calendar(from: iCalString) else {
            XCTFail("could not create calendar")
            return
        }

        let uniqueCategories = calendar.events
            .compactMap { $0.categories }
            .flatMap { $0 }
            .reduce(into: [String]()) { result, category in
                if !result.contains(category) {
                    result.append(category)
                }
            }

        XCTAssertEqual(uniqueCategories.count, 19)
    }

    func testCategoriesSupportEscapedCommasAndRepeatedProperties() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:category-test\r
        DTSTAMP:20240728T120000Z\r
        CATEGORIES:Board\\, Executive,Work\r
        CATEGORIES:Personal\r
        END:VEVENT\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(sut.calendar(from: iCalString))
        let event = try XCTUnwrap(calendar.events.first)

        XCTAssertEqual(event.categories, ["Board, Executive", "Work", "Personal"])
    }
}
