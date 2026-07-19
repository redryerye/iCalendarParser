import Foundation

enum ICComponentType {

    case alarm
    case event
    case freeBusy
    case timeZone

    var name: String {
        switch self {
        case .alarm:
            return Constant.Component.alarm
        case .event:
            return Constant.Component.event
        case .freeBusy:
            return Constant.Component.freeBusy
        case .timeZone:
            return Constant.Component.timeZone
        }
    }
}
