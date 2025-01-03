import Foundation

@MainActor
class RCDataLoader: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var locations: [Location] = []
    @Published var users: [User] = []
    
    @Published var errorMessage: String?
    
    @Published var hasLoaded = false // Track loading state
    
    // The single shared instance
    static let shared = RCDataLoader()
    
    // Private initializer to prevent exterval instantiation
    private init() {}
    
    func fetchData() async {
        guard let locationURL = Bundle.main.url(forResource: "locations", withExtension: "json"),
        let patientURL = Bundle.main.url(forResource: "patients", withExtension: "json"),
        let userURL = Bundle.main.url(forResource: "users", withExtension: "json")
        else {
            print("Failed to locate file in bundle.")
            return
        }
        
        do {
            let locationData = try Data(contentsOf: locationURL)
            let decodedLocations = try JSONDecoder().decode([Location].self, from: locationData)
            locations = decodedLocations
            
            let patientData = try Data(contentsOf: patientURL)
            let decodedPatients = try JSONDecoder().decode([Patient].self, from: patientData)
           patients = decodedPatients
            
            let userData = try Data(contentsOf: userURL)
            let decodedUsers = try JSONDecoder().decode([User].self, from: userData)
            users = decodedUsers
            hasLoaded = true
            print("data loaded")
            print(patients)
        } catch {
            print("Failed to load or decode JSON")
        }
    }
    

}
