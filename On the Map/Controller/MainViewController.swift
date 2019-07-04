//
//  MainViewController.swift
//  On the Map
//
//  Created by António Ramos on 02/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

//The objective with this MainViewController is to encapsulate the methods, buttons and properties that are present in the other controllers

class MainViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var customActivityIndicatorContainer: UIView!
    
    var activeTextField: UITextField!
    
    let actIndicator = MyIndicator(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30), image: UIImage(named: "actIndicator")!, imageMask: UIImage(named: "actIndicatorMask")!)
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customActivityIndicatorContainer.backgroundColor = UIColor.clear
        customActivityIndicatorContainer.addSubview(actIndicator)
        setActivityIndicator(animated: false)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        setActivityIndicator(animated: false)
    }
    
    //MARK: Buttons presents in tableView and mapView
    
    @IBAction func logoutWhenButtonTapped(_ sender: Any) {
        
        OTMClient.taskForDELETERequest(completionHandler: {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        if Credentials.objectId == nil {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddLocationController") else {return}
        present(controller, animated: true, completion: nil)
        } else {
            alertIfUserIsPuttingLocation()
        }
    }
    
    //MARK: Methods
    
    func setActivityIndicator(animated: Bool) {
        switch animated {
        case true:
            actIndicator.startAnimating()
        case false:
            actIndicator.stopAnimating()
        }
        setUiState(isInterationEnable: !animated)
    }
    
    func setUiState(isInterationEnable: Bool) {
        //this method was made to be overriden to block UI elements while loading
    }
    
    //method to change the color of UILabel text
    func setColorInPosition(color: UIColor, mutableString: NSMutableAttributedString, location: Int, lenght: Int) {
        mutableString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: color,
            range: NSRange(location: location,length: lenght)
        )
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
    
    @objc func presentAddLocationController() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddLocationController") else {return}
        present(controller, animated: true, completion: nil)
    }
}
