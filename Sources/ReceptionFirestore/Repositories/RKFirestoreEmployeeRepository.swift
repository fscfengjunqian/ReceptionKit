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
public class RKFirestoreEmployeeRepository: RKEmployeeRepositoryProtocol {

    private let db = Firestore.firestore()

    public init() {}

    public func fetch(id: String) async throws -> RKEmployee {
        let document = try await db.collection(RKFirestoreCollection.employees)
            .document(id).getDocument()
        guard let dto = try? document.data(as: RKEmployeeDTO.self) else {
            throw RKFirestoreError.notFound
        }
        return dto.toDomain()
    }

    public func fetchAll() async throws -> [RKEmployee] {
        let snapshot = try await db.collection(RKFirestoreCollection.employees)
            .getDocuments()
        return snapshot.documents.compactMap {
            try? $0.data(as: RKEmployeeDTO.self).toDomain()
        }
    }

    public func fetch(byNameKanaPrefix prefix: String) async throws
        -> [RKEmployee]
    {
        print("begin search..")
        let snapshot = try await db.collection(RKFirestoreCollection.employees)
            .order(by: "nameKana")
            .start(at: [prefix])
            .end(at: [prefix + "\u{f8ff}"])
            .getDocuments()
        return snapshot.documents.compactMap {
            try? $0.data(as: RKEmployeeDTO.self).toDomain()
        }
    }

    public func fetch(byEmail email: String) async throws -> RKEmployee? {
        let snapshot = try await db.collection(RKFirestoreCollection.employees)
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()

        return try snapshot.documents.first?.data(as: RKEmployeeDTO.self)
            .toDomain()
    }

    public func save(_ employee: RKEmployee) async throws {
        var dto = employee.toDTO()
        // 设置 updatedAt 为 nil，利用 @ServerTimestamp 让服务端填入时间
        dto.updatedAt = nil
        try db.collection(RKFirestoreCollection.employees).document(employee.id)
            .setData(from: dto)
    }

    public func delete(id: String) async throws {
        try await db.collection(RKFirestoreCollection.employees).document(id)
            .delete()
    }
}
