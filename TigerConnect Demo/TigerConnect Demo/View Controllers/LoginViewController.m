//
//  LoginViewController.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

#import <TTKit/TTKit.h>

#import "AppDelegate.h"
#import "UIHelpers.h"
#import "LoginViewController.h"

// Use this constants to perform a fast login
NSString * const kYourLoginEmail = @"";
NSString * const kYourLoginPassword = @"";

typedef NS_ENUM(NSInteger, LoginState) {
    LoginStateDefault           = 0,
    LoginStateInProgress        = 1,
    LoginStateInAuthenticated   = 2,
};

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) LoginState loginState;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initial setup
    self.title = @"Log In";
    self.loginState = LoginStateDefault;
    self.emailTextField.text = kYourLoginEmail;
    self.passwordTextField.text = kYourLoginPassword;
    
    // Customization
    self.emailTextField.tintColor = leadingColor();
    self.passwordTextField.tintColor = leadingColor();
    [self.loginButton setBackgroundColor:leadingColor()];
}

// Set the relevant state for the view controller
- (void)setLoginState:(LoginState)loginState
{
    _loginState = loginState;
    switch (_loginState) {
        case LoginStateDefault:
        {
            [self.activityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            break;
        }
        case LoginStateInProgress:
        {
            [self.activityIndicator startAnimating];
            self.loginButton.hidden = YES;
            break;
        }
        case LoginStateInAuthenticated:
        {
            [self.activityIndicator startAnimating];
            self.loginButton.hidden = YES;
            break;
        }
        default:
            break;
    }
}

// Handle login button press
- (IBAction)onLoginButton:(id)sender
{
    if (self.emailTextField.text.length == 0) {
        UIAlertController *alertController = [UIHelpers alertControllerWithTitle:@"Error" message:@"Please enter an email" completion:nil];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        UIAlertController *alertController = [UIHelpers alertControllerWithTitle:@"Error" message:@"Please enter a password" completion:nil];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    self.loginState = LoginStateInProgress;
    
    // Login using the username and password, the success block will returned the logged in user object
    [[TTKit sharedInstance] loginWithUserId:self.emailTextField.text password:self.passwordTextField.text success:^(TTUser *user) {
        self.loginState = LoginStateInAuthenticated;
        // Adding a small delay here
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GetAppDelegate loadUserLoggedInUI];
        });
        
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIHelpers alertControllerWithTitle:@"Error" message:error.localizedDescription completion:nil];
        [self presentViewController:alertController animated:YES completion:nil];
        self.loginState = LoginStateDefault;
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = YES;
    if(textField) {
        if([textField isEqual:self.emailTextField] && self.passwordTextField) {
            shouldReturn = NO;
            [self.passwordTextField becomeFirstResponder];
        } else if([textField isEqual:self.passwordTextField]) {
            shouldReturn = NO;
            [self onLoginButton:nil];
        }
    }
    return shouldReturn;
}

@end
