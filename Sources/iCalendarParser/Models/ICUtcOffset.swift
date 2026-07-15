import Foundation

/// A signed offset from UTC.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.3.14)
public struct ICUtcOffset: Equatable {
    public var hours: Int
    public var isNegative: Bool
    public var minutes: Int
    public var rawValue: String
    public var seconds: Int?

    public var totalSeconds: Int {
        let total = hours * 3_600 + minutes * 60 + (seconds ?? 0)
        return isNegative ? -total : total
    }

    public init(
        hours: Int,
        isNegative: Bool = false,
        minutes: Int,
        rawValue: String,
        seconds: Int? = nil
    ) {
        self.hours = hours
        self.isNegative = isNegative
        self.minutes = minutes
        self.rawValue = rawValue
        self.seconds = seconds
    }

    public init?(
        rawValue: String
    ) {
        guard
            rawValue.count == 5 || rawValue.count == 7,
            let sign = rawValue.first,
            sign == "+" || sign == "-"
        else {
            return nil
        }

        let digits = rawValue.dropFirst()

        guard digits.allSatisfy(\.isNumber) else {
            return nil
        }

        let hourEnd = digits.index(digits.startIndex, offsetBy: 2)
        let minuteEnd = digits.index(hourEnd, offsetBy: 2)

        guard
            let hours = Int(digits[..<hourEnd]),
            let minutes = Int(digits[hourEnd..<minuteEnd]),
            (0...23).contains(hours),
            (0...59).contains(minutes)
        else {
            return nil
        }

        var seconds: Int?

        if rawValue.count == 7 {
            guard
                let parsedSeconds = Int(digits[minuteEnd...]),
                (0...59).contains(parsedSeconds)
            else {
                return nil
            }

            seconds = parsedSeconds
        }

        self.init(
            hours: hours,
            isNegative: sign == "-",
            minutes: minutes,
            rawValue: rawValue,
            seconds: seconds
        )
    }
}
