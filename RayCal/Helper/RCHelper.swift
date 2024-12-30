import SwiftUI

extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}


extension DateFormatter {
    static var utcHourMinFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        return formatter
    }
}


struct SampleView: View {
    var body: some View {
        Text("Hello, World!")
    }
}





