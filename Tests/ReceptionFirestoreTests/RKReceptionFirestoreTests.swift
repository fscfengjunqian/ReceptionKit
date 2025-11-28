//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/11/28.
//

import XCTest
import Foundation
// 导入核心模块和 Firestore 模块
@testable import ReceptionCore
@testable import ReceptionFirestore

// 假设这些是您的 Firestore DTO 和 Domain Model
// 注意：实际项目中，DTO应该在 Firestore 模块中定义，但为了测试，需要能访问到它们。

final class RKReceptionFirestoreTests: XCTestCase {

    // 辅助方法：创建一个 Domain Model 实例
    private func createTestEmployee() -> RKEmployee {
        return RKEmployee(
            id: UUID().uuidString,
            email: "alice.test@company.com",
            name: "Alice Smith",
            nameKana: "アリス スミス",
            nickName: "Ali",
            role: .admin,
            deviceToken: "token123",
            phoneNumber: "09012345678",
            createdAt: Date.now.addingTimeInterval(-86400),
            updatedAt: Date.now
        )
    }
    
    // ----------------------------------------------------------------------
    // MARK: - Employee Model Tests
    // ----------------------------------------------------------------------

    /// 测试 Domain Model 到 DTO 的转换是否正确
    func testEmployeeToDTOMapping() throws {
        let domainModel = createTestEmployee()
        let dto = domainModel.toDTO()
        
        XCTAssertEqual(dto.id, domainModel.id)
        XCTAssertEqual(dto.email, "alice.test@company.com")
        XCTAssertEqual(dto.role, .admin)
        XCTAssertEqual(dto.nameKana, "アリス スミス")
        // ServerTimestamp 字段通常被保留，保持一致
        XCTAssertEqual(dto.createdAt, domainModel.createdAt)
    }
    
    /// 测试 DTO 到 Domain Model 的转换是否正确，特别是 Date 和 Optional 字段
    func testEmployeeToDomainMapping() throws {
        // 模拟一个从 Firestore 读取的 DTO (包含 nil ServerTimestamp)
        let mockDTO = RKEmployeeDTO(
            id: UUID().uuidString,
            email: "bob@company.com",
            name: "Bob",
            nameKana: nil, // 可选字段为 nil
            role: .normal,
            createdAt: nil, // 模拟 @ServerTimestamp 尚未写入
            updatedAt: Date.now
        )
        
        let domainModel = mockDTO.toDomain()
        
        XCTAssertEqual(domainModel.id, mockDTO.id)
        XCTAssertEqual(domainModel.name, "Bob")
        XCTAssertNil(domainModel.nameKana)
        XCTAssertEqual(domainModel.role, .normal)
        
        // 验证 createdAt 字段：如果 DTO 为 nil，toDomain 应该提供一个默认值（例如 Date()）
        // 在实际的 toDomain 实现中，我们通常会使用 ?? Date()
        XCTAssertNotNil(domainModel.createdAt)
        XCTAssertNotNil(domainModel.updatedAt)
    }
    
    // ----------------------------------------------------------------------
    // MARK: - Visit Model Tests
    // ----------------------------------------------------------------------
    
    /// 测试 Visit Model 的转换
    func testVisitToDTOMapping() throws {
        // 假设 VisitType.scheduled 存在
        let visit = RKVisit(
            visitorId: "v1",
            employeeId: "e1",
            scheduledAt: Date().addingTimeInterval(3600),
            status: .scheduled
        )
        
        let dto = visit.toDTO()
        
        XCTAssertEqual(dto.visitorId, "v1")
        XCTAssertEqual(dto.employeeId, "e1")
        XCTAssertEqual(dto.status, .scheduled)
        XCTAssertNotNil(dto.scheduledAt)
    }

    // ----------------------------------------------------------------------
    // MARK: - Visitor Model Tests
    // ----------------------------------------------------------------------

    /// 测试 Visitor Model 的转换和可选字段
    func testVisitorToDomainMapping() throws {
        let mockDTO = RKVisitorDTO(
            id: "vid_123",
            name: "Test Visitor",
            company: "Test Corp",
            email: nil,
            phone: nil,
            createdAt: Date()
        )
        
        let domainModel = mockDTO.toDomain()
        
        XCTAssertEqual(domainModel.id, "vid_123")
        XCTAssertEqual(domainModel.name, "Test Visitor")
        XCTAssertEqual(domainModel.company, "Test Corp")
        XCTAssertNil(domainModel.email)
        XCTAssertNotNil(domainModel.createdAt)
    }
}
