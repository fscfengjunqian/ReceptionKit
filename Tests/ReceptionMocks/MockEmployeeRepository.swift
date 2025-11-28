//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import ReceptionCore

public class MockEmployeeRepository: EmployeeRepositoryProtocol {
    
    // 模拟数据库存储
    public var employees: [String: Employee] = [:]
    // 用于模拟测试错误
    public var shouldThrowError = false
    public var callCount_save = 0
    public var callCount_fetch = 0
    
    public init(initialData: [Employee] = []) {
        initialData.forEach { employees[$0.id] = $0 }
    }
    
    public func fetch(id: String) async throws -> Employee {
        callCount_fetch += 1
        if shouldThrowError {
            throw MockError.fetchFailed
        }
        
        guard let employee = employees[id] else {
            throw MockError.notFound
        }
        return employee
    }
    
    public func fetchAll() async throws -> [Employee] {
        if shouldThrowError {
            throw MockError.fetchFailed
        }
        return Array(employees.values)
    }
    
    public func fetch(byEmail email: String) async throws -> Employee? {
        if shouldThrowError {
            throw MockError.fetchFailed
        }
        return employees.values.first(where: { $0.email == email })
    }
    
    public func save(_ employee: Employee) async throws {
        callCount_save += 1
        if shouldThrowError {
            throw MockError.saveFailed
        }
        // 模拟更新或插入 (Upsert)
        employees[employee.id] = employee
    }
    
    public func delete(id: String) async throws {
        if shouldThrowError {
            throw MockError.deleteFailed
        }
        employees.removeValue(forKey: id)
    }
}
