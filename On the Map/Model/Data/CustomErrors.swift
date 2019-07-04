//
//  Errors.swift
//  On the Map
//
//  Created by António Ramos on 01/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

//Core location errors description

enum CLErrors {
    
    static let cantFindLocationDesc = "You must provide a valid location!"
    static let networkProblemDesc =   "There's a problem with your connection, please try again!"
    static let unknowProblemDesc =    "There was a problem, please try again later! If the problem persist contact the developer"
    static let error = "Error test"
    
    case cantFindLocation
    case networkProblem
    case unknowProblem
    case test
    
    var description: String {
        switch self {
        case .cantFindLocation: return CLErrors.cantFindLocationDesc
        case .networkProblem:   return CLErrors.networkProblemDesc
        case .unknowProblem:    return CLErrors.networkProblemDesc
        case .test: return CLErrors.error
        }
    }
}




