//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public struct RKVisit: Identifiable, Codable, Equatable {
    public let id: String
    public var type: RKVisitType
    public var visitorId: String
    public var employeeId: String

    public var createdAt: Date
    public var updatedAt: Date?
    public var scheduledAt: Date?

    public var reservationCode: String?

    public var peopleCount: Int?
    public var status: RKVisitStatus

    public init(
        id: String = UUID().uuidString,
        type: RKVisitType = .unscheduled,
        visitorId: String,
        employeeId: String,
        createdAt: Date = .now,
        updatedAt: Date? = nil,
        scheduledAt: Date? = nil,
        reservationCode: String? = nil,
        peopleCount: Int? = nil,
        status: RKVisitStatus = .waitingArrival
    ) {
        self.id = id
        self.type = type
        self.visitorId = visitorId
        self.employeeId = employeeId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.scheduledAt = scheduledAt
        self.reservationCode = reservationCode
        self.peopleCount = peopleCount
        self.status = status
    }
}
