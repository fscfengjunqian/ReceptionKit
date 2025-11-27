//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public struct Visitor: Identifiable, Codable, Equatable {
    public var id: String
    public var name: String
    public var company: String?
    public var email: String?
    public var phone: String?

    public var createdAt: Date?
    public var updatedAt: Date?

    public init(
        id: String = UUID().uuidString,
        name: String,
        company: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.company = company
        self.email = email
        self.phone = phone
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
