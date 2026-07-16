import Foundation

struct ICFormatter {
    static let maxLineLength = 75
    private static let continuationPrefix = " "

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
}
