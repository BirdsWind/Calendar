import Foundation

@MainActor // Ensures all @Published properties are updated on the main thread
class RCDayViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var error: Error?
    @Published var isLoading = false
    var overlappedAppointments: [String: Int] = [:]
    private var hasLoaded = false
    private var dataLoader: RCDataLoader = .shared
  
    init() {
        Task {
            await loadAppointments()
        }
    }
    
    func loadAppointments() async {
        guard !hasLoaded else { return } // Ensure data is only loaded once.
        hasLoaded = true
        isLoading = true
        error = nil
        
        do {
            let rAppointments = try await dataLoader.loadAppointments()
            overlappedAppointments = calculateOverlaps(rAppointments)
            self.appointments = rAppointments
        } catch {
            self.error = error
        }
    }
    
    private func calculateOverlaps(_ appointments: [Appointment]) -> [String: Int] {
        var overlapMap: [String: Int] = [:]
        
        for (index, appointment) in appointments.enumerated() {
            if index == 0 {
                // First appointment, no overlap
                overlapMap[appointment.id] = 0
            } else {
                let previousAppointment = appointments[index - 1]
                
                // Check for overlap with the previous appointment
                if appointment.startDateTime < previousAppointment.endDateTime {
                    // Overlap detected, increase X-offset
                    overlapMap[appointment.id] = (overlapMap[previousAppointment.id] ?? 0) + 1
                } else {
                    // No overlap, reset X-offset
                    overlapMap[appointment.id] = 0
                }
            }
        }
        return overlapMap
    }
}
