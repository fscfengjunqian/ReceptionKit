//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

public final class FirestoreEmployeeRepository: EmployeeRepository {
    private let db = Firestore.firestore()
    private var collection: CollectionReference { db.collection("employees") }

    public init() {}

    public func createEmployee(_ employee: Employee) async throws -> Employee {
        let dto = FirestoreMapper.employeeToDTO(employee)
        let ref = collection.document(employee.id)
        try ref.setData(from: dto)
        let snap = try await ref.getDocument()
        let savedDTO = try snap.data(as: EmployeeDTO.self)
        return FirestoreMapper.employeeToDomain(savedDTO)
    }

    public func fetchEmployee(byId id: String) async throws -> Employee? {
        let snap = try await collection.document(id).getDocument()
        guard snap.exists, let dto = try? snap.data(as: EmployeeDTO.self) else {
            return nil
        }
        return FirestoreMapper.employeeToDomain(dto)
    }

    public func fetchAllEmployees() async throws -> [Employee] {
        let snap = try await collection.getDocuments()
        return snap.documents.compactMap { try? $0.data(as: EmployeeDTO.self) }
            .map { FirestoreMapper.employeeToDomain($0) }
    }

    public func updateEmployee(_ employee: Employee) async throws {
        let dto = FirestoreMapper.employeeToDTO(employee)
        try collection.document(employee.id).setData(from: dto, merge: true)
    }

    public func deleteEmployee(byId id: String) async throws {
        try await collection.document(id).delete()
    }

    public func searchEmployees(keyword: String) async throws -> [Employee] {
        let snapshots =
            try await collection
            .whereField("nameKana", isGreaterThanOrEqualTo: keyword)
            .whereField(
                "nameKana",
                isLessThanOrEqualTo: keyword + "\u{f8ff}"
            )
            .getDocuments()
        return snapshots.documents.compactMap {
            try? $0.data(as: EmployeeDTO.self)
        }.map { FirestoreMapper.employeeToDomain($0) }
    }
}
