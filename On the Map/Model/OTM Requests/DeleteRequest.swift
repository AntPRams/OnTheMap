//
//  DeleteRequest.swift
//  On the Map
//
//  Created by António Ramos on 27/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

struct DeleteRequest: Codable {
    let session: LogoutSession
}

struct LogoutSession: Codable {
    let sessionId: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expiration
    }
}
