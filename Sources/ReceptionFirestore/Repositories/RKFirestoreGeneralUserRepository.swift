//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/12/08.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

public typealias RKFGeneralUserRepo = RKFirestoreGeneralUserRepository

public class RKFirestoreGeneralUserRepository: RKGeneralUserRepositoryProtocol {
    let collection = Firestore.firestore().collection(RKFirestoreCollection.employees)
    let userId: String

    public init(with id: String) {
        self.userId = id
    }
    
    public func create(_ user: RKUser) async throws {
        var dto = user.toDTO()
        dto.updatedAt = nil
        try collection.document(user.id).setData(from: dto)
    }
    
    public func fetchUser() async throws ->RKUser {
        let document = try await collection.document(userId).getDocument()
        guard let dto = try? document.data(as: RKUserDTO.self) else {
            throw RKFirestoreError.notFound
        }
        return dto.toDomain()
    }
    
    public func update(_ user: RKUser) async throws {
        var dto = user.toDTO()
        // 设置 updatedAt 为 nil，利用 @ServerTimestamp 让服务端填入时间
        dto.updatedAt = nil
        try collection.document(user.id).setData(from: dto, merge: true)
    }
}
