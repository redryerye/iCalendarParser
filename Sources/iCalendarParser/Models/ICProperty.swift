import Foundation

public struct ICProperty: Equatable {
    public let name: String
    public let value: String
    public let parameters: [ICParameter]

    public var baseName: String {
        name.split(separator: ";", maxSplits: 1).first.map(String.init) ?? name
    }

    public init(
        _ name: String,
        _ value: String
    ) {
        self.name = name
        self.value = value
        self.parameters = Self.parameters(from: name)
    }

    private static func parameters(
        from name: String
    ) -> [ICParameter] {
        split(name, separator: ";")
            .dropFirst()
            .compactMap { parameter in
                let parts = split(parameter, separator: "=", maxSplits: 1)

                guard parts.count == 2 else {
                    return nil
                }

                return ICParameter(
                    name: parts[0],
                    values: split(parts[1], separator: ",").map(unquote)
                )
            }
    }

    static func split(
        _ value: String,
        separator: Character,
        maxSplits: Int = .max
    ) -> [String] {
        var result = [String]()
        var current = ""
        var isQuoted = false
        var splitCount = 0

        for character in value {
            if character == "\"" {
                isQuoted.toggle()
                current.append(character)
            } else if character == separator,
                      !isQuoted,
                      splitCount < maxSplits {
                result.append(current)
                current = ""
                splitCount += 1
            } else {
                current.append(character)
            }
        }

        result.append(current)
        return result
    }

    private static func unquote(
        _ value: String
    ) -> String {
        guard value.hasPrefix("\""), value.hasSuffix("\"") else {
            return value
        }

        return String(value.dropFirst().dropLast())
    }
}
