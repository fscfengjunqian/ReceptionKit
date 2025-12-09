//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/12/08.
//

import Foundation

public protocol RKGeneralUserRepositoryProtocol {
    func create(_ user: RKUser) async throws
    func fetchUser() async throws -> RKUser
    func update(_ user: RKUser) async throws
}
