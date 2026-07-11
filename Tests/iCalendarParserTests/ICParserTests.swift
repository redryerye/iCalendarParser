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

    func testEventTextListPropertiesSupportRepeatedPropertiesAndEscapedCommas() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:text-list-test\r
        DTSTAMP:20240728T120000Z\r
        COMMENT:Bring projector\r
        COMMENT:Confirm room\\, catering\r
        CONTACT:Desk\\, Front,Security\r
        CONTACT:Facilities\r
        RESOURCES:Projector,Whiteboard\\, mobile\r
        RESOURCES:Speakerphone\r
        END:VEVENT\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(sut.calendar(from: iCalString))
        let event = try XCTUnwrap(calendar.events.first)

        XCTAssertEqual(event.comments, ["Bring projector", "Confirm room, catering"])
        XCTAssertEqual(event.contacts, ["Desk, Front", "Security", "Facilities"])
        XCTAssertEqual(event.resources, ["Projector", "Whiteboard, mobile", "Speakerphone"])
    }

    func testEventRecurrenceDatePropertiesSupportRepeatedPropertiesAndCommaSeparatedValues() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:recurrence-dates-test\r
        DTSTAMP:20240728T120000Z\r
        EXDATE:20240801T120000Z,20240802T120000Z\r
        EXDATE;VALUE=DATE:20240803\r
        RDATE:20240805T120000Z\r
        RDATE;VALUE=DATE:20240806,20240807\r
        END:VEVENT\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(sut.calendar(from: iCalString))
        let event = try XCTUnwrap(calendar.events.first)

        XCTAssertEqual(event.exceptionDates?.map(\.type), [.dateTime, .dateTime, .date])
        XCTAssertEqual(event.recurrenceDates?.map(\.type), [.dateTime, .date, .date])
        XCTAssertEqual(
            event.exceptionDates?.map { $0.type.dateFormatter(tzId: $0.tzId).string(from: $0.date) },
            ["20240801T120000Z", "20240802T120000Z", "20240803"]
        )
        XCTAssertEqual(
            event.recurrenceDates?.map { $0.type.dateFormatter(tzId: $0.tzId).string(from: $0.date) },
            ["20240805T120000Z", "20240806", "20240807"]
        )
    }

    func testEventDuration() throws {
        let iCalString = """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:duration-test\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240801T120000Z\r
        DURATION:P1DT2H30M\r
        END:VEVENT\r
        END:VCALENDAR
        """

        let calendar = try XCTUnwrap(sut.calendar(from: iCalString))
        let event = try XCTUnwrap(calendar.events.first)
        let duration = try XCTUnwrap(event.duration)

        XCTAssertEqual(duration.days, 1)
        XCTAssertEqual(duration.hours, 2)
        XCTAssertEqual(duration.minutes, 30)
        XCTAssertNil(duration.seconds)
    }
}
