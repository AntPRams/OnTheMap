//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by António Ramos on 27/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

//Usefull methods to use in the other controllers

extension UIViewController {
    
    //This method is used to change the icon to add a location, if the user already posted a location this method changes de icon
    func setAddLocationButtonImage(_ button: UIBarButtonItem) {
        
        if Credentials.objectId != nil {
            button.image = UIImage(named: "updateLocation")
        } else {
            button.image = UIImage(named: "addPin")
        }
    }
    
    func showAlert(error: String) {
        let alert = UIAlertController(title: "Oops...", message: error, preferredStyle: .alert)
        let alertbutton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertbutton)
        present(alert, animated: true, completion: nil)
    }
    
    func alertIfUserIsPuttingLocation() {
        
        let alert = UIAlertController(
            title: "Caution",
            message: "You are about to overwrite your location, do you want to proceed?",
            preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        let alertActionConfirm = UIAlertAction(
            title: "Ok",
            style: .default
        ) { (UIAlertAction) in
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationController") else {return}
            self.present(controller, animated: true, completion: nil)
        }
        
        alert.addAction(alertActionConfirm)
        alert.addAction(alertActionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    //Handle error description when the localized description is not enough
    func handleErrorAlert(error: Error?){
        
        guard let error = error as NSError? else {return}
        
        var handleError: CLErrors
        
        switch error.code {
        case 2:
            handleError = CLErrors.networkProblem
        case 3:
            handleError = CLErrors.networkProblem
        case 8:
            handleError = CLErrors.cantFindLocation
        case -1003:
            handleError = CLErrors.networkProblem
        case -1001:
            handleError = CLErrors.networkProblem
        default:
            handleError = CLErrors.unknowProblem
        }
        showAlert(error: handleError.description)
    }
}

