//
//  MessageUtilities.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

#import "MessageUtilities.h"

@implementation MessageUtilities

+ (UIColor *)messageStatusColorForMessage:(TTMessage *)message
{
    UIColor *statusColor = defaultGrayColor();
    if (message.groupStatus) {
        statusColor = defaultGreenColor();
    } else if ([message.status isEqualToString:kTTKitMessageStatusDelivered]) {
        statusColor = defaultBlueColor();
    } else if ([message.status isEqualToString:kTTKitMessageStatusFailed]) {
        statusColor = defaultRedColor();
    } else if ([message.status isEqualToString:kTTKitMessageStatusSent]) {
        statusColor = defaultBlueColor();
    } else if ([message.status isEqualToString:kTTKitMessageStatusRead]) {
        statusColor = defaultGreenColor();
    }
    return statusColor;
}

+ (NSString *)sanitizeText:(NSString *)text
{
    if (!text || text.length == 0) return text;
    
    NSString *noWhiteSpaceString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [noWhiteSpaceString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

@end
