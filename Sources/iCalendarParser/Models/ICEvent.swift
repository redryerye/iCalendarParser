import Foundation

/// A grouping of component properties that describe an
///
/// See more in [RFC 5545](https://www.rfc-editor.org/rfc/rfc5545#section-3.6.1)
public struct ICEvent: ICComponentable {

    // MARK: - ICComponentable

    let type: ICComponentType = .event

    // MARK: - Properties

    /// This property defines an "Attendee" within a calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.4.1)
    public var attendees: [ICAttendee]?

    // Provides the capability to associate a document object with a calendar component.
    //
    // See more in [RFC 5545](
    // https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.1))
    // var attachment: [ICAttachment]?

     public var categories: [String]?

    /// Defines the access classification for a calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.3)
    public var classification: String?

    // var comment: [String]?

    // var contact: [String]?

    /// Provides a more complete description of the calendar component
    /// than that provided by the "SUMMARY" property.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.5)
    public var description: String?

    /// Specifies the date and time that the calendar information was created by the
    /// calendar user agent in the calendar store.
    /// 
    /// Note: This is analogous to the creation date and time for a file in the file system.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.7.1)
    public var dtCreated: Date?

    /// The date and time that a calendar component ends.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.2.2)
    public var dtEnd: ICDateTime?

    /**
     The calendar scale used for the calendar information specified in the iCalendar object.
     In the case of an iCalendar object that specifies a
     "METHOD" property, this property specifies the date and time that
     the instance of the iCalendar object was created.  In the case of
     an iCalendar object that doesn't specify a "METHOD" property, this
     property specifies the date and time that the information
     associated with the calendar component was last revised in the
     calendar
     
     See more in [RFC 5545](https://www.rfc-editor.org/rfc/rfc5545#section-3.8.7.2)
     */
    public var dtStamp: Date

    /// The start date and time for the event.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.2.4)
    public var dtStart: ICDateTime?

    // A positive duration of time.
    //
    // See more in [RFC 5545](
    // https://www.rfc-editor.org/rfc/rfc5545#section-3.8.2.5)
    // var duration: ICDuration?

    // The list of DATE-TIME exceptions for recurring events, to-dos, journal entries,
    // or time zone definitions.
    //
    // See more in [RFC 5545](
    // https://www.rfc-editor.org/rfc/rfc5545#section-3.8.5.1)
    // var exceptionDates: [Date]?

    // Specifies information related to the global position for the activity specified by
    // a calendar component.
    //
    // See more in [RFC 5545](
    // https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.6)
    // var geoPosition: [CGFloat]?

    /// Any property name with a "X-" prefix
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.8.2)
    public var nonStandardProperties: [String: String]?

    /// Specifies the date and time that the information associated with the calendar
    /// component was last revised in the calendar store.
    ///
    /// Note: This is analogous to the modification date and time for a file in the file system.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.7.3)
    public var lastModified: Date?

    /// Defines the intended venue for the activity defined by a calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.7)
    public var location: String?

    /// Defines the organizer for a calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.4.3)
    public var organizer: String?

    /// Defines the relative priority for a calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.9)
    public var priority: Int?

    /// This property is used in conjunction with the `UID` and `SEQUENCE` properties
    /// to identify a specific instance of a recurring `VEVENT`, `VTODO`, or `VJOURNAL`
    /// calendar component. The property value is the original value of the `DTSTART` property
    /// of the recurrence instance.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.4.4)
    public var recurrenceId: ICDateTime?

    // The list of DATE-TIME values for recurring events, to-dos, journal entries, or time zone definitions.
    //
    // See more in [RFC 5545](
    // https://www.rfc-editor.org/rfc/rfc5545#section-3.8.5.2)
    // var recurrenceDates: [ICDateTime]?

    // A rule or repeating pattern for recurring events, to-dos, journal entries, or time zone definitions.
    //
    // See more in [RFC 5545](
    // https://www.rfc-editor.org/rfc/rfc5545#section-3.8.5.3)
    public var recurrenceRule: ICRRule?

    // var relatedTo: [String]?

    // var requestStatus

    // var resources: [String]?

    /// Defines the revision sequence number of the  calendar component within a sequence of revisions.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.7.4)
    public var sequence: Int?

    /// Defines the overall status or confirmation for the calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.11)
    public var status: String?

    /// Defines a short summary or subject for the calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.12)
    public var summary: String?

    /// Defines whether or not an event is transparent to busy time searches.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.2.7)
    public var timeTransparency: String?

    /// Defines the persistent, globally unique identifier for the calendar component.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.4.7)
    public var uid: String

    /// Defines a Uniform Resource Locator (URL) associated with the iCalendar object.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.4.6)
    public var url: URL?

    public init(
        attendees: [ICAttendee]? = nil,
        categories: [String]? = nil,
        classification: String? = nil,
        description: String? = nil,
        dtCreated: Date? = nil,
        dtEnd: ICDateTime? = nil,
        dtStamp: Date = Date(),
        dtStart: ICDateTime? = nil,
        lastModified: Date? = nil,
        location: String? = nil,
        nonStandardProperties: [String: String]? = nil,
        organizer: String? = nil,
        priority: Int? = nil,
        recurrenceId: ICDateTime? = nil,
        sequence: Int? = nil,
        status: String? = nil,
        summary: String? = nil,
        timeTransparency: String? = nil,
        uid: String = UUID().uuidString,
        url: URL? = nil
    ) {
        self.attendees = attendees
        self.categories = categories
        self.classification = classification
        self.description = description
        self.dtCreated = dtCreated
        self.dtEnd = dtEnd
        self.dtStamp = dtStamp
        self.dtStart = dtStart
        self.lastModified = lastModified
        self.location = location
        self.nonStandardProperties = nonStandardProperties
        self.organizer = organizer
        self.priority = priority
        self.recurrenceId = recurrenceId
        self.sequence = sequence
        self.status = status
        self.summary = summary
        self.timeTransparency = timeTransparency
        self.uid = uid
        self.url = url
    }
}

extension ICEvent: Equatable {
    public static func == (lhs: ICEvent, rhs: ICEvent) -> Bool {
        lhs.uid == rhs.uid
    }
}
