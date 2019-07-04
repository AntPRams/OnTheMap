//
//  CustomGrayButton.swift
//  On the Map
//
//  Created by António Ramos on 02/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

class CustomGrayButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        tintColor = UIColor.white
        backgroundColor = .primaryGray
      
    }
}
