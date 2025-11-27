//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public struct Employee: Identifiable, Codable, Equatable {
    public let id: String
    public var email: String
    public var name: String
    public var nameKana: String?
    public var nickName: String?
    public var avatarUrl: String?
    public var role: EmployeeRole
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
        role: EmployeeRole = .normal,
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

public enum EmployeeRole: String, Codable {
    case admin
    case normal
    case frontDesk
}
