//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import ReceptionCore

public final class MockEmployeeRepository: EmployeeRepository {
    
    public var storage: [String: Employee] = [:]

    public init() {}

    public func createEmployee(_ employee: Employee) async throws -> Employee {
        storage[employee.id] = employee
        return employee
    }

    public func fetchEmployee(byId id: String) async throws -> Employee? {
        storage[id]
    }

    public func fetchAllEmployees() async throws -> [Employee] {
        Array(storage.values)
    }

    public func updateEmployee(_ employee: Employee) async throws {
        storage[employee.id] = employee
    }

    public func deleteEmployee(byId id: String) async throws {
        storage.removeValue(forKey: id)
    }

    public func searchEmployees(keyword: String) async throws -> [Employee] {
        storage.values.filter {
            $0.name.localizedCaseInsensitiveContains(keyword)
                || ($0.email.localizedCaseInsensitiveContains(keyword) ?? false)
        }
    }
}
