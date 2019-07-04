//
//  StudentsModel.swift
//  On the Map
//
//  Created by António Ramos on 23/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

class Locations {
    
    static let shared = Locations()
    
    var list = [StudentLocation]()
    
    init() {}
}

