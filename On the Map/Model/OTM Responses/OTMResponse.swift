//
//  OTMResponse.swift
//  On the Map
//
//  Created by António Ramos on 24/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

struct OTMResponse: Codable {
    
    let statusCode: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case errorMessage = "error"
    }
}
extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}
