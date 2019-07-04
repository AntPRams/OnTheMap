//
//  StudentLocation.swift
//  On the Map
//
//  Created by António Ramos on 23/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    let objectId:  String?
    let uniqueKey: String?
    let firstName: String?
    let lastName:  String?
    let mapString: String?
    let mediaURL:  String?
    let latitude:  Double?
    let longitude: Double?
    
    var fullName: String {
        guard let fstName = firstName, let lstName = lastName else {
        return "John Doe"
        }
        return fstName + " " + lstName
    }
    
    var studentUrl: String {
        guard let url = mediaURL else {
            return "fail"
        }
        return url
    }
    
}


