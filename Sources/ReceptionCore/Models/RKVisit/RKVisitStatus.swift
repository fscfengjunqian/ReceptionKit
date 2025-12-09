//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import Foundation

public enum RKVisitStatus: String, Codable, Equatable {
    case scheduled
    case waitingArrival
    case arrived
    case accepted
    case delayed
    case rejected
    case completed
    case expired
}
