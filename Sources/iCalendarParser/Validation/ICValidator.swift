import Foundation

public struct ICValidator {
    public init() {}

    public func validate(
        _ calendar: ICalendar
    ) -> [ICValidationError] {
        var errors = [ICValidationError]()

        if calendar.productId.parameters.isEmpty {
            errors.append(.missingProductIdentifier)
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

        if event.dtEnd != nil, event.duration != nil {
            errors.append(.mutuallyExclusiveEventDateEndAndDuration(uid: event.uid))
        }

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
}
