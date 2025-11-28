//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/11/28.
//

import Foundation
import ReceptionCore

public class RKMockVisitorRepository: RKVisitorRepositoryProtocol {
    
    // 模拟数据库存储
    public var visitors: [String: RKVisitor] = [:]
    public var shouldThrowError = false
    
    public init(initialData: [RKVisitor] = []) {
        initialData.forEach { visitors[$0.id] = $0 }
    }
    
    public func fetch(id: String) async throws -> RKVisitor {
        if shouldThrowError {
            throw RKMockError.fetchFailed
        }
        guard let visitor = visitors[id] else {
            throw RKMockError.notFound
        }
        return visitor
    }
    
    public func fetch(byEmail email: String) async throws -> RKVisitor? {
        if shouldThrowError {
            throw RKMockError.fetchFailed
        }
        return visitors.values.first(where: { $0.email == email })
    }
    
    public func search(name: String) async throws -> [RKVisitor] {
        if shouldThrowError {
            throw RKMockError.queryFailed
        }
        // 简单的包含查询
        return visitors.values.filter { $0.name.localizedCaseInsensitiveContains(name) }
    }
    
    public func save(_ visitor: RKVisitor) async throws {
        if shouldThrowError {
            throw RKMockError.saveFailed
        }
        visitors[visitor.id] = visitor
    }
    
    public func delete(id: String) async throws {
        if shouldThrowError {
            throw RKMockError.deleteFailed
        }
        visitors.removeValue(forKey: id)
    }
}
