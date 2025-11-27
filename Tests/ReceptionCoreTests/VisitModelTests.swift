import XCTest
@testable import ReceptionCore

final class VisitModelTests: XCTestCase {
    func testVisitInit_defaults() {
        let v = Visit(visitorID: "visitor1", employeeID: "emp1", type: .scheduled)
        XCTAssertEqual(v.visitorId, "visitor1")
        XCTAssertEqual(v.employeeId, "emp1")
        XCTAssertEqual(v.type, .scheduled)
        XCTAssertEqual(v.numberOfVisitors, 1)
        XCTAssertEqual(v.status, .waiting)
    }
}
