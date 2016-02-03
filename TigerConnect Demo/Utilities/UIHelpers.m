//
//  UIHelpers.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 11/19/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import "UIHelpers.h"

@implementation UIHelpers

+ (UIAlertController *)actionSheetAlertContorllerWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles completion:(void (^)(NSString *buttonTitle))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             if (completion) {
                                 completion(nil);
                             }
                         }];
    [alertController addAction:cancel];
    
    for (NSString *title in buttonTitles) {
        UIAlertAction *action = [UIAlertAction
                                 actionWithTitle:title
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     if (completion) {
                                         completion(action.title);
                                     }
                                 }];
        [alertController addAction:action];
    }
    
    return alertController;
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles completion:(void (^)(NSString *buttonTitle))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 if (completion) {
                                     completion(nil);
                                 }
                             }];
    [alertController addAction:cancel];
    
    
    for (NSString *title in buttonTitles) {
        UIAlertAction *action = [UIAlertAction
                                 actionWithTitle:title
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     if (completion) {
                                         completion(action.title);
                                     }
                                 }];
        [alertController addAction:action];
    }
    return alertController;
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if (completion) {
                                 completion();
                             }
                         }];
    
    [alertController addAction:ok];
    return alertController;
}

+ (UIAlertController *)errorAlertControllerWithMessage:(NSString *)message completion:(void (^)(void))completion
{
    return [UIHelpers alertControllerWithTitle:@"Error" message:message completion:completion];
}

+ (NSString *)titleLabelForUser:(TTUser *)user
{
    if (!user) {
        return @"";
    }
    
    NSMutableString *title = [NSMutableString string];
    if (user.title.length > 0) {
        [title appendString:user.title];
    }
    
    if (user.department.length > 0) {
        if (title.length > 0) {
            [title appendFormat:@", %@",user.department];
        } else {
            [title appendString:user.department];
        }
    }
    return title;
}

+ (NSString *)initialsForParty:(TTParty *)party
{
    if (!party) {
        return @"";
    }
    
    if([party isKindOfClass:[TTUser class]]) {
        return [self initialsForDisplayForUser:(TTUser *)party];
    } else {
        return [self initialsForDisplayName:party.displayName];
    }
}

+ (NSString *)initialsForDisplayForUser:(TTUser *)aUser
{
    if (!aUser) {
        return @"";
    }
    
    if (aUser.firstName.length > 0 && aUser.lastName.length > 0) {
        //Use first and last name for initials
        NSString *firstInitial = [UIHelpers extractInitialFromString:aUser.firstName];
        NSString *secondInitial = [UIHelpers extractInitialFromString:aUser.lastName];
        NSString *initials = [NSString stringWithFormat:@"%@%@",[self sanitizeString: firstInitial.capitalizedString],[self sanitizeString:secondInitial.capitalizedString]];
        return initials;
    } else {
        //Use display name for initials
        return [self initialsForDisplayName:aUser.displayName];
    }
}

+ (NSString *)initialsForDisplayName:(NSString *)displayName
{
    if (!displayName) {
        return @"";
    }
    
    NSArray *names = [displayName componentsSeparatedByString:@" "];
    if (names.count == 0) {
        return @"";
    }
    
    NSString *firstName = [names firstObject];
    NSString *lastName = nil;
    NSString *firstInitial = nil;
    NSString *secondInitial = nil;
    
    if (names.count > 1) {
        lastName = [names objectAtIndex:1];
    }
    
    if (firstName.length > 0) {
        firstInitial = [self extractInitialFromString:firstName];
    }
    
    if (lastName.length > 0) {
        secondInitial = [self extractInitialFromString:lastName];
    }
    NSString *initials = [NSString stringWithFormat:@"%@%@",[self sanitizeString: firstInitial.capitalizedString],[self sanitizeString:secondInitial.capitalizedString]];
    return initials;
}

+ (NSString *)sanitizeString:(NSString *)string
{
    if (string && ![string isEqualToString:@"(null)"]) {
        return string;
    }else {
        return @"";
    }
}

+ (NSString *)extractInitialFromString:(NSString *)string {
    if (string.length == 0) return nil;
    
    NSString *initial = nil;
    initial = [string substringWithRange:[self composedRangeWithRange:NSMakeRange(0, 1) forString:string]];
    return initial;
}

+ (NSRange)composedRangeWithRange:(NSRange)range forString:(NSString *)string
{
    // We're going to make a new range that takes into account surrogate unicode pairs (composed characters)
    __block NSRange adjustedRange = range;
    
    // Adjust the location
    [string enumerateSubstringsInRange:NSMakeRange(0, range.location + 1) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // If they string the iterator found is greater than 1 in length, add that to range location.
        // This means that there is a composed character before where the range starts who's length is greater than 1.
        adjustedRange.location += substring.length - 1;
    }];
    
    // Adjust the length
    NSInteger length = string.length;
    
    // Count how many times we iterate so we only iterate over what we care about.
    __block NSInteger count = 0;
    [string enumerateSubstringsInRange:NSMakeRange(adjustedRange.location, length - adjustedRange.location) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // If they string the iterator found is greater than 1 in length, add that to range length.
        // This means that there is a composed character inside of the range starts who's length is greater than 1.
        adjustedRange.length += substring.length - 1;
        
        // Add one to the count
        count++;
        
        // If we have iterated as many times as the original length, stop.
        if (range.length == count) {
            *stop = YES;
        }
    }];
    
    // Make sure we don't make an invalid range. This should never happen, but let's play it safe anyway.
    if (adjustedRange.location + adjustedRange.length > length) {
        adjustedRange.length = length - adjustedRange.location - 1;
    }
    
    // Return the adjusted range
    return adjustedRange;
}

@end
