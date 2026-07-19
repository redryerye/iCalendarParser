import Foundation

/// A grouping of component properties that describe a to-do.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.6.2)
public struct ICToDo: ICComponentable, Equatable {

    let type: ICComponentType = .todo

    public var description: String?
    public var dtStamp: Date?
    public var dtStart: ICDateTime?
    public var due: ICDateTime?
    public var percentComplete: Int?
    public var priority: Int?
    public var properties: [ICProperty]?
    public var status: String?
    public var summary: String?
    public var uid: String

    public init(
        description: String? = nil,
        dtStamp: Date? = nil,
        dtStart: ICDateTime? = nil,
        due: ICDateTime? = nil,
        percentComplete: Int? = nil,
        priority: Int? = nil,
        properties: [ICProperty]? = nil,
        status: String? = nil,
        summary: String? = nil,
        uid: String = ""
    ) {
        self.description = description
        self.dtStamp = dtStamp
        self.dtStart = dtStart
        self.due = due
        self.percentComplete = percentComplete
        self.priority = priority
        self.properties = properties
        self.status = status
        self.summary = summary
        self.uid = uid
    }
}
