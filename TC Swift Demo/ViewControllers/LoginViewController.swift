//
//  LoginViewController.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/3/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var ttKit = TTKit.sharedInstance()

    enum LoginState: Int {
        case `default` = 0
        case inProgress = 1
        case authenticated = 2
    }
    
    // Use this constants to perform a fast login
    let yourLoginUsername = ""
    let yourLoginPassword = ""
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setLoginState(_ loginState: LoginState) {
        switch loginState {
        case .default:
            activityIndicator.stopAnimating()
            loginButton.isHidden = false
            break
            
        case .inProgress:
            activityIndicator.startAnimating()
            loginButton.isHidden = true
            break
            
        case .authenticated:
            activityIndicator.startAnimating()
            loginButton.isHidden = true
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log In"
        setLoginState(.default)
        emailTextField.text = yourLoginUsername
        passwordTextField.text = yourLoginPassword
        loginButton.backgroundColor = Constants.Colors.leadingColor
    }
    
    @IBAction func onLoginButtonPressed(_ sender: AnyObject) {
        
        if emailTextField.text!.isEmpty {
            let alertController = UIHelpers.alertControllerWithTitle("Error", message: "Please enter an email", completion: nil)
            self.present(alertController, animated: true, completion: nil)
            return;
        }
        
        if passwordTextField.text!.isEmpty {
            let alertController = UIHelpers.alertControllerWithTitle("Error", message: "Please enter a password", completion: nil)
            self.present(alertController, animated: true, completion: nil)
            return;
        }
        
        self.setLoginState(.inProgress)
        
        ttKit?.login(withUserId: emailTextField.text, password: passwordTextField.text, success: { (user : TTUser?) -> Void in
            self.setLoginState(.authenticated)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.loadUserLoggedInUI()
            }
        }, failure: {(error: Error?) -> Swift.Void in
            let alertController = UIHelpers.alertControllerWithTitle("Error", message: (error?.localizedDescription)!, completion: nil)
            self.present(alertController, animated: true, completion: nil)
            self.setLoginState(.default)
        })
    }
}
