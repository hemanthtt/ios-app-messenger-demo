//
//  UIHelpers.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 11/19/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <TTKit/TTUser.h>

@interface UIHelpers : NSObject

+ (UIAlertController *)actionSheetAlertContorllerWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles completion:(void (^)(NSString *buttonTitle))completion;
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion;
+ (UIAlertController *)errorAlertControllerWithMessage:(NSString *)message completion:(void (^)(void))completion;
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles completion:(void (^)(NSString *buttonTitle))completion;
+ (NSString *)titleLabelForUser:(TTUser *)user;
+ (NSString *)initialsForParty:(TTParty *)party;

@end
