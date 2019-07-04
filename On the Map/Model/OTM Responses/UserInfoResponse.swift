//
//  UserResponse.swift
//  On the Map
//
//  Created by António Ramos on 23/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

struct UserInfo: Codable{
    
    var lastName: String?
    var firstName:String?
    var nickname: String?
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case nickname
        
    }
}

