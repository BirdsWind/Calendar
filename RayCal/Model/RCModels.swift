import Foundation

struct Patient: Codable, Identifiable {
    let patientId: Int
    let firstName: String
    let lastName: String
    let id: String
    
    // Coding keys to map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case patientId = "PatientId"
        case firstName = "FirstName"
        case lastName = "LastName"
        case id = "Id"
    }
}


struct Appointment: Codable, Identifiable {
    let id: String
    let rayCareUsers: [String]
    let patient: String
    let location: String
    let startDateTime: Date
    let durationInMinutes: Int
    let appointmentTitle: String
    var endDateTime: Date { startDateTime.addingTimeInterval(Double(durationInMinutes * 60)) }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case rayCareUsers = "RayCareUsers"
        case patient = "Patient"
        case location = "Location"
        case startDateTime = "StartDateTime"
        case durationInMinutes = "DurationInMinutes"
        case appointmentTitle = "AppointmentTitle"
    }
    
    // Custom Decoder for Date Parsing
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        rayCareUsers = try container.decode([String].self, forKey: .rayCareUsers)
        patient = try container.decode(String.self, forKey: .patient)
        location = try container.decode(String.self, forKey: .location)
        appointmentTitle = try container.decode(String.self, forKey: .appointmentTitle)
        durationInMinutes = try container.decode(Int.self, forKey: .durationInMinutes)
        
        let calendar = Calendar.current
        
        
        // Parse StartDateTime as Date
        let startDateTimeString = try container.decode(String.self, forKey: .startDateTime)
        // Split the time string into components (hour, minute, second)
        let timeComponents = startDateTimeString.split(separator: ":").compactMap { Int($0) }
        
        // Parse the time directly into components
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Force UTC to avoid timezone shifts
        
        // Ensure the time string is valid
        if let parsedTime = timeFormatter.date(from: startDateTimeString) {
            
            // Extract the time components from the parsed time
            let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: parsedTime)
            
            // Get today's date components
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            
            
            // Combine today's date with the parsed time components
            var combinedComponents = todayComponents
            combinedComponents.hour = timeComponents.hour
            combinedComponents.minute = timeComponents.minute
            combinedComponents.second = timeComponents.second
            
            // Create the final date
            if let finalDate = calendar.date(from: combinedComponents) {
                startDateTime = finalDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .startDateTime, in: container, debugDescription: "Invalid date format")
            }
        } else {
            throw DecodingError.dataCorruptedError(forKey: .startDateTime, in: container, debugDescription: "Invalid date format")
        }
    }
}
