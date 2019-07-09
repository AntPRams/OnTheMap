//
//  MainViewController.swift
//  On the Map
//
//  Created by António Ramos on 02/07/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

/* ---------------------------------------------------------
 The purpose of this controller is to encapsulate the methods,
 actions and properties that are present in some controllers,
 thus avoiding the repetition of the same code
---------------------------------------------------------- */

class MainViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var customActivityIndicatorContainer: UIView!
    
    var activeTextField: UITextField!
    
    let actIndicator = MyIndicator(
        frame: CGRect(x:      0,
                      y:      0,
                      width:  30,
                      height: 30),
        image:     UIImage(named: "actIndicator")!,
        imageMask: UIImage(named: "actIndicatorMask")!)
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customActivityIndicatorContainer.backgroundColor = UIColor.clear
        customActivityIndicatorContainer.addSubview(actIndicator)
        setActivityIndicator(animated: false)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setActivityIndicator(animated: false)
    }
    
    //MARK: Actions present in tableView and mapView UI
    
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
        /*--------------------------------------------------
         Placeholder method, implemented to be used to block
         some UI objects while the activity indicator is on
         screen. This method goes along with
         setActivityIndicator(animated:)
         --------------------------------------------------*/
    }
    
    //method to change the color of UILabel text
    func setColorInPosition(color: UIColor, mutableString: NSMutableAttributedString, location: Int, lenght: Int) {
        mutableString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: color,
            range: NSRange(location: location,length: lenght)
        )
    }
    
    @objc func presentAddLocationController() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddLocationController") else {return}
        present(controller, animated: true, completion: nil)
    }
}
