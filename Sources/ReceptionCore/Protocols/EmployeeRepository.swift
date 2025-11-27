//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public protocol EmployeeRepository {
    func createEmployee(_ employee: Employee) async throws -> Employee
    func fetchEmployee(byId id: String) async throws -> Employee?
    func fetchAllEmployees() async throws -> [Employee]
    func updateEmployee(_ employee: Employee) async throws
    func deleteEmployee(byId id: String) async throws
    func searchEmployees(keyword: String) async throws -> [Employee]
}
