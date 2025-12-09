//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/11/28.
//

import Foundation

// MARK: - Visitor Repository Protocol
public protocol RKVisitorRepositoryProtocol {
    func fetch(id: String) async throws -> RKVisitor
    func fetch(byEmail email: String) async throws -> RKVisitor? 
    func search(name: String) async throws -> [RKVisitor]
    func save(_ visitor: RKVisitor) async throws
    func delete(id: String) async throws
}
