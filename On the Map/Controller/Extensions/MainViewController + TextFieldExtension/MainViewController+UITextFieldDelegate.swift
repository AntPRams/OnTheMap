//
//  MainViewController+UITextFieldDelegate.swift
//  On the Map
//
//  Created by António Ramos on 02/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
    
    func initTextField(_ textField : UITextField) {
        textField.delegate = self
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
