import Foundation

/// A positive or negative duration of time.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.3.6)
public struct ICDuration: Equatable {

    public var isNegative: Bool
    public var weeks: Int?
    public var days: Int?
    public var hours: Int?
    public var minutes: Int?
    public var seconds: Int?
    public var rawValue: String

    public init(
        isNegative: Bool = false,
        weeks: Int? = nil,
        days: Int? = nil,
        hours: Int? = nil,
        minutes: Int? = nil,
        seconds: Int? = nil,
        rawValue: String
    ) {
        self.isNegative = isNegative
        self.weeks = weeks
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.rawValue = rawValue
    }

    public init?(
        rawValue: String
    ) {
        var value = rawValue
        var isNegative = false

        if value.hasPrefix("+") || value.hasPrefix("-") {
            isNegative = value.hasPrefix("-")
            value.removeFirst()
        }

        guard value.hasPrefix("P") else {
            return nil
        }
        value.removeFirst()

        if let weeks = Self.parseWeeks(value) {
            self.init(isNegative: isNegative, weeks: weeks, rawValue: rawValue)
            return
        }

        guard let dateTime = Self.parseDateTime(value) else {
            return nil
        }

        self.init(
            isNegative: isNegative,
            days: dateTime.days,
            hours: dateTime.hours,
            minutes: dateTime.minutes,
            seconds: dateTime.seconds,
            rawValue: rawValue
        )
    }

    private struct DurationDateTime {
        var days: Int?
        var hours: Int?
        var minutes: Int?
        var seconds: Int?
    }

    private static func parseWeeks(
        _ value: String
    ) -> Int? {
        guard value.hasSuffix("W") else {
            return nil
        }

        let weekValue = String(value.dropLast())
        guard !weekValue.isEmpty else {
            return nil
        }

        return Int(weekValue)
    }

    private static func parseDateTime(
        _ value: String
    ) -> DurationDateTime? {
        let parts = value.components(separatedBy: "T")
        guard parts.count <= 2 else {
            return nil
        }

        let datePart = parts[0]
        let timePart = parts.count == 2 ? parts[1] : nil

        if parts.count == 2, timePart?.isEmpty == true {
            return nil
        }

        let days = parseDays(datePart)
        let time = parseTime(timePart)

        guard days != nil || time != nil else {
            return nil
        }

        return DurationDateTime(
            days: days,
            hours: time?.hours,
            minutes: time?.minutes,
            seconds: time?.seconds
        )
    }

    private static func parseDays(
        _ value: String
    ) -> Int? {
        guard !value.isEmpty else {
            return nil
        }

        guard value.hasSuffix("D") else {
            return nil
        }

        let dayValue = String(value.dropLast())
        guard !dayValue.isEmpty else {
            return nil
        }

        return Int(dayValue)
    }

    private static func parseTime(
        _ value: String?
    ) -> DurationDateTime? {
        guard let value, !value.isEmpty else {
            return nil
        }

        var remaining = value
        let hours = parseComponent("H", from: &remaining)
        let minutes = parseComponent("M", from: &remaining)
        let seconds = parseComponent("S", from: &remaining)

        guard remaining.isEmpty, hours != nil || minutes != nil || seconds != nil else {
            return nil
        }

        return DurationDateTime(hours: hours, minutes: minutes, seconds: seconds)
    }

    private static func parseComponent(
        _ designator: Character,
        from value: inout String
    ) -> Int? {
        var digits = ""

        while let character = value.first, character.isNumber {
            digits.append(character)
            value.removeFirst()
        }

        guard !digits.isEmpty else {
            return nil
        }

        guard value.first == designator else {
            value = digits + value
            return nil
        }

        value.removeFirst()
        return Int(digits)
    }
}
