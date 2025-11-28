//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

// MARK: - Visit Repository Protocol
public protocol VisitRepositoryProtocol {
    func fetch(id: String) async throws -> Visit
    func fetchByEmployee(id: String) async throws -> [Visit]
    func fetchByVisitor(id: String) async throws -> [Visit]
    func fetchUpcoming(forEmployeeId empId: String) async throws -> [Visit]
    func save(_ visit: Visit) async throws
    func delete(id: String) async throws
}
