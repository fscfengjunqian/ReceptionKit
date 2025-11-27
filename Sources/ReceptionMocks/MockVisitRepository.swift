//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import ReceptionCore

public final class MockVisitRepository: VisitRepository {
    public var storage: [String: Visit] = [:]

    public init() {}

    public func createVisit(_ visit: Visit) async throws -> Visit {
        storage[visit.id] = visit
        return visit
    }

    public func fetchVisit(byId id: String) async throws -> Visit? {
        storage[id]
    }

    public func fetchVisits(forEmployeeId employeeId: String) async throws
        -> [Visit]
    {
        storage.values.filter { $0.employeeId == employeeId }.sorted {
            $0.createdAt ?? Date() < $1.createdAt ?? Date()
        }
    }

    public func fetchVisit(byReservationCode code: String) async throws
        -> Visit?
    {
        storage.values.first { $0.reservationCode == code }
    }

    public func updateVisit(_ visit: Visit) async throws {
        storage[visit.id] = visit
    }

    public func updateVisitStatus(id: String, status: VisitStatus) async throws
    {
        guard var v = storage[id] else { return }
        v.status = status
        storage[id] = v
    }

    public func deleteVisit(byId id: String) async throws {
        storage.removeValue(forKey: id)
    }
}
