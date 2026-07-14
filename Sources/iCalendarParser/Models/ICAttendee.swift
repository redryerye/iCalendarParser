/// This property defines an "Attendee" within a calendar component.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.4.1)
public struct ICAttendee {

    /// Common name
    public var cname: String?

    public var email: String?

    public var nonStandardProperties: [String: String]?

    /// Parsed parameters from the `ATTENDEE` property.
    public var parameters: [ICParameter]?

    /// Participation status of attendee
    public var participationStatus: ParticipationStatus?

    /// Expected participation role of attendee.
    public var role: String?

    /// RSVP expectation for attendee.
    public var rsvp: Bool?

    public init(
        cname: String? = nil,
        email: String? = nil,
        nonStandardProperties: [String: String]? = nil,
        parameters: [ICParameter]? = nil,
        participationStatus: ParticipationStatus? = nil,
        role: String? = nil,
        rsvp: Bool? = nil
    ) {
        self.cname = cname
        self.email = email
        self.nonStandardProperties = nonStandardProperties
        self.parameters = parameters
        self.participationStatus = participationStatus
        self.role = role
        self.rsvp = rsvp
    }
}
