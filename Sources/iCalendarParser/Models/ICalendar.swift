import Foundation

/// A collection ofcalendaring and scheduling information
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.4)
public struct ICalendar {

    var components: [ICComponentable] {
        [events, freeBusy, timeZones]
            .compactMap { $0 as? [ICComponentable] }
            .flatMap { $0 }
    }

    // MARK: - Public properties

    /// Defines the calendar scale used for the calendar
    /// information specified in the iCalendar object.
    ///
    /// The default value is `"GREGORIAN"`.
    ///
    /// See more in [RFC 5545](
    /// https://www.rfc-editor.org/rfc/rfc5545#section-3.7.1)
    public var calendarScale: String?

    /// All the event components in the object
    public var events: [ICEvent]

    /// All the free/busy components in the object.
    public var freeBusy: [ICFreeBusy]

    /// iCalendar object method associated with the calendar object.
    ///
    /// See more in [RFC 5545
    /// ](https://www.rfc-editor.org/rfc/rfc5545#section-3.7.2)
    public var method: String?

    /// The identifier for the product that created the iCalendar object.
    ///
    /// See more in [RFC 5545
    /// ](https://www.rfc-editor.org/rfc/rfc5545#section-3.7.3)
    public var productId: ICProductIdentifier

    /// All the timezone components in the object.
    ///
    /// Multiple "VTIMEZONE" calendar components can exist in an iCalendar object.
    /// In this situation, each `VTIMEZONE` MUST represent a unique time zone definition.
    /// This is necessary for some classes of events, such as airline flights, that start in
    /// one time zone and end in another.
    public var timeZones: [ICTimeZone]

    /// Returns an event only when there is one event component
    public var uniqueEvent: ICEvent? {
        guard events.count == 1 else {
            return nil
        }
        return events.first
    }

    /// Returns a time zone only when there is one time zone component
    public var uniqueTimeZone: ICTimeZone? {
        guard timeZones.count == 1 else {
            return nil
        }
        return timeZones.first
    }

    /// The identifier corresponding to the highest version number or the minimum
    /// and maximum range of the iCalendar specification that is required in order to interpret the iCalendar object.
    ///
    /// The default version for this parser is 2.0
    ///
    /// See more in [RFC 5545
    /// ](https://www.rfc-editor.org/rfc/rfc5545#section-3.7.4)
    public var version: String

    public init(
        calendarScale: String? = Constant.ICalSpec.defaultCalScale,
        events: [ICEvent] = [],
        freeBusy: [ICFreeBusy] = [],
        method: String? = nil,
        productId: ICProductIdentifier,
        timeZones: [ICTimeZone] = [],
        version: String = Constant.ICalSpec.version
    ) {
        self.calendarScale = calendarScale
        self.events = events
        self.freeBusy = freeBusy
        self.method = method
        self.productId = productId
        self.timeZones = timeZones
        self.version = version
    }
}

extension ICalendar: Equatable {
    public static func == (lhs: ICalendar, rhs: ICalendar) -> Bool {
        lhs.calendarScale == rhs.calendarScale
        && lhs.events == rhs.events
        && lhs.freeBusy == rhs.freeBusy
        && lhs.method == rhs.method
        && lhs.productId == rhs.productId
        && lhs.timeZones == rhs.timeZones
        && lhs.version == rhs.version
    }
}
