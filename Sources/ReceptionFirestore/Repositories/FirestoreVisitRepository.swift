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
public class FirestoreVisitRepository: VisitRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetch(id: String) async throws -> Visit {
        let document = try await db.collection(FirestoreCollection.visits).document(id).getDocument()
        guard let dto = try? document.data(as: VisitDTO.self) else {
            throw FirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func fetchByEmployee(id: String) async throws -> [Visit] {
        // 注意：如果你需要按时间排序，可能需要在 Firebase Console 创建复合索引
        let snapshot = try await db.collection(FirestoreCollection.visits)
            .whereField("employeeId", isEqualTo: id)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: VisitDTO.self).toDomain() }
    }
    
    public func fetchByVisitor(id: String) async throws -> [Visit] {
        let snapshot = try await db.collection(FirestoreCollection.visits)
            .whereField("visitorId", isEqualTo: id)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: VisitDTO.self).toDomain() }
    }
    
    public func fetchUpcoming(forEmployeeId empId: String) async throws -> [Visit] {
        // 查询未来的预约：状态是 scheduled 且时间在现在之后
        let snapshot = try await db.collection(FirestoreCollection.visits)
            .whereField("employeeId", isEqualTo: empId)
            .whereField("status", isEqualTo: VisitStatus.scheduled.rawValue) // Enum 需转 rawValue
            .whereField("scheduledAt", isGreaterThan: Date())
            .order(by: "scheduledAt", descending: false) // 最近的在前
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: VisitDTO.self).toDomain() }
    }
    
    public func save(_ visit: Visit) async throws {
        var dto = visit.toDTO()
        dto.updatedAt = nil
        try db.collection(FirestoreCollection.visits).document(visit.id).setData(from: dto)
    }
    
    public func delete(id: String) async throws {
        try await db.collection(FirestoreCollection.visits).document(id).delete()
    }
}
