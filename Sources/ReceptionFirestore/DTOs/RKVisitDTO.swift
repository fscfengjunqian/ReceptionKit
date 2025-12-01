//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import FirebaseFirestore
import ReceptionCore

// MARK: - Visit DTO
struct RKVisitDTO: Codable {
    @DocumentID var id: String?
    var type: RKVisitType
    var visitorId: String?
    var employeeId: String?
    var vistorName: String?
    var companyName: String?
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    var scheduledAt: Date?
    var reservationCode: String?
    var peopleCount: Int?
    var status: RKVisitStatus
}

