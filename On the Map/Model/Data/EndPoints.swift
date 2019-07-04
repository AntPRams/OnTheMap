//
//  EndPoints.swift
//  On the Map
//
//  Created by António Ramos on 24/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

enum EndPoints {
    
    static let base =                 "https://onthemap-api.udacity.com/v1"
    static let studentLocationParam = "/StudentLocation"
    static let postASessionParam =    "/session"
    static let getUserIdParam =       "/users/"
    static let sortedParam =          "?order=-updatedAt"
    static let udacitySignupParam =   "https://auth.udacity.com/sign-up"

    case getStudentLocations
    case postStudentLocation
    case updateLocation(String)
    case login
    case getUserDummyInfo(String)
    case putUserLocation
    case udacitySignup
    
    
    var stringValue: String {
        
        switch self {
        
        case .getStudentLocations: return EndPoints.base + EndPoints.studentLocationParam + EndPoints.sortedParam
        case .postStudentLocation: return EndPoints.base + EndPoints.studentLocationParam
        case .updateLocation(let objectId): return EndPoints.base + EndPoints.studentLocationParam + objectId
        case .login: return EndPoints.base + EndPoints.postASessionParam
        case .getUserDummyInfo(let userId): return EndPoints.base + EndPoints.getUserIdParam + userId
        case .putUserLocation: return EndPoints.base + EndPoints.studentLocationParam + "/\(Credentials.objectId!)"
        case .udacitySignup: return EndPoints.udacitySignupParam
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
    
}



