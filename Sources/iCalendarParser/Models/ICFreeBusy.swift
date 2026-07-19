import Foundation

/// A grouping of component properties that describe free/busy time.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.6.4)
public struct ICFreeBusy: ICComponentable, Equatable {

    let type: ICComponentType = .freeBusy

    public var dtEnd: ICDateTime?
    public var dtStamp: Date?
    public var dtStart: ICDateTime?
    public var freeBusy: [ICPeriod]?
    public var organizer: String?
    public var properties: [ICProperty]?
    public var uid: String
    public var url: URL?

    public init(
        dtEnd: ICDateTime? = nil,
        dtStamp: Date? = nil,
        dtStart: ICDateTime? = nil,
        freeBusy: [ICPeriod]? = nil,
        organizer: String? = nil,
        properties: [ICProperty]? = nil,
        uid: String = "",
        url: URL? = nil
    ) {
        self.dtEnd = dtEnd
        self.dtStamp = dtStamp
        self.dtStart = dtStart
        self.freeBusy = freeBusy
        self.organizer = organizer
        self.properties = properties
        self.uid = uid
        self.url = url
    }
}
