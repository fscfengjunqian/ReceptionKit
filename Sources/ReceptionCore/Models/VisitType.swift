//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public enum VisitType: String, Codable, Equatable {
    case scheduled  // 预约访问
    case unscheduled  // 非预约访问（现场 walk-in）
    case delivery  // 快递
    case other  // 其他
}
