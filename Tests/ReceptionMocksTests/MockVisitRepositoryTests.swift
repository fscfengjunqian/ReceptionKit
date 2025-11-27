import XCTest
@testable import ReceptionMocks
@testable import ReceptionCore

final class MockVisitRepositoryTests: XCTestCase {
    func testCRUDFlow() async throws {
        let repo = MockVisitRepository()
        let visit = Visit(visitorId: "v1", employeeId: "e1", type: .scheduled)
        let saved = try await repo.createVisit(visit)
        XCTAssertEqual(saved.id, visit.id)
        
        let fetched = try await repo.fetchVisit(byId: visit.id)
        XCTAssertNotNil(fetched)
        
        try await repo.updateVisitStatus(id: visit.id, status: .accepted)
        let updated = try await repo.fetchVisit(byId: visit.id)
        XCTAssertEqual(updated?.status, .accepted)
        
        try await repo.deleteVisit(byId: visit.id)
        let afterDelete = try await repo.fetchVisit(byId: visit.id)
        XCTAssertNil(afterDelete)
    }
}
