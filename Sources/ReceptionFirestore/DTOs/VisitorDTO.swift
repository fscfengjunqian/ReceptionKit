//
//  File.swift
//  ReceptionKit
//
//  Created by ronnie on 2025/11/27.
//

import FirebaseFirestore
import Foundation
import ReceptionCore

internal struct VisitorDTO: Codable {
    @DocumentID var id: String?
    var name: String
    var company: String?
    var email: String?
    var phone: String?
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
}
