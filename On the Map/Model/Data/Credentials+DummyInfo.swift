//
//  UserDummyInfo.swift
//  On the Map
//
//  Created by António Ramos on 29/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

struct Credentials {
    
    static var accountId:      String? //from OTMClient.login
    static var expirationDate: String? //from OTMClient.login
    static var sessionId:      String? //from OTMClient.login
    static var objectId:       String? //from OTMClient.postLocation
    
}

struct DummyInfo {
    
    static var firstName:    String?  //from OTMClient.getUserDetails
    static var lastName:     String?  //from OTMClient.getUserDetails
    static var mediaUrl:     String?  
    static var latitude:     Double?
    static var longitude:    Double?
    static var objectId =    Credentials.objectId
    static var uniqueKey =   Credentials.accountId
    static var mapString:    String?
    
}

