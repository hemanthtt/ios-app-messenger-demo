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
        case Default = 0
        case InProgress = 1
        case Authenticated = 2
    }
    
    // Use this constants to perform a fast login
    let yourLoginUsername = ""
    let yourLoginPassword = ""
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setLoginState(loginState: LoginState) {
        switch loginState {
        case .Default:
            activityIndicator.stopAnimating()
            loginButton.hidden = false
            break
            
        case .InProgress:
            activityIndicator.startAnimating()
            loginButton.hidden = true
            break
            
        case .Authenticated:
            activityIndicator.startAnimating()
            loginButton.hidden = true
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log In"
        setLoginState(.Default)
        emailTextField.text = yourLoginUsername
        passwordTextField.text = yourLoginPassword
        loginButton.backgroundColor = Constants.Colors.leadingColor
    }
    
    @IBAction func onLoginButtonPressed(sender: AnyObject) {
        
        if emailTextField.text!.isEmpty {
            let alertController = UIHelpers.alertControllerWithTitle("Error", message: "Please enter an email", completion: nil)
            self.presentViewController(alertController, animated: true, completion: nil)
            return;
        }
        
        if passwordTextField.text!.isEmpty {
            let alertController = UIHelpers.alertControllerWithTitle("Error", message: "Please enter a password", completion: nil)
            self.presentViewController(alertController, animated: true, completion: nil)
            return;
        }
        
        self.setLoginState(.InProgress)
        
        ttKit.loginWithUserId(emailTextField.text, password: passwordTextField.text, success: { (user: TTUser?) -> Void in
            self.setLoginState(.Authenticated)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.loadUserLoggedInUI()
            }
            
            }) { (error: NSError?) -> Void in
                let alertController = UIHelpers.alertControllerWithTitle("Error", message: (error?.localizedDescription)!, completion: nil)
                self.presentViewController(alertController, animated: true, completion: nil)
                self.setLoginState(.Default)
        }
        
    }
    
}