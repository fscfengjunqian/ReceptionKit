//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

// MARK: - Employee Repository Protocol
public protocol EmployeeRepositoryProtocol {
    func fetch(id: String) async throws -> Employee
    func fetchAll() async throws -> [Employee]
    func fetch(byEmail email: String) async throws -> Employee?
    func save(_ employee: Employee) async throws
    func delete(id: String) async throws
}
