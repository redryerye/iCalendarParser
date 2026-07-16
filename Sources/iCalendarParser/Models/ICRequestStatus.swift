import Foundation

/// Defines the status code returned for a scheduling request.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.8.3)
public struct ICRequestStatus: Equatable {
    public var code: String
    public var description: String
    public var exceptionData: String?
    public var rawValue: String

    public init(
        code: String,
        description: String,
        exceptionData: String? = nil,
        rawValue: String
    ) {
        self.code = code
        self.description = description
        self.exceptionData = exceptionData
        self.rawValue = rawValue
    }

    public init?(
        rawValue: String
    ) {
        let components = rawValue.components(separatedBy: ";")

        guard components.count >= 2 else {
            return nil
        }

        self.init(
            code: components[0],
            description: components[1],
            exceptionData: components.dropFirst(2).isEmpty
                ? nil
                : components.dropFirst(2).joined(separator: ";"),
            rawValue: rawValue
        )
    }
}
