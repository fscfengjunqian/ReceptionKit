//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

// MARK: - Firestore Visit Repository
public class RKFirestoreVisitRepository: RKVisitRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetch(id: String) async throws -> RKVisit {
        let document = try await db.collection(RKFirestoreCollection.visits).document(id).getDocument()
        guard let dto = try? document.data(as: RKVisitDTO.self) else {
            throw RKFirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func fetchByEmployee(id: String) async throws -> [RKVisit] {
        // 注意：如果你需要按时间排序，可能需要在 Firebase Console 创建复合索引
        let snapshot = try await db.collection(RKFirestoreCollection.visits)
            .whereField("employeeId", isEqualTo: id)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: RKVisitDTO.self).toDomain() }
    }
    
    public func fetchByVisitor(id: String) async throws -> [RKVisit] {
        let snapshot = try await db.collection(RKFirestoreCollection.visits)
            .whereField("visitorId", isEqualTo: id)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: RKVisitDTO.self).toDomain() }
    }
    
    public func fetchUpcoming(forEmployeeId empId: String) async throws -> [RKVisit] {
        // 查询未来的预约：状态是 scheduled 且时间在现在之后
        let snapshot = try await db.collection(RKFirestoreCollection.visits)
            .whereField("employeeId", isEqualTo: empId)
            .whereField("status", isEqualTo: RKVisitStatus.scheduled.rawValue) // Enum 需转 rawValue
            .whereField("scheduledAt", isGreaterThan: Date())
            .order(by: "scheduledAt", descending: false) // 最近的在前
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: RKVisitDTO.self).toDomain() }
    }
    
    public func save(_ visit: RKVisit) async throws {
        var dto = visit.toDTO()
        dto.updatedAt = nil
        try db.collection(RKFirestoreCollection.visits).document(visit.id).setData(from: dto)
    }
    
    public func delete(id: String) async throws {
        try await db.collection(RKFirestoreCollection.visits).document(id).delete()
    }
}
