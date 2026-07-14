import Foundation

/// Specifies information related to the global position for the activity.
///
/// See more in [RFC 5545](
/// https://www.rfc-editor.org/rfc/rfc5545#section-3.8.1.6)
public struct ICGeoPosition: Equatable {
    public var latitude: Double
    public var longitude: Double

    public init(
        latitude: Double,
        longitude: Double
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
