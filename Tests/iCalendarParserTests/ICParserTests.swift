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
}
