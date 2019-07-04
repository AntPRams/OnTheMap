//
//  LoginRequest.swift
//  On the Map
//
//  Created by António Ramos on 23/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    
    let credentials: LoginCredentials
    
    enum CodingKeys: String, CodingKey {
        
        case credentials = "udacity"
    }
}

struct LoginCredentials: Codable {
    
    let username: String
    let password: String
}
