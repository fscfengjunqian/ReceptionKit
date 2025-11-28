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
public class FirestoreVisitorRepository: VisitorRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetch(id: String) async throws -> Visitor {
        let document = try await db.collection(FirestoreCollection.visitors).document(id).getDocument()
        guard let dto = try? document.data(as: VisitorDTO.self) else {
            throw FirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func fetch(byEmail email: String) async throws -> Visitor? {
        let snapshot = try await db.collection(FirestoreCollection.visitors)
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()
        
        return try snapshot.documents.first?.data(as: VisitorDTO.self).toDomain()
    }
    
    public func search(name: String) async throws -> [Visitor] {
        // Firestore 的全文搜索能力有限。
        // 这里演示一个简单的前缀搜索技巧 (name >= query AND name <= query + \u{f8ff})
        let snapshot = try await db.collection(FirestoreCollection.visitors)
            .whereField("name", isGreaterThanOrEqualTo: name)
            .whereField("name", isLessThan: name + "\u{f8ff}")
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: VisitorDTO.self).toDomain() }
    }
    
    public func save(_ visitor: Visitor) async throws {
        var dto = visitor.toDTO()
        dto.updatedAt = nil
        try db.collection(FirestoreCollection.visitors).document(visitor.id).setData(from: dto)
    }
    
    public func delete(id: String) async throws {
        try await db.collection(FirestoreCollection.visitors).document(id).delete()
    }
}
