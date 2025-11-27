//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation
import FirebaseFirestore
import ReceptionCore

internal enum FirestoreMapper {
    
    // MARK: - Visitor
    static func visitorToDomain(_ dto: VisitorDTO) -> Visitor {
        Visitor(
            id: dto.id ?? UUID().uuidString,
            name: dto.name,
            company: dto.company,
            email: dto.email,
            phone: dto.phone,
            createdAt: dto.createdAt?.dateValue(),
            updatedAt: dto.updatedAt?.dateValue()
        )
    }
    
    static func visitorToDTO(_ domain: Visitor) -> VisitorDTO {
        var dto = VisitorDTO()
        dto.id = domain.id
        dto.name = domain.name
        dto.company = domain.company
        dto.email = domain.email
        dto.phone = domain.phone
        // createdAt/updatedAt handled by server
        return dto
    }
    
    // MARK: - Employee
    static func employeeToDomain(_ dto: EmployeeDTO) -> Employee {
        Employee(
            id: dto.id ?? UUID().uuidString,
            email: dto.email ?? '""',
            name: dto.name,
            nameKana: dto.nameKana,
            nickName: dto.nickName,
            avatarUrl: dto.avatarUrl,
            role: EmployeeRole(rawValue: dto.role.rawValue) ?? .normal,
            deviceToken: dto.deviceToken,
            phoneNumber: dto.phoneNumber,
            createdAt: dto.createdAt?.dateValue() ?? nil,
            updatedAt: dto.updatedAt?.dateValue() ?? nil
        )
    }
    
    static func employeeToDTO(_ domain: Employee) -> EmployeeDTO {
        var dto = EmployeeDTO()
        dto.id = domain.id
        dto.email = domain.email
        dto.name = domain.name
        dto.nameKana = domain.nameKana
        dto.nickName = domain.nickName
        dto.avatarUrl = domain.avatarUrl
        dto.role = domain.role.rawValue
        dto.deviceToken = domain.deviceToken
        dto.phoneNumber = domain.phoneNumber
        return dto
    }
    
    // MARK: - Visit
    static func visitToDomain(_ dto: VisitDTO) -> Visit {
        Visit(
            id: dto.id ?? UUID().uuidString,
            type: VisitType(rawValue: dto.type) ?? .other,
            visitorId: dto.visitorId,
            employeeId: dto.employeeId,
            createdAt: dto.createdAt?.dateValue(),
            updatedAt: dto.updatedAt?.dateValue(),
            scheduledAt: dto.scheduledAt?.dateValue(),
            reservationCode: dto.reservationCode,
            peopleCount: dto.peopleCount,
            status: VisitStatus(rawValue: dto.status) ?? .waiting
        )
    }
    
    static func visitToDTO(_ domain: Visit) -> VisitDTO {
        var dto = VisitDTO()
        dto.id = domain.id
        dto.type = domain.type.rawValue
        dto.visitorId = domain.visitorId
        dto.employeeId = domain.employeeId
        dto.scheduledAt = domain.scheduledAt
        dto.reservationCode = domain.reservationCode
        dto.peopleCount = domain.peopleCount
        dto.status = domain.status.rawValue
        return dto
    }
}

