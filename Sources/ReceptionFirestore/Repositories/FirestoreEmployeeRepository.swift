//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

// MARK: - Firestore Employee Repository
public class FirestoreEmployeeRepository: EmployeeRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetch(id: String) async throws -> Employee {
        let document = try await db.collection(FirestoreCollection.employees).document(id).getDocument()
        guard let dto = try? document.data(as: EmployeeDTO.self) else {
            throw FirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func fetchAll() async throws -> [Employee] {
        let snapshot = try await db.collection(FirestoreCollection.employees).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: EmployeeDTO.self).toDomain() }
    }
    
    public func fetch(byEmail email: String) async throws -> Employee? {
        let snapshot = try await db.collection(FirestoreCollection.employees)
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()
        
        return try snapshot.documents.first?.data(as: EmployeeDTO.self).toDomain()
    }
    
    public func save(_ employee: Employee) async throws {
        var dto = employee.toDTO()
        // 设置 updatedAt 为 nil，利用 @ServerTimestamp 让服务端填入时间
        dto.updatedAt = nil
        try db.collection(FirestoreCollection.employees).document(employee.id).setData(from: dto)
    }
    
    public func delete(id: String) async throws {
        try await db.collection(FirestoreCollection.employees).document(id).delete()
    }
}
