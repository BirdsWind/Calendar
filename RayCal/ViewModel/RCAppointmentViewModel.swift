import Combine
import Foundation

struct AppointmentDetail {
    let id: String
    let patientName: String?
    let locationName: String?
    let userName: String?
    let startTime: Date
    let duration: Int
    let title: String
}


@MainActor
class RCAppointmentViewModel: ObservableObject {
    
    @Published var appointmentDetail: AppointmentDetail?
    private var dataLoader: RCDataLoader = .shared
    
    private let appointment: Appointment
    private var cancellables: Set<AnyCancellable> = []
    
    init(appointment: Appointment) {
        self.appointment = appointment
        Task {
                await loadData() // Asynchronous call
            }
        self.observeDataLoader()
    }
    
    /// Observes changes in DataLoader's published properties
    private func observeDataLoader() {
        dataLoader.$patients
            .combineLatest(dataLoader.$users, dataLoader.$locations)
            .sink { [weak self] _, _, _ in
                    self?.composeDetail()
            }
            .store(in: &cancellables)
    }
    
    // Loads all data through the DataLoader
        func loadData() async {
            Task {
                // Trigger the DataLoader to fetch data
                await dataLoader.fetchData()
            }
        }


    
    
    /// Load data and compose the detail
    func fetchData()  {
        // Check if data is already loaded
        Task {
            if dataLoader.patients.isEmpty || dataLoader.locations.isEmpty || dataLoader.users.isEmpty {
                await dataLoader.fetchData()
            }
        }
    
    }
    
    /// Compose the detail from loaded data
    private func composeDetail() {
        let patient = dataLoader.patients.first(where: { $0.id == appointment.patient })
        let location = dataLoader.locations.first(where: { $0.id == appointment.location })
        let user = dataLoader.users.first(where: { $0.id == appointment.rayCareUsers.first })
        
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
    


