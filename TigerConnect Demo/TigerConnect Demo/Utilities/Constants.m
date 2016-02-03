//
//  Constants.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

#import "Constants.h"

NSUInteger const kMaxSizeForUpload = 10*1024*1024; // 10MB

UIColor *leadingColor()
{
    return [UIColor colorWithRed:217.0/255.0 green:42.0/255.0 blue:37.0/255.0 alpha:1.0];
}

UIColor *secondaryColor()
{
    return [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
}

UIColor *defaultBlueColor()
{
    return [UIColor colorWithRed:48.0/255.0 green:160.0/255.0 blue:196/255.0 alpha:1.0];
}

UIColor *defaultGreenColor()
{
    return [UIColor colorWithRed:104.0/255.0 green:174.0/255.0 blue:4.0/255.0 alpha:1.0];
}

UIColor *defaultRedColor()
{
    return [UIColor colorWithRed:217.0/255.0 green:42.0/255.0 blue:37.0/255.0 alpha:1.0];
}

UIColor *defaultGrayColor()
{
    return [UIColor colorWithRed:146.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
}

UIColor *defaultLightGrayColor()
{
    return [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
}

UIColor *defaultDarkTextColor()
{
    return [UIColor colorWithRed:22.0/255.0 green:23.0/255.0 blue:24.0/255.0 alpha:1.0];
}

UIFont *lightFont(CGFloat size)
{
    return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
}

UIFont *regularFont(CGFloat size)
{
    return [UIFont systemFontOfSize:size];
}

UIFont *mediumFont(CGFloat size)
{
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

UIFont *boldFont(CGFloat size)
{
    return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

UIFont *messageTextFont()
{
    return [UIFont systemFontOfSize:16];
}

UIFont *bangTextFont()
{
    return [UIFont systemFontOfSize:12];
}

UIFont *messageInputViewFont()
{
    return [UIFont systemFontOfSize:16];
}

UIStatusBarStyle defaultStatusBarStyle()
{
    return UIStatusBarStyleLightContent;
}
