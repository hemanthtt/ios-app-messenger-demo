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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpRunTimeEnviroment()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.refreshUnreadCount(_:)), name: NSNotification.Name.ttKitUnreadMessagesCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.didLogout), name: NSNotification.Name.ttKitWillLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.didReceiveRemoteLogoutNotification), name: NSNotification.Name.ttKitDidReceiveRemoteLogout, object: nil)

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white

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
        TTKit.sharedInstance().initialize(withAgent: kTTKitAgent, environment: .production)
    }
    
    func setAppearance() {
        UINavigationBar.appearance().barTintColor = Constants.Colors.leadingColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func loadUserLoggedInUI() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Inbox")
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    
    func loadUserLoggedOutUI() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

    // MARK: Push Notifiations
    
    func registerForPush() {
        let notificationType: UIUserNotificationType = [.alert, .badge, .sound]
        let notificationSettings = UIUserNotificationSettings.init(types: notificationType, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("Push received = %@", userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        TTKit.sharedInstance().registerPushNotificationDataToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    // MARK: Attachments Background Upload/Download sessions
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        TTKit.sharedInstance().application(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    // MARK: TTKit Notification Handling
    
    @objc func refreshUnreadCount(_ notification: Notification) {
        let obj = notification.object;
        if (obj != nil) {
            let totalUnreadMessagesCount = obj as! NSNumber
            UIApplication.shared.applicationIconBadgeNumber = totalUnreadMessagesCount.intValue
        }
    }

    func didLogout() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        loadUserLoggedOutUI()
    }
    
    @objc func didReceiveRemoteLogoutNotification() {
        TTKit.sharedInstance().logout()
        let alertController = UIHelpers.alertControllerWithTitle("Remote Logout", message: "You've been logged out of your account, please contact your administartor if you have any questions", completion: nil)
        let topController = UIApplication.topViewController()
        topController?.present(alertController, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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
