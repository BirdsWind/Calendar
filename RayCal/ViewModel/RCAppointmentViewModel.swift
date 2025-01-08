import Combine
import Foundation

@MainActor
class RCAppointmentViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var locations: [Location] = []
    @Published var users: [User] = []
    @Published var appointmentDetail: AppointmentDetail?
    @Published var error: Error?
    @Published var isLoading = false
    private var hasLoaded = false
    private var dataLoader: RCDataLoader = .shared
    private let appointment: Appointment
    
    init(appointment: Appointment) {
        self.appointment = appointment
        Task {
            await loadAllData() // Asynchronous call
        }
    }
    
    func loadAllData() async {
        guard !hasLoaded else { return } // Ensure data is only loaded once.
        hasLoaded = true
        isLoading = true
        error = nil
        
        do {
            async let rUsers = dataLoader.loadUsers()
            async let rPatients = dataLoader.loadPatients()
            async let rLocations = dataLoader.loadLocations()
            
            // Wait for all tasks to complete and assign results
            (users, patients, locations) = try await (rUsers, rPatients, rLocations)
            composeAppointmentDetail()
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    /// Compose the detail from loaded data
    private func composeAppointmentDetail() {
        let patient = patients.first(where: { $0.id == appointment.patient })
        let location = locations.first(where: { $0.id == appointment.location })
        let user = users.first(where: { $0.id == appointment.rayCareUsers.first })
        
        self.appointmentDetail = AppointmentDetail(
            id: appointment.id,
            patientName: patient?.fullName,
            locationName: location?.name,
            userName: user?.fullName,
            startTime: appointment.startDateTime,
            duration: appointment.durationInMinutes,
            title: appointment.appointmentTitle
        )
    }
}

struct AppointmentDetail {
    let id: String
    let patientName: String?
    let locationName: String?
    let userName: String?
    let startTime: Date
    let duration: Int
    let title: String
}
