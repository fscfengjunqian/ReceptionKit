//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import FirebaseFirestore
import ReceptionCore

// MARK: - Employee Conversion
extension EmployeeDTO {
    func toDomain() -> Employee {
        return Employee(
            id: self.id ?? "",
            email: self.email,
            name: self.name,
            nameKana: self.nameKana,
            nickName: self.nickName,
            avatarUrl: self.avatarUrl,
            role: self.role,
            deviceToken: self.deviceToken,
            phoneNumber: self.phoneNumber,
            createdAt: self.createdAt ?? Date(), // 处理 ServerTimestamp 尚未写入时的 nil 情况
            updatedAt: self.updatedAt
        )
    }
}

extension Employee {
    func toDTO() -> EmployeeDTO {
        return EmployeeDTO(
            id: self.id, // 如果是新建，这里ID会被忽略，Firestore生成新ID；如果是更新，则用于指定文档
            email: self.email,
            name: self.name,
            nameKana: self.nameKana,
            nickName: self.nickName,
            avatarUrl: self.avatarUrl,
            role: self.role,
            deviceToken: self.deviceToken,
            phoneNumber: self.phoneNumber,
            createdAt: self.createdAt, // 写入时也可以传值，或者传 nil 让 ServerTimestamp 生效
            updatedAt: self.updatedAt
        )
    }
}

// MARK: - Visit Conversion
extension VisitDTO {
    func toDomain() -> Visit {
        return Visit(
            id: self.id ?? "",
            type: self.type,
            visitorId: self.visitorId,
            employeeId: self.employeeId,
            createdAt: self.createdAt ?? Date(),
            updatedAt: self.updatedAt,
            scheduledAt: self.scheduledAt,
            reservationCode: self.reservationCode,
            peopleCount: self.peopleCount,
            status: self.status
        )
    }
}

extension Visit {
    func toDTO() -> VisitDTO {
        return VisitDTO(
            id: self.id,
            type: self.type,
            visitorId: self.visitorId,
            employeeId: self.employeeId,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            scheduledAt: self.scheduledAt,
            reservationCode: self.reservationCode,
            peopleCount: self.peopleCount,
            status: self.status
        )
    }
}

// MARK: - Visitor Conversion
extension VisitorDTO {
    func toDomain() -> Visitor {
        return Visitor(
            id: self.id ?? "",
            name: self.name,
            company: self.company,
            email: self.email,
            phone: self.phone,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
}

extension Visitor {
    func toDTO() -> VisitorDTO {
        return VisitorDTO(
            id: self.id,
            name: self.name,
            company: self.company,
            email: self.email,
            phone: self.phone,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
}


