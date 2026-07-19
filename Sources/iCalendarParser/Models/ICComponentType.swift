import Foundation

enum ICComponentType {

    case alarm
    case event
    case timeZone
    case todo

    var name: String {
        switch self {
        case .alarm:
            return Constant.Component.alarm
        case .event:
            return Constant.Component.event
        case .timeZone:
            return Constant.Component.timeZone
        case .todo:
            return Constant.Component.todo
        }
    }
}
