//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public struct RKEmployee: Identifiable, Codable, Equatable {
    public let id: String
    public var email: String
    public var name: String
    public var nameKana: String?
    public var nickName: String?
    public var avatarUrl: String?
    public var role: RKEmployeeRole
    public var deviceToken: String?
    public var phoneNumber: String?
    public var createdAt: Date
    public var updatedAt: Date?

    public init(
        id: String = UUID().uuidString,
        email: String,
        name: String,
        nameKana: String? = nil,
        nickName: String? = nil,
        avatarUrl: String? = nil,
        role: RKEmployeeRole = .normal,
        deviceToken: String? = nil,
        phoneNumber: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.nameKana = nameKana
        self.nickName = nickName
        self.avatarUrl = avatarUrl
        self.role = role
        self.deviceToken = deviceToken
        self.phoneNumber = phoneNumber
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
