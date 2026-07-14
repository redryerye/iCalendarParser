import Foundation

/// A period of time identified by a start and an end or duration.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.3.9)
public struct ICPeriod: Equatable {
    public var duration: ICDuration?
    public var end: ICDateTime?
    public var rawValue: String
    public var start: ICDateTime

    public init(
        duration: ICDuration? = nil,
        end: ICDateTime? = nil,
        rawValue: String,
        start: ICDateTime
    ) {
        self.duration = duration
        self.end = end
        self.rawValue = rawValue
        self.start = start
    }
}
