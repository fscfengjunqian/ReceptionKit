//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

// MARK: - Employee Repository Protocol
public protocol RKEmployeeRepositoryProtocol {
    func fetch(id: String) async throws -> RKEmployee
    func fetchAll() async throws -> [RKEmployee]
    func fetch(byEmail email: String) async throws -> RKEmployee?
    func save(_ employee: RKEmployee) async throws
    func delete(id: String) async throws
}
