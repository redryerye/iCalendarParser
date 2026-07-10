import Foundation


extension Locale {
    static func is12HoursFormat() -> Bool {
        DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.range(of: "a") != nil
    }

    static func is24HoursFormat() -> Bool {
        !Self.is12HoursFormat()
    }

    func is12HoursFormat() -> Bool {
        DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: self)?.range(of: "a") != nil
    }

    func is24HoursFormat() -> Bool {
        !is12HoursFormat()
    }
}

public enum DateTimeType {
    case date
    case dateTime

    /// Returns a configured `DateFormatter`
    public func dateFormatter(
        tzId: String? = nil
    ) -> DateFormatter {
        let formatter = DateFormatter()

        if let tzId {
            formatter.timeZone = TimeZone(identifier: tzId)
        } else if self == .date {
            formatter.timeZone = .current
        } else {
            formatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        
        
        formatter.dateFormat = {
            switch self {
            case .date:
                return "yyyyMMdd"
            case .dateTime:
                return tzId == nil
                    ? "yyyyMMdd'T'HHmmss'Z'"
                    : "yyyyMMdd'T'HHmmss"
            }
        }()
        
        formatter.locale = {
            if Locale.is12HoursFormat() {
                return Locale(identifier: "en_US_POSIX")
            } else {
                return Locale.current
            }
        }()
        
        return formatter
    }
}
