import Foundation

enum ICComponentType {

    case alarm
    case event
    case journal
    case timeZone

    var name: String {
        switch self {
        case .alarm:
            return Constant.Component.alarm
        case .event:
            return Constant.Component.event
        case .journal:
            return Constant.Component.journal
        case .timeZone:
            return Constant.Component.timeZone
        }
    }
}
