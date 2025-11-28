//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import ReceptionCore

public class RKMockEmployeeRepository: RKEmployeeRepositoryProtocol {
    
    // 模拟数据库存储
    public var employees: [String: RKEmployee] = [:]
    // 用于模拟测试错误
    public var shouldThrowError = false
    public var callCount_save = 0
    public var callCount_fetch = 0
    
    public init(initialData: [RKEmployee] = []) {
        initialData.forEach { employees[$0.id] = $0 }
    }
    
    public func fetch(id: String) async throws -> RKEmployee {
        callCount_fetch += 1
        if shouldThrowError {
            throw RKMockError.fetchFailed
        }
        
        guard let employee = employees[id] else {
            throw RKMockError.notFound
        }
        return employee
    }
    
    public func fetchAll() async throws -> [RKEmployee] {
        if shouldThrowError {
            throw RKMockError.fetchFailed
        }
        // Simulate network latency
        try await Task.sleep(nanoseconds: 500_000_000)
        return Array(employees.values)
    }
    
    public func fetch(byEmail email: String) async throws -> RKEmployee? {
        if shouldThrowError {
            throw RKMockError.fetchFailed
        }
        return employees.values.first(where: { $0.email == email })
    }
    
    public func save(_ employee: RKEmployee) async throws {
        callCount_save += 1
        if shouldThrowError {
            throw RKMockError.saveFailed
        }
        // 模拟更新或插入 (Upsert)
        employees[employee.id] = employee
        
        try await Task.sleep(nanoseconds: 100_000_000)
    }
    
    public func delete(id: String) async throws {
        if shouldThrowError {
            throw RKMockError.deleteFailed
        }
        employees.removeValue(forKey: id)
    }
}
