//
//  AddLocationController.swift
//  On the Map
//
//  Created by António Ramos on 27/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class AddLocationController: MainViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapLocalView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var requestLocationLabel: UILabel!
    @IBOutlet weak var uiViewForMap: UIView!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    lazy var geocoder = CLGeocoder()
    
    let mapController = MapViewController()
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColoredLabelText(whereAreYouLabel)
        mapLocalView.delegate = self
        submitButton.setTitle("Search", for: .normal)
        initTextField(textField)
        uiViewForMap.isHidden = false
        mapView(isActive: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Buttons
    
    @IBAction func findOnMapAndSubmit(_ sender: Any) {
        
        guard let placeOnMapOrURL = textField.text else {return}
        
        switch submitButton.titleLabel?.text {
        case "Search":
            if textField.text != "" {
                setActivityIndicator(animated: true)
                geocoder.geocodeAddressString(placeOnMapOrURL, completionHandler: handleResponse(withPlacemark:error:))
                requestLocationLabel.fadeTransition(2)
                requestLocationLabel.text = "Share a URL with your classmates:"
                DummyInfo.mapString = textField.text
            } else {
                setActivityIndicator(animated: false)
                showAlert(error: "You must provide a valid location!")
                return
            }
        case "Submit":
            if textField.text != "" {
                setActivityIndicator(animated: true)
                OTMClient.getUserDetails(completionHandler: self.handleUserInfo(response:error:))
                DummyInfo.mediaUrl = checkUrl(check: placeOnMapOrURL)
            } else {
                showAlert(error: "You must provide a valid URL")
                return
            }
        default:
            return
        }
    }
 
    @IBAction func dismissButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Methods
    
    func checkUrl(check: String) -> String {
        
        var urlCheck = check
        
        if urlCheck.hasPrefix("https://") || urlCheck.hasPrefix("http://"){
            return urlCheck
        } else {
            urlCheck = "https://\(check)"
            return urlCheck
        }
    }
    
    //MARK: Methods
    
    @objc func keyboardWillChange(_ notification: Notification) {
        
        let verticalSpacing: CGFloat = 5
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }

        // Get the keyboard frame from the user info

        let keyboardMinY = keyboardFrame.minY
        if keyboardMinY == UIScreen.main.bounds.maxY {
            view.frame.origin.y = 0
            return
        }

        let mainStackViewMaxYOnScreen = mainStackView.frame.maxY + view.frame.origin.y
        if keyboardMinY < mainStackViewMaxYOnScreen {
            view.frame.origin.y -= mainStackViewMaxYOnScreen - keyboardMinY + verticalSpacing
        }
        
    }

    func setColoredLabelText(_ label: UILabel) {
        
        let myString: NSString = "Where are you\nstudying\ntoday?"
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(
            string: myString as String,
            attributes: [NSAttributedString.Key.font:UIFont(name: "AppleSDGothicNeo-Light", size: 40.0)!]
        )
        
        setColorInPosition(
            color: UIColor.primaryGray,
            mutableString: myMutableString,
            location: 0,
            lenght: 13
        )
        
        setColorInPosition(
            color: UIColor.primaryOrange,
            mutableString: myMutableString,
            location: 14,
            lenght: 8
        )
        
        setColorInPosition(
            color: UIColor.primaryGray,
            mutableString: myMutableString,
            location: 22,
            lenght: 7
        )
        
        label.attributedText = myMutableString
    }
    
    
    func handleUserInfo(response: UserInfo?, error: Error?){
        
        if error == nil {
            if Credentials.objectId == nil {
                DummyInfo.firstName = response?.firstName
                DummyInfo.lastName = response?.lastName
                OTMClient.postLocation(completionHandler: self.handlePostLocationResponse(success:error:))
                setActivityIndicator(animated: false)
            } else {
                OTMClient.putLocation(completionHandler: self.handlePostLocationResponse(success:error:))
            }
        } else {
            handleErrorAlert(error: error)
            setActivityIndicator(animated: false)
        }
    }
    
    func handlePostLocationResponse(success: Bool, error: Error?) {
        
        if success {
            dismiss(animated: true, completion: nil)
            setActivityIndicator(animated: false)
        } else {
            handleErrorAlert(error: error)
            setActivityIndicator(animated: false)
        }
    }
    
    //Mapview UI Properties
    func mapView(isActive: Bool){
        
        mapLocalView.layer.cornerRadius = 10
        mapLocalView.layer.borderWidth = 3
        mapLocalView.layer.borderColor = UIColor.primaryGray.cgColor
        
        uiViewForMap.layer.cornerRadius = 10
        uiViewForMap.layer.shadowColor = UIColor.primaryGray.cgColor
        uiViewForMap.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        uiViewForMap.layer.shadowRadius = 5.0
        uiViewForMap.layer.shadowOpacity = 0.9
        uiViewForMap.layer.masksToBounds = false
        
        if !isActive {
            mapLocalView.alpha = 0
        } else {
            mapLocalView.fadeTransition(2)
            mapLocalView.alpha = 1
        }
    }
    
    override func setUiState(isInterationEnable: Bool) {
        
        textField.isEnabled =                   isInterationEnable
        mapLocalView.isUserInteractionEnabled = isInterationEnable
        submitButton.isEnabled =                isInterationEnable
        
    }
}






