//
//  BadgeView.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import "BadgeView.h"

const NSUInteger unreadLabelMargins = 6.0;

@interface BadgeView ()

@property (nonatomic) UILabel *badgeUnreadLabel;

@end

@implementation BadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor colorFromRGB:0xF84040];
    self.cornerRadius = self.width/2;
    
    self.badgeUnreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.badgeUnreadLabel.backgroundColor = [UIColor clearColor];
    self.badgeUnreadLabel.textColor = [UIColor whiteColor];
    self.badgeUnreadLabel.font = [UIFont systemFontOfSize:10];
    self.badgeUnreadLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeUnreadLabel.centerX = CGRectGetMidX(self.bounds);
    self.badgeUnreadLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.badgeUnreadLabel];
}

- (void)setBadgeCount:(NSUInteger)badgeCount
{
    if (badgeCount == 0) {
        self.badgeUnreadLabel.text = @"";
        return;
    }
    self.badgeUnreadLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)badgeCount];
    self.badgeUnreadLabel.centerX = CGRectGetWidth(self.bounds)/2;
}

@end
