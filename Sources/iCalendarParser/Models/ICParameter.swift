import Foundation

struct ICParameter: Equatable {
    let name: String
    let values: [String]

    var value: String {
        values.joined(separator: ",")
    }

    init(
        name: String,
        values: [String]
    ) {
        self.name = name
        self.values = values
    }
}
