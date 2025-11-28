//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import ReceptionCore

public class RKMockVisitRepository: RKVisitRepositoryProtocol {
    
    // 模拟数据库存储
    public var visits: [String: RKVisit] = [:]
    public var shouldThrowError = false
    
    public init(initialData: [RKVisit] = []) {
        initialData.forEach { visits[$0.id] = $0 }
    }
    
    public func fetch(id: String) async throws -> RKVisit {
        if shouldThrowError {
            throw RKMockError.fetchFailed
        }
        guard let visit = visits[id] else {
            throw RKMockError.notFound
        }
        return visit
    }
    
    public func fetchByEmployee(id: String) async throws -> [RKVisit] {
        if shouldThrowError {
            throw RKMockError.queryFailed
        }
        return visits.values.filter { $0.employeeId == id }.sorted { $0.createdAt > $1.createdAt }
    }
    
    public func fetchByVisitor(id: String) async throws -> [RKVisit] {
        if shouldThrowError {
            throw RKMockError.queryFailed
        }
        return visits.values.filter { $0.visitorId == id }.sorted { $0.createdAt > $1.createdAt }
    }
    
    public func fetchUpcoming(forEmployeeId empId: String) async throws -> [RKVisit] {
        if shouldThrowError {
            throw RKMockError.queryFailed
        }
        // 模拟查询：状态是 scheduled 且时间在现在之后
        return visits.values
            .filter { $0.employeeId == empId && $0.status == .scheduled && ($0.scheduledAt ?? Date.distantFuture) > Date() }
            .sorted { ($0.scheduledAt ?? Date.distantFuture) < ($1.scheduledAt ?? Date.distantFuture) } // 升序，最近的在前
    }
    
    public func save(_ visit: RKVisit) async throws {
        if shouldThrowError {
            throw RKMockError.saveFailed
        }
        visits[visit.id] = visit
    }
    
    public func delete(id: String) async throws {
        if shouldThrowError {
            throw RKMockError.deleteFailed
        }
        visits.removeValue(forKey: id)
    }
}
