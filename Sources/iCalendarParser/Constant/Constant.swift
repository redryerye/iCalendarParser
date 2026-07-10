import Foundation

// MARK: - Public

public enum Constant {

    public enum Component {
        public static let alarm = "VALARM"
        public static let daylight = "DAYLIGHT"
        public static let event = "VEVENT"
        public static let timeZone = "VTIMEZONE"
        public static let standard = "STANDARD"
    }

    public enum ICalSpec {
        public static let defaultCalScale: String = "GREGORIAN"
        public static let version: String = "2.0"
    }
}

// MARK: - Internal

extension Constant {

    enum Property {
        static let begin: String = "BEGIN"
        static let end: String = "END"

        static let date: String = "DATE"
        static let value: String = "VALUE"

        static let calScale = "CALSCALE"
        static let method = "METHOD"
        static let prodid = "PRODID"
        static let version = "VERSION"

        // TimeZone
        static let tzId: String = "TZID"
        static let tzName: String = "TZNAME"
        static let tzOffsetFrom: String = "TZOFFSETFROM"
        static let tzOffsetTo: String = "TZOFFSETTO"

        // Recurrence Rule
        static let frequency = "FREQ"
        static let interval = "INTERVAL"
        static let until = "UNTIL"
        static let count = "COUNT"
        static let bySecond = "BYSECOND"
        static let byMinute = "BYMINUTE"
        static let byHour = "BYHOUR"
        static let byDay = "BYDAY"
        static let byDayOfMonth = "BYMONTHDAY"
        static let byDayOfYear = "BYYEARDAY"
        static let byWeekOfYear = "BYWEEKNO"
        static let byMonth = "BYMONTH"
        static let bySetPos = "BYSETPOS"
        static let startOfWorkweek = "WKST"

        // Attendee
        static let attendee = "ATTENDEE"
        static let cuType = "CUTYPE"
        static let role = "ROLE"
        static let partstat = "PARTSTAT"
        static let rsvp = "RSVP"
        static let cname = "CN"

        static let attachment: String = "ATTACH"
        static let categories: String = "CATEGORIES"
        static let created: String = "CREATED"
        static let classification: String = "CLASS"
        static let description: String = "DESCRIPTION"
        static let dtStart: String = "DTSTART"
        static let dtEnd: String = "DTEND"
        static let dtStamp: String = "DTSTAMP"
        static let duration: String = "DURATION"
        static let exceptionDates: String = "EXDATE"
        static let geoPosition: String = "GEO"
        static let lastModified: String = "LAST-MODIFIED"
        static let location: String = "LOCATION"
        static let organizer: String = "ORGANIZER"
        static let priority: String = "PRIORITY"
        static let recurrenceDates: String = "RDATE"
        static let recurrenceId: String = "RECURRENCE-ID"
        static let recurrenceRule: String = "RRULE"
        static let sequence: String = "SEQUENCE"
        static let status: String = "STATUS"
        static let summary: String = "SUMMARY"
        static let timeTransparency: String = "TRANSP"
        static let tzUrl: String = "TZURL"
        static let uid: String = "UID"
        static let url: String = "URL"
    }

    enum ProductId {
        static let companyName: String = "Aria Inc"
        static let productName: String = "ICalendarParser"
        static let language: String = "EN"
    }

    enum Frequency {
        static let secondly: String = "SECONDLY"
        static let minutely: String = "MINUTELY"
        static let hourly: String = "HOURLY"
        static let daily: String = "DAILY"
        static let weekly: String = "WEEKLY"
        static let monthly: String = "MONTHLY"
        static let yearly: String = "YEARLY"
    }

    enum DayOfWeek {
        static let monday = "MO"
        static let tuesday = "TU"
        static let wednesday = "WE"
        static let thursday = "TH"
        static let friday = "FR"
        static let saturday = "SA"
        static let sunday = "SU"
    }

    enum PartStat {
        static let needsAction = "NEEDS-ACTION"
        static let accepted = "ACCEPTED"
        static let declined = "DECLINED"
        static let tenative = "TENTATIVE"
    }

}
