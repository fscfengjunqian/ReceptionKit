//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import FirebaseFirestore
import ReceptionCore

// MARK: - Employee DTO
struct RKEmployeeDTO: Codable {
    @DocumentID var id: String? // Firestore 自动映射文档 ID
    var email: String
    var name: String
    var nameKana: String?
    var nickName: String?
    var avatarUrl: String?
    var role: RKEmployeeRole // 直接使用 Domain Enum，因为它是 String Codable
    var deviceToken: String?
    var phoneNumber: String?
    @ServerTimestamp var createdAt: Date? // Firestore 服务器时间
    @ServerTimestamp var updatedAt: Date?
}

