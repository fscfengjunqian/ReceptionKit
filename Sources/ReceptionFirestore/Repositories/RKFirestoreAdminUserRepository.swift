//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/12/08.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

public typealias RKFAdminUserRepo = RKFirestoreAdminUserRepository

public class RKFirestoreAdminUserRepository: RKFirestoreGeneralUserRepository, RKAdminUserRepositoryProtocol {
    
    override public init(with userId: String) {
        super.init(with: userId)
    }
    
    public func fetch(withUid uid: String) async throws -> RKEmployee {
        let document = try await collection.document(uid).getDocument()
        guard let dto = try? document.data(as: RKUserDTO.self) else {
            throw RKFirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func fetchAll() async throws -> [RKEmployee] {
        let snapshot = try await collection.getDocuments()
        return snapshot.documents.compactMap {
            try? $0.data(as: RKEmployeeDTO.self).toDomain()
        }
    }
    
    public func deleteEmployee(byUid uid: String) async throws {
        try await collection.document(uid).delete()
    }
}
