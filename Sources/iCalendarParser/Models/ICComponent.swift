import Foundation

struct ICComponent {
    let properties: [ICProperty]
    let childProperties: [ICProperty]

    var contentProperties: [ICProperty] {
        properties.filter {
            $0.baseName != Constant.Property.begin &&
                $0.baseName != Constant.Property.end
        }
    }

    /// Returns a property that matches the name
    func getProperty(
        name: String
    ) -> ICProperty? {
        return properties
            .filter { $0.baseName == name }
            .first
    }

    /// Returns a property that matches the name
    func getProperties(
        name: String
    ) -> [ICProperty]? {
        return properties
            .filter { $0.baseName == name }
    }

    // MARK: - Build property

    /// Returns `ICDateTime` from properties
    func buildProperty(
        of name: String
    ) -> ICDateTime? {
        guard let prop = getProperty(name: name) else {
            return nil
        }

        return PropertyBuilder.buildDateTime(from: prop)
    }

    /// Returns `String` from properties
    func buildProperty(
        of name: String
    ) -> String? {
        guard let prop = getProperty(name: name) else {
            return nil
        }

        return prop.value
    }

    /// Returns `Int` from properties
    func buildProperty(
        of name: String
    ) -> Int? {
        guard let prop = getProperty(name: name) else {
            return nil
        }

        return Int(prop.value)
    }

    /// Returns `ICRRule` from properties
    func buildProperty(
        of name: String
    ) -> ICRRule? {
        guard let prop = getProperty(name: name) else {
            return nil
        }

        return PropertyBuilder.buildRRule(from: prop)
    }

    /// Returns `ICDuration` from properties
    func buildProperty(
        of name: String
    ) -> ICDuration? {
        guard let prop = getProperty(name: name) else {
            return nil
        }

        return PropertyBuilder.buildDuration(from: prop)
    }

    /// Returns `ICGeoPosition` from properties
    func buildProperty(
        of name: String
    ) -> ICGeoPosition? {
        guard let prop = getProperty(name: name) else {
            return nil
        }

        return PropertyBuilder.buildGeoPosition(from: prop)
    }

    /// Returns `URL` from URI properties
    func buildURI(
        of name: String
    ) -> URL? {
        guard let prop = getProperty(name: name) else {
            return nil
        }

        return ICURI(rawValue: prop.value)?.url
    }

    /// Returns `[Attendee]` from properties
    func buildAttendees(
        of name: String
    ) -> [ICAttendee]? {
        guard let props = getProperties(name: name) else {
            return nil
        }

        return PropertyBuilder.buildAttendees(from: props)
    }

    /// Returns `[ICAttachment]` from properties
    func buildAttachments(
        of name: String
    ) -> [ICAttachment]? {
        guard let props = getProperties(name: name), !props.isEmpty else {
            return nil
        }

        return PropertyBuilder.buildAttachments(from: props)
    }

    /// Returns category TEXT values from all matching properties.
    func buildCategories(
        of name: String
    ) -> [String]? {
        guard let props = getProperties(name: name), !props.isEmpty else {
            return nil
        }

        return PropertyBuilder.buildCategories(from: props)
    }

    /// Returns date-time values from all matching properties.
    func buildDateTimes(
        of name: String
    ) -> [ICDateTime]? {
        guard let props = getProperties(name: name), !props.isEmpty else {
            return nil
        }

        let dateTimes = PropertyBuilder.buildDateTimes(from: props)
        return dateTimes.isEmpty ? nil : dateTimes
    }

    /// Returns request-status values from all matching properties.
    func buildRequestStatuses(
        of name: String
    ) -> [ICRequestStatus]? {
        guard let props = getProperties(name: name), !props.isEmpty else {
            return nil
        }

        let requestStatuses = props.compactMap { ICRequestStatus(rawValue: $0.value) }
        return requestStatuses.isEmpty ? nil : requestStatuses
    }

    /// Returns all non-standard properties if exists
    func getNonStandardProperties() -> [String: String]? {
        var dict = [String: String]()

        properties
            .filter { $0.name.hasPrefix("X-") }
            .forEach { dict[$0.name] = $0.value }

        guard !dict.isEmpty else {
            return nil
        }

        return dict
    }

    // MARK: - Private functions

    /// Returns a property that matches the name in the given properties
    private func getProperty(
        name: String,
        from elements: [ICProperty]
    ) -> ICProperty? {
        return elements
            .filter { $0.baseName == name }
            .first
    }
}
