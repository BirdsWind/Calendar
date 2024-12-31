import SwiftUI


extension DateFormatter {
    static var utcHourMinFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        return formatter
    }
}






