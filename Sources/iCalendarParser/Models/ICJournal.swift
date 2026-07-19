import Foundation

/// A grouping of component properties that describe a journal entry.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.6.3)
public struct ICJournal: ICComponentable, Equatable {

    let type: ICComponentType = .journal

    public var description: String?
    public var dtStamp: Date?
    public var dtStart: ICDateTime?
    public var properties: [ICProperty]?
    public var status: String?
    public var summary: String?
    public var uid: String

    public init(
        description: String? = nil,
        dtStamp: Date? = nil,
        dtStart: ICDateTime? = nil,
        properties: [ICProperty]? = nil,
        status: String? = nil,
        summary: String? = nil,
        uid: String = ""
    ) {
        self.description = description
        self.dtStamp = dtStamp
        self.dtStart = dtStart
        self.properties = properties
        self.status = status
        self.summary = summary
        self.uid = uid
    }
}
