import SwiftUI

struct RCAppointmentDetailView: View {
    @StateObject private var viewModel: RCAppointmentViewModel

    init(appointment: Appointment) {
        _viewModel = StateObject(wrappedValue: RCAppointmentViewModel(
            appointment: appointment
        ))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView {Text("Loading...")}
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    Task { await viewModel.loadAllData() } // Retry action
                }
            } else if let detail = viewModel.appointmentDetail {
                AppointmentDetailView(detail: detail)
            } else {
                Text("No appointment details available.")
            }
        }
        .padding()
    }
}

struct AppointmentDetailView: View {
    let detail: AppointmentDetail

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                Text(detail.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)

                // Details Card
                VStack(alignment: .leading, spacing: 16) {
                    AppointmentDetailRow(label: "Start Time:", value: DateFormatter.utcHourMinFormatter.string(from: detail.startTime))
                    AppointmentDetailRow(label: "Location:", value: detail.locationName ?? "")
                    AppointmentDetailRow(label: "Patient:", value: detail.patientName ?? "")
                    AppointmentDetailRow(label: "RayCare User:", value: detail.userName ?? "")
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange, lineWidth: 2) // Colored frame for the card
                )
            }
            .padding()
        }
    }
}

// A reusable row component for appointment details
struct AppointmentDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}


struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Something went wrong")
                .font(.title)
                .foregroundColor(.red)

            Text(error.localizedDescription)
                .multilineTextAlignment(.center)

            Button(action: retryAction) {
                Text("Retry")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
