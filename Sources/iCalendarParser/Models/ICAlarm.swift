import Foundation

/// A grouping of component properties that describe an alarm.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.6.6)
public struct ICAlarm: ICComponentable, Equatable {

    let type: ICComponentType = .alarm

    public var action: String?
    public var description: String?
    public var duration: ICDuration?
    public var properties: [ICProperty]?
    public var repeatCount: Int?
    public var summary: String?
    public var trigger: String?

    public init(
        action: String? = nil,
        description: String? = nil,
        duration: ICDuration? = nil,
        properties: [ICProperty]? = nil,
        repeatCount: Int? = nil,
        summary: String? = nil,
        trigger: String? = nil
    ) {
        self.action = action
        self.description = description
        self.duration = duration
        self.properties = properties
        self.repeatCount = repeatCount
        self.summary = summary
        self.trigger = trigger
    }
}
