//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import FirebaseFirestore
import ReceptionCore

internal struct EmployeeDTO: Codable {
    @DocumentID var id: String?
    var email: String?
    var name: String
    var nameKana: String?
    var nickName: String?
    var avatarUrl: String?
    var role: EmployeeRole
    var deviceToken: String?
    var phoneNumber: String?
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
}

