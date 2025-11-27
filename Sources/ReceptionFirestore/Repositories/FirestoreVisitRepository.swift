//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

public final class FirestoreVisitRepository: VisitRepository {
    private let db = Firestore.firestore()
    private var collection: CollectionReference { db.collection("visits") }

    public init() {}

    public func createVisit(_ visit: Visit) async throws -> Visit {
        let dto = FirestoreMapper.visitToDTO(visit)
        let ref = collection.document(visit.id)
        try ref.setData(from: dto)
        let snap = try await ref.getDocument()
        guard let savedDTO = try? snap.data(as: VisitDTO.self) else {
            throw NSError(
                domain: "FirestoreVisitRepository",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to read saved visit"
                ]
            )
        }
        return FirestoreMapper.visitToDomain(savedDTO)
    }

    public func fetchVisit(byId id: String) async throws -> Visit? {
        let snap = try await collection.document(id).getDocument()
        guard snap.exists, let dto = try? snap.data(as: VisitDTO.self) else {
            return nil
        }
        return FirestoreMapper.visitToDomain(dto)
    }

    public func fetchVisits(forEmployeeId employeeId: String) async throws
        -> [Visit]
    {
        let snapshots =
            try await collection
            .whereField("employeeId", isEqualTo: employeeId)
            .order(by: "createdAt", descending: false)
            .getDocuments()
        return snapshots.documents.compactMap {
            try? $0.data(as: VisitDTO.self)
        }.map { FirestoreMapper.visitToDomain($0) }
    }

    public func fetchVisit(byReservationCode code: String) async throws
        -> Visit?
    {
        let snapshot =
            try await collection
            .whereField("reservationCode", isEqualTo: code)
            .limit(to: 1)
            .getDocuments()
        guard let doc = snapshot.documents.first,
            let dto = try? doc.data(as: VisitDTO.self)
        else { return nil }
        return FirestoreMapper.visitToDomain(dto)
    }

    public func updateVisit(_ visit: Visit) async throws {
        let dto = FirestoreMapper.visitToDTO(visit)
        try collection.document(visit.id).setData(from: dto, merge: true)
    }

    public func updateVisitStatus(id: String, status: VisitStatus) async throws
    {
        try await collection.document(id).updateData([
            "status": status.rawValue,
            "updatedAt": FieldValue.serverTimestamp(),
        ])
    }

    public func deleteVisit(byId id: String) async throws {
        try await collection.document(id).delete()
    }
}
