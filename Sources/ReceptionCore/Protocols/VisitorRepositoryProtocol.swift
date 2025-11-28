//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/11/28.
//

import Foundation

// MARK: - Visitor Repository Protocol
public protocol VisitorRepositoryProtocol {
    func fetch(id: String) async throws -> Visitor
    func fetch(byEmail email: String) async throws -> Visitor? // 常用于检查访客是否已存在
    func search(name: String) async throws -> [Visitor]
    func save(_ visitor: Visitor) async throws
    func delete(id: String) async throws
}
