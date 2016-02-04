//
//  LoginViewController.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/3/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginState: Int {
        case Default
        case InProgress
        case Authenticated
    }
    
    // Use this constants to perform a fast login
    let yourLoginUsername = ""
    let yourLoginPassword = ""

    var ttKit = TTKit.sharedInstance()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var loginState: LoginState {
        
        didSet {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log In"
        loginState = LoginState.Default
        emailTextField.text = yourLoginUsername
        passwordTextField.text = yourLoginPassword
        loginButton.backgroundColor = Constants.Colors.leadingColor
    }
    
    
    
    @IBAction func onLoginButtonPressed(sender: AnyObject) {
        
    }
    
}