//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public protocol VisitRepository {
    // CREATE
    func createVisit(_ visit: Visit) async throws -> Visit
    
    // READ
    func fetchVisit(byId id: String) async throws -> Visit?
    func fetchVisits(forEmployeeId employeeId: String) async throws -> [Visit]
    func fetchVisit(byReservationCode code: String) async throws -> Visit?
    
    // UPDATE
    func updateVisit(_ visit: Visit) async throws
    func updateVisitStatus(id: String, status: VisitStatus) async throws
    
    // DELETE
    func deleteVisit(byId id: String) async throws
}

