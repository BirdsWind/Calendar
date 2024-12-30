import Foundation

@MainActor // Ensures all @Published properties are updated on the main thread
class RCViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    
    var overlappedAppointments: [String: Int] = [:]
  
    init() {
        Task {
            await loadAppointments()
        }
    }
    
    func loadAppointments() async {
        guard let url = Bundle.main.url(forResource: "appointments", withExtension: "json") else {
            print("Failed to locate file in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedAppointments = try JSONDecoder().decode([Appointment].self, from: data)
            let sortedAppointments = decodedAppointments.sorted { $0.startDateTime < $1.startDateTime }
            self.overlappedAppointments = calculateOverlaps(sortedAppointments)
            self.appointments = sortedAppointments
        } catch {
            print("Failed to load or decode JSON")
        }
        
    }
    
    
    func calculateOverlaps(_ appointments: [Appointment]) -> [String: Int] {
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
        
        print(overlapMap)
        return overlapMap
        
    }
}

