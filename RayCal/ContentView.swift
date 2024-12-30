import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack {
                DayView(date: Date(), selectedDate: $selectedDate)
            }
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    ContentView()
}
