//
//  BadgeView.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @abstract `BadgeView` displays a circular view with a label in the center
 @discussion You can use `BadgeView` to display unread messages counts in cells or other views.
 */
@interface BadgeView : UIView

/**
 @abstract Set the label badge count.
 @param badgeCount The count you wish to display.
 */
- (void)setBadgeCount:(NSUInteger)badgeCount;

@end
