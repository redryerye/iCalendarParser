import Foundation

public struct ICTimeZone: ICComponentable {

    // MARK: - ICComponentable

    let type: ICComponentType = .timeZone

    // MARK: - Properties

    public var daylight: ICSubTimeZone?

    /// Any property name with a "X-" prefix
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.8.2)
    public var nonStandardProperties: [String: String]?

    /// Any property with an "X-" prefix, including parameters.
    public var nonStandardPropertyDetails: [ICProperty]?

    public var standard: ICSubTimeZone?

    /// Specifies the text value that uniquely identifies the "VTIMEZONE" calendar
    /// component in the scope of an iCalendar object.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.3.1)
    public var timeZoneId: String

    /// Provides a means for a "VTIMEZONE" component to point to a network
    /// location that can be used to retrieve an up-to-date version of itself.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.3.5)
    public var timeZoneUrl: URL?

    public init(
        daylight: ICSubTimeZone? = nil,
        nonStandardProperties: [String: String]? = nil,
        nonStandardPropertyDetails: [ICProperty]? = nil,
        standard: ICSubTimeZone? = nil,
        timeZoneId: String,
        timeZoneUrl: URL? = nil
    ) {
        self.daylight = daylight
        self.nonStandardProperties = nonStandardProperties
        self.nonStandardPropertyDetails = nonStandardPropertyDetails
        self.standard = standard
        self.timeZoneId = timeZoneId
        self.timeZoneUrl = timeZoneUrl

        assert(standard != nil || daylight != nil, "Either standard or daylight timezone should be set")
    }
}

extension ICTimeZone: Equatable {
    public static func == (lhs: ICTimeZone, rhs: ICTimeZone) -> Bool {
        lhs.timeZoneId == rhs.timeZoneId
    }
}
