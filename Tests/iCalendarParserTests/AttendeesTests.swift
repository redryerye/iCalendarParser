import XCTest
@testable import iCalendarParser

final class AttendeesTests: XCTestCase {
    func testBuildAttendees() {
        let propertyName1 = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=\
        ACCEPTED;RSVP=TRUE;CN=test@example.com;X-NUM-GUESTS=0
        """

        let attendee1 = ICProperty(
            propertyName1,
            "mailto:test@example.com"
        )

        let propertyName2 = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=\
        NEEDS-ACTION;RSVP=TRUE;CN=test2@example.com;X-NUM-GUESTS=0
        """
        let attendee2 = ICProperty(
            propertyName2,
            "mailto:test2@example.com"
        )
        let attendees = PropertyBuilder.buildAttendees(from: [attendee1, attendee2])

        XCTAssertNotNil(attendees)
        XCTAssertEqual(attendees?.count, 2)
    }

    func testAttendeeEmail() {
        let propertyName = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;\
        RSVP=TRUE;CN=test@example.com;X-NUM-GUESTS=0
        """
        let property = ICProperty(
            propertyName,
            "mailto:test@example.com"
        )

        let attendee = PropertyBuilder.buildAttendees(from: [property])?.first

        XCTAssertNotNil(attendee?.email)

        guard let email = attendee?.email else { return }

        XCTAssertTrue(!email.contains("mailto:"))
    }

    func testAttendeeNonstandardProperties() {
        let propertyName = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;\
        RSVP=TRUE;CN=test@example.com;X-NUM-GUESTS=0
        """
        let property = ICProperty(
            propertyName,
            "mailto:test@example.com"
        )

        let attendee = PropertyBuilder.buildAttendees(from: [property])?.first

        XCTAssertNotNil(attendee?.nonStandardProperties)

        guard let nonStandardProperties = attendee?.nonStandardProperties else { return }

        XCTAssertNotEqual(nonStandardProperties.count, 0)

        XCTAssertTrue(nonStandardProperties.keys.contains("X-NUM-GUESTS"))
        XCTAssertTrue(nonStandardProperties.keys.contains("CUTYPE"))
        XCTAssertTrue(nonStandardProperties.keys.contains("ROLE"))
        XCTAssertTrue(nonStandardProperties.keys.contains("RSVP"))
    }

    func testAttendeeParticipationStatus() {
        let propertyName = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;\
        RSVP=TRUE;CN=test@example.com;X-NUM-GUESTS=0
        """
        let property = ICProperty(
            propertyName,
            "mailto:test@example.com"
        )

        let attendee = PropertyBuilder.buildAttendees(from: [property])?.first

        XCTAssertNotNil(attendee?.participationStatus)

        guard let partstat = attendee?.participationStatus else { return }

        XCTAssertEqual(partstat, .accepted)
    }

    func testAttendeeExposesRoleRsvpAndParameters() throws {
        let propertyName = """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;\
        RSVP=TRUE;CN=test@example.com;X-NUM-GUESTS=0
        """
        let property = ICProperty(
            propertyName,
            "mailto:test@example.com"
        )

        let attendee = try XCTUnwrap(PropertyBuilder.buildAttendees(from: [property])?.first)

        XCTAssertEqual(attendee.cname, "test@example.com")
        XCTAssertEqual(attendee.participationStatus, .accepted)
        XCTAssertEqual(attendee.role, "REQ-PARTICIPANT")
        XCTAssertEqual(attendee.rsvp, true)
        XCTAssertEqual(attendee.parameters?.first(where: { $0.name == "ROLE" })?.value, "REQ-PARTICIPANT")
        XCTAssertEqual(attendee.parameters?.first(where: { $0.name == "RSVP" })?.value, "TRUE")
    }
}
