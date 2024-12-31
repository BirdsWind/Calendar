import SwiftUI

struct RCAppointmentDetailView: View {
    
  
    @StateObject private var viewModel: RCAppointmentViewModel
    
    init(appointment: Appointment) {
        _viewModel = StateObject(wrappedValue: RCAppointmentViewModel(
            appointment: appointment
        ))
       
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.appointmentDetail?.title ?? "")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Text("Start Time:")
                    .fontWeight(.semibold)
                Text(DateFormatter.utcHourMinFormatter.string(from: viewModel.appointmentDetail?.startTime ?? Date()))
            }

            HStack {
                Text("Location:")
                    .fontWeight(.semibold)
                Text(viewModel.appointmentDetail?.locationName ?? " No location name")
            }

            HStack {
                Text("Patient:")
                    .fontWeight(.semibold)
                Text(viewModel.appointmentDetail?.patientName ?? " No patient name")
            }

            HStack {
                Text("RayCare User:")
                    .fontWeight(.semibold)
                Text(viewModel.appointmentDetail?.userName ?? "NO ray care user")
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
        .onAppear {
            viewModel.loadData()
        }
    }
}
