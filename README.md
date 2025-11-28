# 📦 ReceptionKit

[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20|%20macOS-lightgrey.svg)](https://developer.apple.com/swift/resources/)

## 简介 (Introduction)

`ReceptionKit` 是一个为 iOS 和 macOS 应用程序设计的 **Swift Package**，旨在提供统一的**访客接待和员工管理**的领域模型、数据访问协议以及 Firebase Firestore 的具体实现。

它严格遵循**整洁架构 (Clean Architecture)** 原则，通过模块化设计（Core, Firestore, Mocks）实现了核心业务逻辑与持久化细节的解耦。

---

## ✨ 核心功能与模块结构 (Features & Architecture)

`ReceptionKit` 采用多 Target 设计，以确保最低限度的依赖和高内聚性：

| 模块名称 | 类型 | 主要内容 | 依赖关系 |
| :--- | :--- | :--- | :--- |
| **`ReceptionCore`** | Library | **核心业务模型** (`Employee`, `Visit`...) 和 **Repository Protocols**。 | 无 |
| **`ReceptionFirestore`** | Library | **持久化实现**。包含 Firestore DTOs、Mapper 转换逻辑和 `Firestore...Repository` 具体实现。 | `ReceptionCore`, `FirebaseFirestore` |
| **`ReceptionMocks`** | Target | **测试辅助工具**。包含所有 `Mock...Repository` 实现。 | `ReceptionCore` |



---

## 🚀 集成 (Installation)

`ReceptionKit` 通过 **Swift Package Manager (SPM)** 进行分发。

在您的 Xcode 项目中，选择 **File > Add Package Dependencies...**，然后输入此 Package 的 URL（如果已托管在 Git 上）。

### 依赖配置

根据您的使用场景，在您的应用程序 Target 中添加相应的模块依赖：

* **应用程序 (生产环境):** 依赖 `ReceptionCore` 和 `ReceptionFirestore`。
* **单元测试目标 (Tests):** 依赖 `ReceptionCore` 和 `ReceptionMocks`。

---

## 💻 使用指南 (Usage)

### 1. 访问核心模型和接口 (ReceptionCore)

您可以在任何模块中导入 `ReceptionCore` 来使用核心业务实体和定义的数据接口：

```swift
import ReceptionCore

// 核心模型是公共的
let newEmployee = Employee(email: "user@example.com", name: "John Doe")

// 在业务逻辑中只依赖 Protocol
struct EmployeeUseCase {
    let repository: EmployeeRepositoryProtocol
    
    func save(employee: Employee) async throws {
        try await repository.save(employee)
    }
}

### 2. 使用 Firestore 实现 (ReceptionFirestore)
在您的数据层（例如 Service 或 DataManager）实例化具体的 Firestore 实现：

```swift
import ReceptionFirestore
import ReceptionCore

// 实例化 Firestore 实现
let employeeRepo = FirestoreEmployeeRepository()

// 使用 async/await
Task {
    do {
        // 创建或更新数据
        let employee = Employee(email: "test@example.com", name: "Alice")
        try await employeeRepo.save(employee)
        
        // 读取数据
        let fetched = try await employeeRepo.fetch(id: employee.id)
        print("Fetched employee: \(fetched.name)")
    } catch {
        print("Firestore operation failed: \(error)")
    }
}

### 3. 单元测试 (ReceptionMocks)
在您的单元测试 Target 中，利用 ReceptionMocks 进行依赖注入，以隔离业务逻辑：

```swift
import XCTest
@testable import ReceptionCore
@testable import ReceptionMocks // 导入 Mock 实现

final class MyViewModelTests: XCTestCase {
    
    func testEmployeeLoading() async throws {
        // 1. 准备 Mock 数据并设置 Mock Repo
        let mockData = Employee(email: "a@b.com", name: "Test User")
        let mockRepo = MockEmployeeRepository(initialData: [mockData])
        
        // 2. 注入 Mock Repo
        let useCase = EmployeeUseCase(repository: mockRepo) 
        
        // 3. 执行业务逻辑
        let user = try await mockRepo.fetch(id: mockData.id) 
        
        // 4. 断言
        XCTAssertEqual(user.name, "Test User")
        // 验证 Mock 方法调用次数
        XCTAssertEqual(mockRepo.callCount_fetch, 1)
    }
}

---

## 🧪 测试与贡献 (Testing & Contribution)
### 单元测试目标
ReceptionCoreTests: 验证核心模型和 Repository Protocol 与 Mock 的交互是否正确。

ReceptionFirestoreTests: 验证 DTO 转换逻辑和 Firestore 实现的集成测试。

### 贡献
欢迎通过提交 Pull Request、报告 Bug 或提出功能建议来贡献您的力量。
