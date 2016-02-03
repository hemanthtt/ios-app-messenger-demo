//
//  MessageUtilities.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

@interface MessageUtilities : NSObject

+ (UIColor *)messageStatusColorForMessage:(TTMessage *)message;
+ (NSString *)sanitizeText:(NSString *)text;

@end
