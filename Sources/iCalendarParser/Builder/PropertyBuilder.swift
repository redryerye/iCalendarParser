import Foundation

struct PropertyBuilder {

    // MARK: - Build functions

    static func buildDateTime(
        from prop: ICProperty
    ) -> ICDateTime? {
        let valueType = getDateTimeType(from: prop.parameters)
        let tzid = getTimeZoneId(from: prop.parameters)

        guard
            let date = valueType.dateFormatter(tzId: tzid).date(from: prop.value)
        else {
            return nil
        }

        switch valueType {
        case .date:
            return .date(from: date)
        default:
            return .dateTime(from: date, tzId: tzid)
        }
    }

    static func buildDateTimes(
        from props: [ICProperty]
    ) -> [ICDateTime] {
        props.flatMap { prop in
            prop.value
                .components(separatedBy: ",")
                .compactMap { value in
                    buildDateTime(from: ICProperty(prop.name, value))
                }
        }
    }

    static func buildDuration(
        from prop: ICProperty
    ) -> ICDuration? {
        ICDuration(rawValue: prop.value)
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func buildRRule(
        from prop: ICProperty
    ) -> ICRRule? {
        let params = getProperties(from: prop.value)
        let frequencyProperty = params
            .filter { $0.name == Constant.Property.frequency }
            .first

        guard
            let frequencyProperty = frequencyProperty,
            let frequency = ICRRule.Frequency(propertyName: frequencyProperty.value)
        else { return nil }

        var rule = ICRRule(frequency: frequency)

        params.forEach { property in
            switch property.name {
            case Constant.Property.interval:
                rule.interval = Int(property.value)
            case Constant.Property.until:
                rule.until = buildDateTime(from: property)
            case Constant.Property.count:
                rule.count = Int(property.value)
            case Constant.Property.bySecond:
                rule.bySecond = getIntComponents(from: property.value)
            case Constant.Property.byMinute:
                rule.byMinute = getIntComponents(from: property.value)
            case Constant.Property.byHour:
                rule.byHour = getIntComponents(from: property.value)
            case Constant.Property.byDay:
                rule.byDay = getDayComponents(from: property.value)
            case Constant.Property.byDayOfMonth:
                rule.byDayOfMonth = getIntComponents(from: property.value)
            case Constant.Property.byDayOfYear:
                rule.byDayOfYear = getIntComponents(from: property.value)
            case Constant.Property.byWeekOfYear:
                rule.byWeekOfYear = getIntComponents(from: property.value)
            case Constant.Property.byMonth:
                rule.byMonth = getIntComponents(from: property.value)
            case Constant.Property.bySetPos:
                rule.bySetPos = getIntComponents(from: property.value)
            case Constant.Property.startOfWorkweek:
                rule.startOfWorkweek = .init(propertyName: property.value)
            default:
                break
            }
        }

        return rule
    }

    static func buildAttendees(
        from props: [ICProperty]
    ) -> [ICAttendee]? {
        return props.map { prop -> ICAttendee in
            var attendee = ICAttendee()
            attendee.parameters = prop.parameters

            prop.parameters.forEach { parameter in
                switch parameter.name {
                case Constant.Property.cname:
                    attendee.cname = parameter.value
                case Constant.Property.partstat:
                    attendee.participationStatus = ParticipationStatus(rawValue: parameter.value)
                case Constant.Property.role:
                    attendee.role = parameter.value
                    if attendee.nonStandardProperties == nil {
                        attendee.nonStandardProperties = [:]
                    }
                    attendee.nonStandardProperties?[parameter.name] = parameter.value
                case Constant.Property.rsvp:
                    attendee.rsvp = parameter.value.uppercased() == "TRUE"
                    if attendee.nonStandardProperties == nil {
                        attendee.nonStandardProperties = [:]
                    }
                    attendee.nonStandardProperties?[parameter.name] = parameter.value
                default:
                    if attendee.nonStandardProperties == nil {
                        attendee.nonStandardProperties = [:]
                    }
                    attendee.nonStandardProperties?[parameter.name] = parameter.value
                }
            }

            attendee.email = prop.value.replacingOccurrences(of: "mailto:", with: "")
            return attendee
        }
    }

    static func buildAttachments(
        from props: [ICProperty]
    ) -> [ICAttachment] {
        props.map { prop in
            ICAttachment(
                formatType: prop.parameters.first {
                    $0.name == Constant.Property.formatType
                }?.value,
                url: URL(string: prop.value),
                value: prop.value
            )
        }
    }

    static func buildCategories(
        from props: [ICProperty]
    ) -> [String] {
        props.flatMap { splitTextList($0.value) }
    }

    // MARK: - Private functions

    /// Returns an array of params for the given value
    private static func getProperties(
        from value: String
    ) -> [ICProperty] {
        return ICProperty.split(value, separator: ";")
            .map { ICProperty.split($0, separator: "=", maxSplits: 1) }
            .filter { $0.count > 1 }
            .map { ICProperty($0[0], $0[1]) }
    }

    /// Returns `ICDateTimeType` from the given properties
    ///
    /// The default value is `.dateTime` if no property is found
    private static func getDateTimeType(
        from params: [ICParameter]
    ) -> DateTimeType {
        guard
            let valueType = params.first(where: {
                $0.name == Constant.Property.value
            })?.value
        else {
            return .dateTime
        }

        switch valueType {
        case Constant.Property.date:
            return .date
        default:
            return .dateTime
        }
    }

    /// Returns the ID for Timezone component
    private static func getTimeZoneId(
        from parameters: [ICParameter]
    ) -> String? {
        return parameters.first(where: {
            $0.name == Constant.Property.tzId
        })?.value
    }

    private static func getIntComponents(
        from value: String
    ) -> [Int] {
        value
            .components(separatedBy: ",")
            .compactMap { Int($0) }
    }

    private static func getDayComponents(
        from value: String
    ) -> [ICRRule.Day] {
        value
            .components(separatedBy: ",")
            .compactMap { .from($0) }
    }

    private static func splitTextList(
        _ value: String
    ) -> [String] {
        var result = [String]()
        var current = ""
        var isEscaped = false

        for character in value {
            if isEscaped {
                switch character {
                case "n", "N":
                    current.append("\n")
                case "\\", ",", ";":
                    current.append(character)
                default:
                    current.append("\\")
                    current.append(character)
                }
                isEscaped = false
            } else if character == "\\" {
                isEscaped = true
            } else if character == "," {
                result.append(current)
                current = ""
            } else {
                current.append(character)
            }
        }

        if isEscaped {
            current.append("\\")
        }
        result.append(current)

        return result
    }
}
