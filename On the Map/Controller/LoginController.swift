//
//  ViewController.swift
//  On the Map
//
//  Created by António Ramos on 22/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import UIKit

class LoginController: MainViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var loginButton: CustomOrangeButton!
    @IBOutlet weak var signUpButton: CustomOrangeButton!
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTextField(emailTextField)
        initTextField(passwordTextField)
        setColoredLabelText(welcomeLabel)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordTextField.text = ""
    }
    
    //MARK: Buttons
    
    @IBAction func loginOnButtonTapped(_ sender: Any) {
        
        OTMClient.login(username: emailTextField.text ?? "",
                        password: passwordTextField.text ?? "",
                        completionHandler: handleLoginResponse(success:error:))
        setActivityIndicator(animated: true)
    }
    
    @IBAction func udacitySignup(_ sender: Any) {
        
        if #available(iOS 10, *) {
        UIApplication.shared.open(EndPoints.udacitySignup.url, options: [:], completionHandler: nil)
        } else {
            _ = UIApplication.shared.openURL(EndPoints.udacitySignup.url)
        }
    }
    
    //MARK: Methods
    
    func handleLoginResponse(success: Bool, error: Error?){
            if success {
                self.performSegue(withIdentifier: "loginSuccessSegue", sender: nil)
                self.setActivityIndicator(animated: false)
            } else {
                self.showAlert(error: error!.localizedDescription)
                self.setActivityIndicator(animated: false)
            }
    }
    
    func setColoredLabelText(_ label: UILabel) {
        
        let myString: NSString = "Welcome to On the Map\nPlease login with your Udacity account"
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(
            string: myString as String,
            attributes: [NSAttributedString.Key.font:UIFont(name: "AppleSDGothicNeo-Regular", size: 20)!]
        )
        
        setColorInPosition(
            color: UIColor.primaryGray,
            mutableString: myMutableString,
            location: 0,
            lenght: 10
        )
        
        setColorInPosition(
            color: UIColor.primaryOrange,
            mutableString: myMutableString,
            location: 10,
            lenght: 11
        )
        setColorInPosition(
            color: UIColor.primaryGray,
            mutableString: myMutableString,
            location: 21,
            lenght: 25
        )
        setColorInPosition(
            color: UIColor.primaryBlue,
            mutableString: myMutableString,
            location: 44,
            lenght: 8
        )
        setColorInPosition(
            color: UIColor.primaryGray,
            mutableString: myMutableString,
            location: 53,
            lenght: 7
        )

        
        label.attributedText = myMutableString
    }
    
    override func setUiState(isInterationEnable: Bool) {
        emailTextField.isEnabled = isInterationEnable
        passwordTextField.isEnabled = isInterationEnable
        loginButton.isEnabled = isInterationEnable
        signUpButton.isEnabled = isInterationEnable
    }
    
   
}



