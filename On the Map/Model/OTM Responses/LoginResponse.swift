//
//  PutStudentRequest.swift
//  On the Map
//
//  Created by António Ramos on 23/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let success: Bool
    let accountId: String

    enum CodingKeys: String, CodingKey {
        case success = "registered"
        case accountId = "key"
    }
}

struct Session: Codable {
    let sessionId: String
    let expiration: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expiration
    }
}


