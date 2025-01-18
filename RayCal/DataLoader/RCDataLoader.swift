import Foundation

class RCDataLoader: ObservableObject {
    
    // Singleton instance
    static let shared = RCDataLoader()
    
    // Private initializer to prevent exterval instantiation
    private init() {}
    
    private func fetchData(fileName: String) async throws -> Data {
        guard let rUrl = Bundle.main.url(forResource: fileName, withExtension: "json")
        else {
            throw URLError(.badURL)
        }
        do {
            return try Data(contentsOf: rUrl)
        } catch {
            throw URLError(.cannotDecodeContentData)
        }
    }
    
    private func load<T: Decodable>(fileName: String, type: T.Type) async throws -> T {
        do {
            let data = try await fetchData(fileName: fileName)
            return try JSONDecoder().decode(T.self, from: data)
        } catch is DecodingError {
            throw URLError(.cannotDecodeRawData)
        }
    }
    
    func loadAppointments() async throws -> [Appointment] {
        try await load(fileName: DataType.appointment.fileName, type: [Appointment].self)
    }
    
    func loadUsers() async throws -> [User] {
        try await load(fileName: DataType.user.fileName, type: [User].self)
    }
    
    func loadPatients() async throws -> [Patient] {
        try await load(fileName: DataType.patient.fileName, type: [Patient].self)
    }
    
    func loadLocations() async throws -> [Location] {
        try await load(fileName: DataType.location.fileName, type: [Location].self)
    }
}
