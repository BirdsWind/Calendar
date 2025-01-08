import SwiftUI

extension DateFormatter {
    static var utcHourMinFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        return formatter
    }
    
    static var utcHourMinSecFormatter: DateFormatter {
         let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) 
        return formatter
    }
}

enum DataType {
    case user
    case location
    case patient
    case appointment
    
    var fileName: String {
        switch self {
        case .appointment: return "appointments"
        case .user: return "users"
        case .location: return "locations"
        case .patient: return "patients"
        }
    }
}

struct Constants {
    static let hourHeight: CGFloat = 150.0
    static let startHour: Int = 7
    static let endHour: Int = 19
    static let overlapSpacing: Double = 70.0
    static let minutes: Double = 60
    static let eventOffsetX: Double = 50.0
}
