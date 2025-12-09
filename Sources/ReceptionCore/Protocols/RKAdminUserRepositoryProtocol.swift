//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/12/08.
//

import Foundation

public protocol RKAdminUserRepositoryProtocol {
    func fetchAll() async throws -> [RKEmployee]
    func fetch(withUid uid: String) async throws -> RKEmployee
    func deleteEmployee(byUid uid: String) async throws
}
