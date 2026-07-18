import Foundation

public struct ICValidator {
    public init() {}

    private let singleEventPropertyNames = [
        Constant.Property.classification,
        Constant.Property.created,
        Constant.Property.description,
        Constant.Property.dtEnd,
        Constant.Property.dtStamp,
        Constant.Property.dtStart,
        Constant.Property.duration,
        Constant.Property.geoPosition,
        Constant.Property.lastModified,
        Constant.Property.location,
        Constant.Property.organizer,
        Constant.Property.priority,
        Constant.Property.recurrenceId,
        Constant.Property.sequence,
        Constant.Property.status,
        Constant.Property.summary,
        Constant.Property.timeTransparency,
        Constant.Property.uid,
        Constant.Property.url
    ]

    public func validate(
        _ calendar: ICalendar
    ) -> [ICValidationError] {
        var errors = [ICValidationError]()

        if calendar.productId.parameters.isEmpty {
            errors.append(.missingProductIdentifier)
        }

        if calendar.version.isEmpty {
            errors.append(.missingCalendarVersion)
        }

        calendar.events.forEach { event in
            errors.append(contentsOf: validate(event))
        }

        return errors
    }

    public func validate(
        _ event: ICEvent
    ) -> [ICValidationError] {
        var errors = [ICValidationError]()

        if isMissingProperty(Constant.Property.uid, in: event) || event.uid.isEmpty {
            errors.append(.missingEventUID)
        }

        if isMissingProperty(Constant.Property.dtStamp, in: event) {
            errors.append(.missingEventDateStamp(uid: event.uid))
        }

        if isMissingProperty(Constant.Property.dtStart, in: event) {
            errors.append(.missingEventDateStart(uid: event.uid))
        }

        if event.dtEnd != nil, event.duration != nil {
            errors.append(.mutuallyExclusiveEventDateEndAndDuration(uid: event.uid))
        }

        errors.append(contentsOf: validateCardinality(event))

        return errors
    }

    private func isMissingProperty(
        _ name: String,
        in event: ICEvent
    ) -> Bool {
        guard let properties = event.properties else {
            return false
        }

        return !properties.contains { $0.baseName == name }
    }

    private func validateCardinality(
        _ event: ICEvent
    ) -> [ICValidationError] {
        guard let properties = event.properties else {
            return []
        }

        return singleEventPropertyNames.compactMap { propertyName in
            let count = properties.filter { $0.baseName == propertyName }.count

            guard count > 1 else {
                return nil
            }

            return .duplicateEventProperty(uid: event.uid, propertyName: propertyName)
        }
    }
}
