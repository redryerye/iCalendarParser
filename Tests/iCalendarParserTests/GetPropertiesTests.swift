import XCTest
@testable import iCalendarParser

final class GetPropertiesTests: XCTestCase {
    func testCreateProperties() {
        let rawIcs = """
        BEGIN:VCALENDAR\r\nPRODID:-//Example Inc//Calendar//EN\r\nVERSION:2.0
        """

        let parser = ICParser()
        let properties = parser.getProperties(from: rawIcs)

        XCTAssertTrue(!properties.isEmpty)
        XCTAssertEqual(properties.count, 3)
    }

    func testPropertiesShouldNotIncludeSpace() {
        let rawIcs = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;
        RSVP=TRUE\r\n ;CN=example@mail.com;X-NUM-GUESTS=0:mailto:example@mail.com
        """

        let parser = ICParser()
        let properties = parser.getProperties(from: rawIcs)

        XCTAssertTrue(properties.filter { $0.name.contains(" ")}.isEmpty)
    }

    func testCreatePropertiesWithNewLine() {
        let rawIcs = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;RSVP=\
        TRUE\r\n ;CN=example@mail.com;X-NUM-GUESTS=0:mailto:example@mail.com
        """

        let parser = ICParser()
        let properties = parser.getProperties(from: rawIcs)

        XCTAssertTrue(!properties.isEmpty)
        XCTAssertEqual(properties.count, 1)

        let name = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=\
        ACCEPTED;RSVP=TRUE;CN=example@mail.com;X-NUM-GUESTS=0
        """
        XCTAssertEqual(properties.first?.name, name)
    }

    func testUnfoldsLineBeginningWithTab() {
        let rawIcs = "SUMMARY:Hello\r\n\tWorld"

        let properties = ICParser().getProperties(from: rawIcs)

        XCTAssertEqual(properties.first?.value, "HelloWorld")
    }

    func testParsesQuotedParameterValues() throws {
        let rawIcs = #"ATTENDEE;CN="Doe, John";ROLE=REQ-PARTICIPANT:mailto:john@example.com"#

        let property = try XCTUnwrap(ICParser().getProperties(from: rawIcs).first)

        XCTAssertEqual(property.baseName, "ATTENDEE")
        XCTAssertEqual(property.parameters.first(where: { $0.name == "CN" })?.value, "Doe, John")
        XCTAssertEqual(
            property.parameters.first(where: { $0.name == "ROLE" })?.value,
            "REQ-PARTICIPANT"
        )
    }

    func testParsesMultiValueParameterValues() throws {
        let rawIcs = #"ATTENDEE;MEMBER="mailto:a@example.com","mailto:b@example.com":mailto:c@example.com"#

        let property = try XCTUnwrap(ICParser().getProperties(from: rawIcs).first)
        let member = try XCTUnwrap(property.parameters.first(where: { $0.name == "MEMBER" }))

        XCTAssertEqual(member.values, ["mailto:a@example.com", "mailto:b@example.com"])
    }

    func testParsesColonInsideQuotedParameterValue() throws {
        let rawIcs = #"ATTENDEE;CN="Team: Calendar":mailto:team@example.com"#

        let property = try XCTUnwrap(ICParser().getProperties(from: rawIcs).first)

        XCTAssertEqual(property.value, "mailto:team@example.com")
        XCTAssertEqual(property.parameters.first(where: { $0.name == "CN" })?.value, "Team: Calendar")
    }
}
