import SwiftUI

struct DayView: View {
    let date: Date
    @Binding var selectedDate: Date
    private let calendar = Calendar.current
    
    let hourHeight = 150.0
    
    @StateObject private var viewModel: RCViewModel = RCViewModel() // Bind the ViewModel to the View
    
    
    var body: some View {
        NavigationStack {
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
                            ForEach(7..<19) { hour in
                                HStack {
                                    Text("\(hour)")
                                        .font(.caption)
                                        .frame(width: 20, alignment: .trailing)
                                    Color.gray
                                        .frame(height: 1)
                                }
                                .frame(height: hourHeight)
                            }
                        }
                        
                        ForEach(viewModel.appointments) { appointment in
                            appointmentCell(appointment, overlapIndex: viewModel.overlappedAppointments[appointment.id] ?? 0)
                        }
                    }
                }
            }
            .padding()
        }
        
    }
    
    
    func appointmentCell(_ appointment: Appointment, overlapIndex: Int) -> some View {

        let duration = Double(appointment.durationInMinutes)
        let height = duration / 60  * hourHeight
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Set to UTC 0

        let hour = calendar.component(.hour, from: appointment.startDateTime)
        let minute = calendar.component(.minute, from: appointment.startDateTime)
        let offset = Double(hour-7) * (hourHeight) + Double(minute)/60 * (hourHeight)
        
        print(hour, minute, Double(hour-7) + Double(minute)/60 )
        
       

        let xOffset = Double(overlapIndex) * 70.0 // Adjust horizontal spacing for overlaps
        
        return NavigationLink(destination: RCAppointmentView(appointment: appointment)) {
            HStack {
                Text(DateFormatter.utcHourMinFormatter.string(from: appointment.startDateTime))
                Text("-")
                Text(DateFormatter.utcHourMinFormatter.string(from: appointment.endDateTime))
                Text(appointment.appointmentTitle).bold()
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10) // Internal padding
            .frame(height: height, alignment: .top)
            .background(
                GeometryReader { geometry in
                    let frame = geometry.frame(in: .global)
                    Color.clear.onAppear {
                        print("navigation frame")
                        print(frame)
                    }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.random()).opacity(0.5)
                }
               
                
            )
            .padding(.trailing, 30) // External padding
            //TODO: actually I don't know why 200 is needed?
            .position(x: 200 + xOffset, y: offset + hourHeight / 2) // Moves visual content
            .contentShape(Rectangle()) // Ensures the tappable area matches the visible content
            
        }
        .border(Color.red)
        .buttonStyle(PlainButtonStyle()) // Removes default link styling
    }
    
}

