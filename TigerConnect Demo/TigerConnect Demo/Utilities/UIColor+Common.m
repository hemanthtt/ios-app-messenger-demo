//
//  UIColor+Common.m
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 12/14/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor *)colorFromRGB:(NSUInteger)rgbValue
{
    return [self colorFromRGB:rgbValue alpha:1.0];
}

+ (UIColor *)colorFromRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbValue & 0xFF)) / 255.0
                           alpha:alpha];
}

@end
