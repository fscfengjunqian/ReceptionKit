//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

// MARK: - Visit Repository Protocol
public protocol RKVisitRepositoryProtocol {
    func fetch(id: String) async throws -> RKVisit
    func fetchByEmployee(id: String) async throws -> [RKVisit]
    func fetchByVisitor(id: String) async throws -> [RKVisit]
    func fetchUpcoming(forEmployeeId empId: String) async throws -> [RKVisit]
    func save(_ visit: RKVisit) async throws
    func delete(id: String) async throws
}
