import Foundation

/// Provides the capability to associate a document object with a calendar component.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.1)
public struct ICAttachment: Equatable {
    public var formatType: String?
    public var url: URL?
    public var value: String

    public init(
        formatType: String? = nil,
        url: URL? = nil,
        value: String
    ) {
        self.formatType = formatType
        self.url = url
        self.value = value
    }
}
