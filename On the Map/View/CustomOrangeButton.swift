//
//  LoginAndSignupButton.swift
//  On the Map
//
//  Created by António Ramos on 01/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

class CustomOrangeButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        tintColor = UIColor.white
        backgroundColor = .primaryOrange
    }
}
