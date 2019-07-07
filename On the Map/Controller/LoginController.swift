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
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTextField(emailTextField)
        initTextField(passwordTextField)
        setColoredLabelText(welcomeLabel)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
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



