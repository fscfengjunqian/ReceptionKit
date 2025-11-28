//
//  File.swift
//  ReceptionKit
//
//  Created by fsc2022 on 2025/11/28.
//

import XCTest
import Foundation
// 导入核心模块
@testable import ReceptionCore
// 导入 Mocks 模块，用于测试依赖 Protocol 的逻辑
@testable import ReceptionMocks

final class RKReceptionCoreTests: XCTestCase {

    // ----------------------------------------------------------------------
    // MARK: - Domain Model Initialization & Equatability Tests
    // ----------------------------------------------------------------------

    /// 测试 Employee 模型的初始化和默认值
    func testEmployeeInitializationAndDefaults() throws {
        // 使用必需参数初始化
        let employee = RKEmployee(email: "ceo@company.com", name: "CEO")
        
        XCTAssertFalse(employee.id.isEmpty) // ID 应该自动生成 (UUID)
        XCTAssertEqual(employee.email, "ceo@company.com")
        XCTAssertEqual(employee.name, "CEO")
        XCTAssertEqual(employee.role, .normal) // 默认值
        XCTAssertNil(employee.nickName) // 可选字段默认为 nil
        XCTAssertNotNil(employee.createdAt) // 默认值 .now
    }

    /// 测试 Visit 模型的初始化和默认值
    func testVisitInitializationAndDefaults() throws {
        let visit = RKVisit(visitorId: "v1", employeeId: "e1")
        
        XCTAssertEqual(visit.type, .unscheduled) // 默认值
        XCTAssertEqual(visit.status, .waitingArrival) // 默认值
        XCTAssertNil(visit.scheduledAt)
        XCTAssertEqual(visit.visitorId, "v1")
        XCTAssertEqual(visit.employeeId, "e1")
    }

    /// 测试两个相等的 Employee 对象
    func testEmployeeEquatability() throws {
        let id = UUID().uuidString
        let fixedDate = Date()
        
        let emp1 = RKEmployee(id: id, email: "a@b.com", name: "A", role: .admin, createdAt: fixedDate)
        let emp2 = RKEmployee(id: id, email: "a@b.com", name: "A", role: .admin, createdAt: fixedDate)
        
        XCTAssertEqual(emp1, emp2)
        
        // 验证非 ID 字段变化是否影响相等性
        let emp3 = RKEmployee(id: id, email: "x@y.com", name: "X", role: .admin)
        XCTAssertNotEqual(emp1, emp3, "字段变化应该导致不相等")
        
        // 验证 ID 变化是否影响相等性
        let emp4 = RKEmployee(id: UUID().uuidString, email: "a@b.com", name: "A", role: .admin)
        XCTAssertNotEqual(emp1, emp4, "ID 变化应该导致不相等")
    }
    
    // ----------------------------------------------------------------------
    // MARK: - Repository Protocol Interaction Tests (使用 Mock)
    // ----------------------------------------------------------------------

    /// 测试 Repository Protocol 的 Save 操作 (使用 Mock)
    func testRepositorySave() async throws {
        // 1. 准备 Mock
        let mockRepo = RKMockEmployeeRepository()
        let employee = RKEmployee(email: "save_test@comp.com", name: "Saver")
        
        // 2. 执行操作
        try await mockRepo.save(employee)
        
        // 3. 验证 Mock 内部状态和调用次数
        let savedEmployee = try await mockRepo.fetch(id: employee.id)
        XCTAssertEqual(savedEmployee.name, "Saver")
        XCTAssertEqual(mockRepo.callCount_save, 1, "Save 方法应该被调用一次")
    }
    
    /// 测试 Repository Protocol 的 Fetch 错误处理 (使用 Mock)
    func testRepositoryFetchError() async throws {
        // 1. 准备 Mock 并设置为抛出错误模式
        let mockRepo = RKMockEmployeeRepository()
        mockRepo.shouldThrowError = true
        
        // 2. 期望捕获错误
        do {
            _ = try await mockRepo.fetch(id: "nonexistent")
            XCTFail("Fetch 应该抛出错误")
        } catch let error as RKMockError {
            XCTAssertEqual(error, .fetchFailed, "应该抛出预期的 Mock 错误")
        } catch {
            XCTFail("抛出了错误的错误类型")
        }
    }
    
    /// 测试 Visit Repository 的特定查询 (使用 Mock)
    func testVisitRepositoryQuery() async throws {
        // 1. 准备 Mock 数据
        let employeeId = "emp_1"
        let visit1 = RKVisit(id: "v1", visitorId: "u1", employeeId: employeeId, createdAt: Date().addingTimeInterval(-1000))
        let visit2 = RKVisit(id: "v2", visitorId: "u2", employeeId: employeeId, createdAt: Date()) // 最新
        let visit3 = RKVisit(id: "v3", visitorId: "u3", employeeId: "emp_2", createdAt: Date()) // 不属于该员工
        
        let mockRepo = RKMockVisitRepository(initialData: [visit1, visit2, visit3])
        
        // 2. 执行查询
        let employeeVisits = try await mockRepo.fetchByEmployee(id: employeeId)
        
        // 3. 验证结果
        XCTAssertEqual(employeeVisits.count, 2)
        
        // 验证排序：Mock Repository 应该按 createdAt 倒序返回 (最新的在前)
        XCTAssertEqual(employeeVisits.first?.id, visit2.id, "最新的 Visit 应该在列表首位")
        XCTAssertEqual(employeeVisits.last?.id, visit1.id, "最旧的 Visit 应该在列表末位")
    }
}
