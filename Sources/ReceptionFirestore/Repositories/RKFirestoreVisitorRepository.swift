//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/11/28.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

// MARK: - Firestore Visitor Repository
public class RKFirestoreVisitorRepository: RKVisitorRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetch(id: String) async throws -> RKVisitor {
        let document = try await db.collection(RKFirestoreCollection.visitors).document(id).getDocument()
        guard let dto = try? document.data(as: RKVisitorDTO.self) else {
            throw RKFirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func fetch(byEmail email: String) async throws -> RKVisitor? {
        let snapshot = try await db.collection(RKFirestoreCollection.visitors)
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()
        
        return try snapshot.documents.first?.data(as: RKVisitorDTO.self).toDomain()
    }
    
    public func search(name: String) async throws -> [RKVisitor] {
        // Firestore 的全文搜索能力有限。
        // 这里演示一个简单的前缀搜索技巧 (name >= query AND name <= query + \u{f8ff})
        let snapshot = try await db.collection(RKFirestoreCollection.visitors)
            .whereField("name", isGreaterThanOrEqualTo: name)
            .whereField("name", isLessThan: name + "\u{f8ff}")
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: RKVisitorDTO.self).toDomain() }
    }
    
    public func save(_ visitor: RKVisitor) async throws {
        var dto = visitor.toDTO()
        dto.updatedAt = nil
        try db.collection(RKFirestoreCollection.visitors).document(visitor.id).setData(from: dto)
    }
    
    public func delete(id: String) async throws {
        try await db.collection(RKFirestoreCollection.visitors).document(id).delete()
    }
}
