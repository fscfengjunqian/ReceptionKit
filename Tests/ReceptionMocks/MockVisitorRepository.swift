//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/11/28.
//

import Foundation
import ReceptionCore

public class MockVisitorRepository: VisitorRepositoryProtocol {
    
    // 模拟数据库存储
    public var visitors: [String: Visitor] = [:]
    public var shouldThrowError = false
    
    public init(initialData: [Visitor] = []) {
        initialData.forEach { visitors[$0.id] = $0 }
    }
    
    public func fetch(id: String) async throws -> Visitor {
        if shouldThrowError {
            throw MockError.fetchFailed
        }
        guard let visitor = visitors[id] else {
            throw MockError.notFound
        }
        return visitor
    }
    
    public func fetch(byEmail email: String) async throws -> Visitor? {
        if shouldThrowError {
            throw MockError.fetchFailed
        }
        return visitors.values.first(where: { $0.email == email })
    }
    
    public func search(name: String) async throws -> [Visitor] {
        if shouldThrowError {
            throw MockError.queryFailed
        }
        // 简单的包含查询
        return visitors.values.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    public func save(_ visitor: Visitor) async throws {
        if shouldThrowError {
            throw MockError.saveFailed
        }
        visitors[visitor.id] = visitor
    }
    
    public func delete(id: String) async throws {
        if shouldThrowError {
            throw MockError.deleteFailed
        }
        visitors.removeValue(forKey: id)
    }
}
