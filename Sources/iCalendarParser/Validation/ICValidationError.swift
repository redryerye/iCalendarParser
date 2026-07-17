import Foundation

public enum ICValidationError: Equatable {
    case missingProductIdentifier
    case missingCalendarVersion
    case missingEventDateStamp(uid: String)
    case missingEventDateStart(uid: String)
    case missingEventUID
    case mutuallyExclusiveEventDateEndAndDuration(uid: String)
}
