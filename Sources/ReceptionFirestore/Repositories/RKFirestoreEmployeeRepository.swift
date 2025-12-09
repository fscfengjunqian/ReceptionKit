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

public typealias RKFEmployeeRepo = RKFirestoreEmployeeRepository

public class RKFirestoreEmployeeRepository: RKEmployeeRepositoryProtocol {

    private let collection = Firestore.firestore().collection(RKFirestoreCollection.employees)

    public init() {}

    public func fetch(id: String) async throws -> RKEmployee {
        let document = try await collection.document(id).getDocument()
        guard let dto = try? document.data(as: RKEmployeeDTO.self) else {
            throw RKFirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func fetch(byNameKanaPrefix prefix: String) async throws
        -> [RKEmployee]
    {
        print("begin search..")
        let snapshot = try await collection
            .order(by: "nameKana")
            .start(at: [prefix])
            .end(at: [prefix + "\u{f8ff}"])
            .getDocuments()
        return snapshot.documents.compactMap {
            try? $0.data(as: RKEmployeeDTO.self).toDomain()
        }
    }

    public func fetch(byEmail email: String) async throws -> RKEmployee? {
        let snapshot = try await collection
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocuments()

        return try snapshot.documents.first?.data(as: RKEmployeeDTO.self)
            .toDomain()
    }

}
