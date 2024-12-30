import SwiftUI

struct RCAppointmentView: View {
    
    var appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(appointment.appointmentTitle)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Text("Start Time:")
                    .fontWeight(.semibold)
                Text(DateFormatter.utcHourMinFormatter.string(from: appointment.startDateTime))
            }

            HStack {
                Text("Location:")
                    .fontWeight(.semibold)
                Text("location")
            }

            HStack {
                Text("Patient:")
                    .fontWeight(.semibold)
                Text("patientName")
            }

            HStack {
                Text("Doctor:")
                    .fontWeight(.semibold)
                Text("doctorName")
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
    }
}
