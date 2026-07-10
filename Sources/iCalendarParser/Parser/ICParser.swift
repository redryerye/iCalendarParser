import Foundation

typealias ICProperty = (name: String, value: String)

public struct ICParser {

    public init() {}

    /// Parse strings to create ICalendar object. Returns nil if not found.
    public func calendar(
        from raw: String
    ) -> ICalendar? {

        let elements: [ICProperty] = getProperties(from: raw)

        guard
            let rawValue = getProperty(
                name: Constant.Property.prodid,
                from: elements
            )?.value
        else { return nil }

        let prodId = ICProductIdentifier(rawValue)

        // An iCalendar object MUST include the "PRODID"
        // https://www.rfc-editor.org/rfc/rfc5545#section-3.6)
        guard !prodId.parameters.isEmpty else {
            return nil
        }

        let method = getProperty(
            name: Constant.Property.method,
            from: elements
        )?.value

        let calendarScale = getProperty(
            name: Constant.Property.calScale,
            from: elements
        )?.value

        let eventComponents = getComponents(
            type: .event,
            from: elements
        )

        let timeZoneComponents = getComponents(
            type: .timeZone,
            from: elements
        )

        let events = buildEvents(from: eventComponents)
        let timeZones = buildTimeZones(from: timeZoneComponents)

        return ICalendar(
            calendarScale: calendarScale,
            events: events,
            method: method,
            productId: prodId,
            timeZones: timeZones
        )
    }

    func getProperties(from ics: String) -> [ICProperty] {
        // Normalize line endings to \n
        let normalizedICS = ics
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
        // Replace line folding sequences
        let unfoldedICS = normalizedICS.replacingOccurrences(of: "\n ", with: "")

        // Split by \n
        let properties: [ICProperty] = unfoldedICS
            .components(separatedBy: "\n")
            .map { $0.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true) }
            .filter { $0.count > 1 }
            .map { (String($0[0]), String($0[1])) }

        return properties
    }

    private func getProperty(
        name: String,
        from elements: [ICProperty]
    ) -> ICProperty? {
        elements
            .filter { $0.name.hasPrefix(name) }
            .first
    }

    private func getComponents(
        type: ICComponentType,
        from elements: [ICProperty]
    ) -> [ICComponent] {
        getComponents(name: type.name, from: elements)
    }

    private func getComponents(
        name: String,
        from elements: [ICProperty]
    ) -> [ICComponent] {

        var found = [ICComponent]()
        var currentComponent: [(String, String)]?
        var childComponent: [(String, String)]?

        for element in elements {
            if element.name == Constant.Property.begin,
                element.value == name {
                if currentComponent == nil {
                    currentComponent = []
                }
            }

            if currentComponent != nil {
                if element.name == Constant.Property.begin,
                   element.value != name,
                   childComponent == nil {
                    childComponent = []
                }

                if childComponent != nil {
                    childComponent?.append(element)
                } else {
                    currentComponent?.append(element)
                }
            }

            if element.name == Constant.Property.end,
               element.value == name {
                if let currentComponent = currentComponent {
                    let componentElement = ICComponent(
                        properties: currentComponent,
                        childProperties: childComponent ?? [])
                    found.append(componentElement)
                }
                currentComponent = nil
                childComponent = nil
            }
        }

        return found
    }

    // MARK: - Build functions

    private func buildEvents(
        from components: [ICComponent]
    ) -> [ICEvent] {

        return components.map { component -> ICEvent in
            var event = ICEvent()

            event.attendees = component.buildAttendees(of: Constant.Property.attendee)
            event.categories = component.buildProperty(of: Constant.Property.categories)?.components(separatedBy: ",")
            event.classification = component.buildProperty(of: Constant.Property.classification)
            event.description = component.buildProperty(of: Constant.Property.description)
            event.dtCreated = component.buildProperty(of: Constant.Property.created)?.date
            event.dtEnd = component.buildProperty(of: Constant.Property.dtEnd)
            event.dtStamp = component.buildProperty(of: Constant.Property.dtStamp)?.date ?? Date()
            event.dtStart = component.buildProperty(of: Constant.Property.dtStart)
            event.lastModified = component.buildProperty(of: Constant.Property.lastModified)?.date
            event.location = component.buildProperty(of: Constant.Property.location)
            event.organizer = component.buildProperty(of: Constant.Property.organizer)
            event.priority = component.buildProperty(of: Constant.Property.priority)
            event.recurrenceId = component.buildProperty(of: Constant.Property.recurrenceId)
            event.sequence = component.buildProperty(of: Constant.Property.sequence)
            event.status = component.buildProperty(of: Constant.Property.status)
            event.summary = component.buildProperty(of: Constant.Property.summary)
            event.timeTransparency = component.buildProperty(of: Constant.Property.timeTransparency)
            event.url = URL(string: component.buildProperty(of: Constant.Property.url) ?? "")
            event.uid = component.buildProperty(of: Constant.Property.uid) ?? ""
            event.recurrenceRule = component.buildProperty(of: Constant.Property.recurrenceRule)

            event.nonStandardProperties = component.getNonStandardProperties()

            return event
        }
    }

    private func buildTimeZones(
        from components: [ICComponent]
    ) -> [ICTimeZone] {
        return components.compactMap { component -> ICTimeZone? in
            guard
                let tzid = component.getProperty(
                    name: Constant.Property.tzId
                )?.value
            else { return nil }

            var standard: ICSubTimeZone?
            var daylight: ICSubTimeZone?

            let standardComponent = getComponents(
                name: Constant.Component.standard,
                from: component.childProperties
            ).first

            if let standardComponent,
               let standardSubTimeZone = buildSubTimeZone(from: standardComponent) {
                standard = standardSubTimeZone
            }

            let daylightComponent = getComponents(
                name: Constant.Component.daylight,
                from: component.childProperties
            ).first

            if let daylightComponent,
               let daylightSubTimeZone = buildSubTimeZone(from: daylightComponent) {
                daylight = daylightSubTimeZone
            }

            let nonStandardProperties = component.getNonStandardProperties()

            return ICTimeZone(
                daylight: daylight,
                nonStandardProperties: nonStandardProperties,
                standard: standard,
                timeZoneId: tzid
            )
        }
    }

    private func buildSubTimeZone(
        from component: ICComponent
    ) -> ICSubTimeZone? {
        guard
            let dtStartValue = component.getProperty(
                name: Constant.Property.dtStart
            )?.value,
            let timeZoneOffsetTo = component.getProperty(
                name: Constant.Property.tzOffsetTo
            )?.value,
            let timeZoneOffsetFrom = component.getProperty(
                name: Constant.Property.tzOffsetFrom
            )?.value
        else { return nil }

        guard
            let dtStart = PropertyBuilder.buildDateTime(
                from: (name: Constant.Property.dtStart, value: dtStartValue)
            )?.date
        else { return nil }

        let timeZoneName: String? = component.buildProperty(of: Constant.Property.tzName)
        let rRule: ICRRule? = component.buildProperty(of: Constant.Property.recurrenceRule)

        return ICSubTimeZone(
            dtStart: dtStart,
            recurrenceRule: rRule,
            timeZoneName: timeZoneName,
            timeZoneOffsetFrom: timeZoneOffsetFrom,
            timeZoneOffsetTo: timeZoneOffsetTo
        )
    }
}
