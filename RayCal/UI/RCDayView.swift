import SwiftUI

struct DayView: View {
    let date: Date
    //Connect and share a value in two views, so the change in one can automatically update the other
    @Binding var selectedDate: Date
    
    @StateObject private var viewModel: RCDayViewModel = RCDayViewModel() // Bind the ViewModel to the View
    @State private var path: [Appointment] = [] // Navigation path
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                // Date headline
                HStack {
                    Text(date.formatted(.dateTime.day().month()))
                        .bold()
                    Text(date.formatted(.dateTime.year()))
                }
                .font(.title)
                Text(date.formatted(.dateTime.weekday(.wide)))
                
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Constants.startHour..<Constants.endHour) { hour in
                                HStack {
                                    Text("\(hour)")
                                        .font(.caption)
                                        .frame(width: 20, alignment: .trailing)
                                    Color.gray
                                        .frame(height: 1)
                                }
                                .frame(height: Constants.hourHeight)
                            }
                        }
                        
                        ForEach(viewModel.appointments) { appointment in
                            appointmentCell(appointment, overlapIndex: viewModel.overlappedAppointments[appointment.id] ?? 0)
                                .onTapGesture {
                                    path.append(appointment) // Navigate to the detail view
                                }
                        }
                    }
                }
            }
            .padding()
            .navigationDestination(for: Appointment.self) { appointment in
                RCAppointmentDetailView(appointment: appointment)
            }
        }
    }
    
    
    func appointmentCell(_ appointment: Appointment, overlapIndex: Int) -> some View {
        let duration = Double(appointment.durationInMinutes)
        let height = duration / Constants.minutes  * Constants.hourHeight
        let xOffset = Double(overlapIndex) * Constants.overlapSpacing // Adjust horizontal spacing for overlaps
        
        return  HStack {
            Text(DateFormatter.utcHourMinFormatter.string(from: appointment.startDateTime))
            Text("-")
            Text(DateFormatter.utcHourMinFormatter.string(from: appointment.endDateTime))
            Text(appointment.appointmentTitle).bold()
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.teal).opacity(0.5)
        )
        .offset(x: Constants.eventOffsetX + xOffset , y: yPosition(appointment: appointment)) // That is the center of the HStack
    }
    
    
    // Calculate the Y-position for a given time
    func yPosition(appointment: Appointment) -> CGFloat {
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Set to UTC 0
        
        let hour = calendar.component(.hour, from: appointment.startDateTime)
        let minute = calendar.component(.minute, from: appointment.startDateTime)
        let offset = Double(hour-Constants.startHour) * (Constants.hourHeight) + Double(minute)/Constants.minutes * (Constants.hourHeight)

        return  offset + Constants.hourHeight * 0.5
    }
}
