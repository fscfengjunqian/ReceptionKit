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
struct VisitDTO: Codable {
    @DocumentID var id: String?
    var type: VisitType // 假设 VisitType 也是 String, Codable
    var visitorId: String
    var employeeId: String
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    var scheduledAt: Date?
    var reservationCode: String?
    var peopleCount: Int?
    var status: VisitStatus
}

