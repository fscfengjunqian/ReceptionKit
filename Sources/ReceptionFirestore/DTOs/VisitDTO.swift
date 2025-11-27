//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import FirebaseFirestore
import ReceptionCore

internal struct VisitDTO: Codable {
    @DocumentID var id: String?
    var type: VisitType
    var visitorId: String
    var employeeId: String
    var reservationCode: String?
    var peopleCount: Int?
    var status: VisitStatus
    var reservationDate: Date?
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
    @ServerTimestamp var scheduledAt: Timestamp?
}

