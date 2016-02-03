//
//  UIColor+Common.h
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 12/14/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Common)

+ (UIColor *)colorFromRGB:(NSUInteger)rgbValue;
+ (UIColor *)colorFromRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha;

@end
