import Foundation

public struct ICParameter: Equatable {
    public let name: String
    public let values: [String]

    public var value: String {
        values.joined(separator: ",")
    }

    public init(
        name: String,
        values: [String]
    ) {
        self.name = name
        self.values = values
    }
}
