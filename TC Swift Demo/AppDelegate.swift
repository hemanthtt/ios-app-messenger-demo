//
//  AppDelegate.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/3/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import UIKit

#if DEBUG
// Your TTKit Agent for debug and apns sandbox testing
let kTTKitAgent = "your_test_agent";
#else
// Your TTKit Agent for production and apns production testing
let  kTTKitAgent = "your_production_agent";
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setUpRunTimeEnviroment()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshUnreadCount:"), name: kTTKitUnreadMessagesCountChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didLogout"), name: kTTKitWillLogoutNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveRemoteLogoutNotification"), name: kTTKitDidReceiveRemoteLogoutNotification, object: nil)

        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()

        setAppearance()
        self.storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if (TTKit.sharedInstance().isUserConnected()) {
            loadUserLoggedInUI()
        } else {
            loadUserLoggedOutUI()
        }
        
        return true
    }
    
    func setUpRunTimeEnviroment() {
        TTKit.sharedInstance().initializeWithAgent(kTTKitAgent, environment: .Production)
    }
    
    func setAppearance() {
        UINavigationBar.appearance().barTintColor = Constants.Colors.leadingColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    func loadUserLoggedInUI() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("Inbox")
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    
    func loadUserLoggedOutUI() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

    // MARK: Push Notifiations
    
    func registerForPush() {
        let notificationType: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let notificationSettings = UIUserNotificationSettings.init(forTypes: notificationType, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        NSLog("Push received = %@", userInfo)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        TTKit.sharedInstance().registerPushNotificationDataToken(deviceToken)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    // MARK: Attachments Background Upload/Download sessions
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        TTKit.sharedInstance().application(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    // MARK: TTKit Notification Handling
    
    @objc func refreshUnreadCount(notification: NSNotification) {
        let obj = notification.object;
        if (obj != nil) {
            let totalUnreadMessagesCount = obj as! NSNumber
            UIApplication.sharedApplication().applicationIconBadgeNumber = totalUnreadMessagesCount.integerValue
        }
    }

    func didLogout() {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        loadUserLoggedOutUI()
    }
    
    @objc func didReceiveRemoteLogoutNotification() {
        TTKit.sharedInstance().logout()
        let alertController = UIHelpers.alertControllerWithTitle("Remote Logout", message: "You've been logged out of your account, please contact your administartor if you have any questions", completion: nil)
        let topController = UIApplication.topViewController()
        topController?.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
