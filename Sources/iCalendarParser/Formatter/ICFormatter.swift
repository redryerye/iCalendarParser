import Foundation

public struct ICFormatter {
    static let maxLineLength = 75
    private static let continuationPrefix = " "

    public init() {}

    /// Formats an iCalendar object as valid `.ics` text.
    public static func format(
        _ calendar: ICalendar
    ) -> String {
        var lines = [
            "BEGIN:VCALENDAR",
            "VERSION:\(calendar.version)",
            "PRODID:\(calendar.productId.raw)"
        ]

        appendTextLine("CALSCALE", calendar.calendarScale, to: &lines)
        appendTextLine("METHOD", calendar.method, to: &lines)

        calendar.events.forEach { event in
            lines.append(contentsOf: formatEvent(event))
        }

        lines.append("END:VCALENDAR")
        return foldLines(lines)
    }

    /// Returns a configured `DateFormatter` based on `ICDateTimeType`
    static func dateFormatter(
        type: DateTimeType,
        tzid: String? = nil
    ) -> DateFormatter {
        let formatter = DateFormatter()

        if let tzid {
            formatter.timeZone = TimeZone(identifier: tzid)
        } else if type == .date {
            formatter.timeZone = .current
        } else {
            formatter.timeZone = TimeZone(abbreviation: "UTC")
        }

        formatter.dateFormat = {
            switch type {
            case .date:
                return "yyyyMMdd"
            case .dateTime:
                return tzid == nil
                    ? "yyyyMMdd'T'HHmmss'Z'"
                    : "yyyyMMdd'T'HHmmss"
            }
        }()

        return formatter
    }

    /// Folds an iCalendar content line to the RFC 5545 line length limit.
    ///
    /// Continuation lines begin with a single space.
    static func foldLine(
        _ line: String
    ) -> String {
        guard line.utf8.count > maxLineLength else {
            return line
        }

        var lines = [String]()
        var currentLine = ""
        var currentLineLength = 0
        var currentLimit = maxLineLength

        for character in line {
            let characterLength = String(character).utf8.count

            if !currentLine.isEmpty,
               currentLineLength + characterLength > currentLimit {
                lines.append(currentLine)
                currentLine = String(character)
                currentLineLength = characterLength
                currentLimit = maxLineLength - continuationPrefix.utf8.count
            } else {
                currentLine.append(character)
                currentLineLength += characterLength
            }
        }

        lines.append(currentLine)

        return lines
            .enumerated()
            .map { index, line in
                index == 0 ? line : continuationPrefix + line
            }
            .joined(separator: "\r\n")
    }

    static func foldLines(
        _ lines: [String]
    ) -> String {
        lines.map(foldLine).joined(separator: "\r\n")
    }

    /// Escapes a TEXT value for iCalendar serialization.
    public static func escapeTextValue(
        _ value: String
    ) -> String {
        let normalizedValue = value
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
        var escaped = ""

        for character in normalizedValue {
            switch character {
            case "\\":
                escaped.append("\\\\")
            case ";":
                escaped.append("\\;")
            case ",":
                escaped.append("\\,")
            case "\n":
                escaped.append("\\n")
            default:
                escaped.append(character)
            }
        }

        return escaped
    }

    private static func formatEvent(
        _ event: ICEvent
    ) -> [String] {
        var lines = ["BEGIN:VEVENT"]

        appendTextLine("UID", event.uid, to: &lines)
        lines.append("DTSTAMP:\(DateTimeType.dateTime.dateFormatter().string(from: event.dtStamp))")
        appendDateTimeLine("DTSTART", event.dtStart, to: &lines)
        appendDateTimeLine("DTEND", event.dtEnd, to: &lines)
        appendRawLine("DURATION", event.duration?.rawValue, to: &lines)
        appendTextLine("SUMMARY", event.summary, to: &lines)
        appendTextLine("DESCRIPTION", event.description, to: &lines)
        appendTextLine("LOCATION", event.location, to: &lines)
        appendTextLine("CLASS", event.classification, to: &lines)
        appendTextLine("STATUS", event.status, to: &lines)
        appendTextLine("TRANSP", event.timeTransparency, to: &lines)
        appendIntegerLine("PRIORITY", event.priority, to: &lines)
        appendIntegerLine("SEQUENCE", event.sequence, to: &lines)
        appendTextListLine("CATEGORIES", event.categories, to: &lines)
        appendTextListLines("COMMENT", event.comments, to: &lines)
        appendTextListLines("CONTACT", event.contacts, to: &lines)
        appendTextListLines("RESOURCES", event.resources, to: &lines)
        appendDateTimeLines("EXDATE", event.exceptionDates, to: &lines)
        appendDateTimeLines("RDATE", event.recurrenceDates, to: &lines)
        appendRawLine("URL", event.url?.absoluteString, to: &lines)

        lines.append("END:VEVENT")
        return lines
    }

    private static func appendTextLine(
        _ name: String,
        _ value: String?,
        to lines: inout [String]
    ) {
        guard let value else {
            return
        }

        lines.append("\(name):\(escapeTextValue(value))")
    }

    private static func appendRawLine(
        _ name: String,
        _ value: String?,
        to lines: inout [String]
    ) {
        guard let value else {
            return
        }

        lines.append("\(name):\(value)")
    }

    private static func appendTextListLine(
        _ name: String,
        _ values: [String]?,
        to lines: inout [String]
    ) {
        guard let values, !values.isEmpty else {
            return
        }

        lines.append("\(name):\(values.map(escapeTextValue).joined(separator: ","))")
    }

    private static func appendTextListLines(
        _ name: String,
        _ values: [String]?,
        to lines: inout [String]
    ) {
        values?.forEach { value in
            appendTextLine(name, value, to: &lines)
        }
    }

    private static func appendIntegerLine(
        _ name: String,
        _ value: Int?,
        to lines: inout [String]
    ) {
        guard let value else {
            return
        }

        lines.append("\(name):\(value)")
    }

    private static func appendDateTimeLine(
        _ name: String,
        _ value: ICDateTime?,
        to lines: inout [String]
    ) {
        guard let value else {
            return
        }

        lines.append(dateTimeLine(name, value))
    }

    private static func appendDateTimeLines(
        _ name: String,
        _ values: [ICDateTime]?,
        to lines: inout [String]
    ) {
        values?.forEach { value in
            lines.append(dateTimeLine(name, value))
        }
    }

    private static func dateTimeLine(
        _ name: String,
        _ value: ICDateTime
    ) -> String {
        var propertyName = name

        if value.type == .date {
            propertyName += ";VALUE=DATE"
        } else if let tzId = value.tzId {
            propertyName += ";TZID=\(tzId)"
        }

        return "\(propertyName):\(value.type.dateFormatter(tzId: value.tzId).string(from: value.date))"
    }
}
