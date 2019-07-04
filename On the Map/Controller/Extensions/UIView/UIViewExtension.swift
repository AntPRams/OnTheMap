//
//  UIViewExtension.swift
//  On the Map
//
//  Created by António Ramos on 01/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

//Extension to animate labels between states in AddLocationController

extension UIView {
    
    func fadeTransition(_ duration: CFTimeInterval) {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
