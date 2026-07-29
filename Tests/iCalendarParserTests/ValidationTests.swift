import XCTest
@testable import iCalendarParser

final class ValidationTests: XCTestCase {
    func testCalendarValidationRequiresProductIdentifier() {
        let calendar = ICalendar(productId: ICProductIdentifier(""))

        let errors = ICValidator().validate(calendar)

        XCTAssertEqual(errors, [.missingProductIdentifier])
    }

    func testCalendarValidationRequiresVersion() {
        let calendar = ICalendar(
            productId: ICProductIdentifier("-//Example Inc//Calendar//EN"),
            version: ""
        )

        let errors = ICValidator().validate(calendar)

        XCTAssertEqual(errors, [.missingCalendarVersion])
    }

    func testEventValidationRequiresUIDWhenParsedPropertiesAreAvailable() throws {
        let calendar = try XCTUnwrap(ICParser().calendar(from: """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240728T120000Z\r
        END:VEVENT\r
        END:VCALENDAR
        """))

        let errors = ICValidator().validate(calendar)

        XCTAssertEqual(errors, [.missingEventUID])
    }

    func testEventValidationRequiresDateStampWhenParsedPropertiesAreAvailable() throws {
        let calendar = try XCTUnwrap(ICParser().calendar(from: """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:missing-dtstamp-test\r
        DTSTART:20240728T120000Z\r
        END:VEVENT\r
        END:VCALENDAR
        """))

        let errors = ICValidator().validate(calendar)

        XCTAssertEqual(errors, [.missingEventDateStamp(uid: "missing-dtstamp-test")])
    }

    func testEventValidationRequiresDateStartWhenParsedPropertiesAreAvailable() throws {
        let calendar = try XCTUnwrap(ICParser().calendar(from: """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:missing-dtstart-test\r
        DTSTAMP:20240728T120000Z\r
        END:VEVENT\r
        END:VCALENDAR
        """))

        let errors = ICValidator().validate(calendar)

        XCTAssertEqual(errors, [.missingEventDateStart(uid: "missing-dtstart-test")])
    }

    func testEventValidationRejectsDateEndAndDurationTogether() {
        let event = ICEvent(
            dtEnd: .dateTime(from: Date(timeIntervalSince1970: 3_600)),
            duration: ICDuration(rawValue: "PT1H"),
            uid: "mutually-exclusive-test"
        )

        let errors = ICValidator().validate(event)

        XCTAssertEqual(
            errors,
            [.mutuallyExclusiveEventDateEndAndDuration(uid: "mutually-exclusive-test")]
        )
    }

    func testEventValidationRejectsDuplicateUniqueIdentifier() throws {
        let calendar = try XCTUnwrap(ICParser().calendar(from: """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:duplicate-uid-test\r
        UID:duplicate-uid-test-copy\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240728T120000Z\r
        END:VEVENT\r
        END:VCALENDAR
        """))

        let errors = ICValidator().validate(calendar)

        XCTAssertEqual(
            errors,
            [.duplicateEventProperty(uid: "duplicate-uid-test", propertyName: "UID")]
        )
    }

    func testEventValidationRejectsDuplicateDateStart() throws {
        let calendar = try XCTUnwrap(ICParser().calendar(from: """
        BEGIN:VCALENDAR\r
        VERSION:2.0\r
        PRODID:-//Example Inc//Calendar//EN\r
        BEGIN:VEVENT\r
        UID:duplicate-dtstart-test\r
        DTSTAMP:20240728T120000Z\r
        DTSTART:20240728T120000Z\r
        DTSTART:20240729T120000Z\r
        END:VEVENT\r
        END:VCALENDAR
        """))

        let errors = ICValidator().validate(calendar)

        XCTAssertEqual(
            errors,
            [.duplicateEventProperty(uid: "duplicate-dtstart-test", propertyName: "DTSTART")]
        )
    }
}
