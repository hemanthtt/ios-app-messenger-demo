//
//  AppDelegate.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GetAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UIStoryboard *storyboard;
@property (nonatomic) UINavigationController *rootController;

- (void)loadUserLoggedInUI;
- (void)loadUserLoggedOutUI;

@end

