//
//  AppDelegate.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

#import <TTKit/TTKit.h>

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIHelpers.h"

#ifdef DEBUG
// Your TTKit Agent for debug and apns sandbox testing
NSString * const kTTKitAgent = @"your_test_agent";
#else
// Your TTKit Agent for production and apns production testing
NSString * const kTTKitAgent = @"your_production_agent";
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpRunTimeEnvironment];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:defaultStatusBarStyle()];
    
    if ([[TTKit sharedInstance] isUserConnected]) {
        [self loadUserLoggedInUI];
    }else {
        [self loadUserLoggedOutUI];
    }
    return YES;
}

- (void)setUpRunTimeEnvironment
{
    [[TTKit sharedInstance] initializeWithAgent:kTTKitAgent environment:TTKitEnvironmentProduction];
    [self registerForPush];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUnreadCount:)
                                                 name:kTTKitUnreadMessagesCountChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogout)
                                                 name:kTTKitWillLogoutNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveRemoteLogoutNotification)
                                                 name:kTTKitDidReceiveRemoteLogoutNotification
                                               object:nil];
    
    [self setAppearance];
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (void)setAppearance
{
    [[UINavigationBar appearance] setBarTintColor:leadingColor()];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UITabBar appearance] setTintColor:leadingColor()];
    [[UITabBar appearance] setBarTintColor:secondaryColor()];
}

- (void)loadUserLoggedInUI
{
    self.rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
    [self.window setRootViewController:self.rootController];
    [self.window makeKeyAndVisible];
}

- (void)loadUserLoggedOutUI
{
    [self.rootController removeFromParentViewController];
    self.rootController = nil;
    UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.window setRootViewController:loginNav];
    [self.window makeKeyAndVisible];
}

# pragma mark - Push Notifications

- (void)registerForPush
{
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Push received = %@",userInfo);
}

// Register your push token with TigerConnect
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)dataToken
{
    [[TTKit sharedInstance] registerPushNotificationDataToken:dataToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#pragma mark - Attachments Background Sessions

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    [[TTKit sharedInstance] application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
}

#pragma mark - Application Badge

- (void)refreshUnreadCount:(NSNotification *)notification
{
    NSObject *obj = notification.object;
    if (obj) {
        NSNumber *totalCount = (NSNumber *)obj;
        [UIApplication sharedApplication].applicationIconBadgeNumber = [totalCount integerValue];
    }
}

#pragma mark - Application lifecycle
- (void)didLogout
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self loadUserLoggedOutUI];
}

- (void)didReceiveRemoteLogoutNotification
{
    [[TTKit sharedInstance] logout];
    UIAlertController *alertController = [UIHelpers alertControllerWithTitle:@"Remote Logout" message:@"You've been logged out of your account, please contact your administrator if you have any questions." completion:nil];
    UIViewController *firstViewController = [self topViewController];
    [firstViewController presentViewController:alertController animated:YES completion:nil];
}

- (UIViewController *)topViewController
{
    UIViewController *rootViewController = self.window.rootViewController;
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootViewController;
        UINavigationController *nav = (UINavigationController *)tabVC.selectedViewController;
        
        if ([nav isKindOfClass:[UINavigationController class]]) {
            UIViewController *topVc = nav.topViewController;
            return topVc;
        }
    }
    return nil;
}

@end
