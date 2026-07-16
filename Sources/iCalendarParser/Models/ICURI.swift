import Foundation

/// A URI value.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.3.13)
public struct ICURI: Equatable {
    public var rawValue: String
    public var url: URL

    public init?(
        rawValue: String
    ) {
        guard
            let url = URL(string: rawValue),
            url.scheme != nil
        else {
            return nil
        }

        self.rawValue = rawValue
        self.url = url
    }
}
