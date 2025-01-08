import XCTest
@testable import RayCal

final class RayCalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testLoadAppointments_Success() async throws {
        // Given
        let dataLoader = await RCDataLoader.shared

        // When
        let appointments = try await dataLoader.loadAppointments()

        // Then
        XCTAssertFalse(appointments.isEmpty, "Appointments should not be empty")
        XCTAssertEqual(appointments.count, 18, "There should be 18 appointments")
        XCTAssertEqual(appointments[0].appointmentTitle, "Treatment", "The first appointment's title should be 'Treatment'")
    }
}
