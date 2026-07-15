import Foundation

public enum ICValidationError: Equatable {
    case missingProductIdentifier
    case missingEventDateStamp(uid: String)
    case missingEventUID
    case mutuallyExclusiveEventDateEndAndDuration(uid: String)
}
