//
//  OrganizationsBarButtonView.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import "OrganizationsBarButtonView.h"
#import "UIHelpers.h"

#import <TTKit/TTKit.h>

@interface OrganizationsBarButtonView ()

@property (nonatomic) UIImageView *organizationsImageView;
@property (nonatomic) UIView *unreadMessagesBadge;

@end

@implementation OrganizationsBarButtonView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)barView
{
    OrganizationsBarButtonView *view = [[OrganizationsBarButtonView alloc] initWithFrame:CGRectMake(0, 0, 26, 25)];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.organizationsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        self.organizationsImageView.left = 0;
        self.organizationsImageView.bottom = CGRectGetHeight(frame);
        self.organizationsImageView.image = [[UIImage imageNamed:@"orgs"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.organizationsImageView.tintColor = [UIColor whiteColor];
        [self addSubview:self.organizationsImageView];
        
        self.unreadMessagesBadge = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.unreadMessagesBadge.backgroundColor = [UIColor colorFromRGB:0xff3838];
        self.unreadMessagesBadge.cornerRadius = 4.0f;
        self.unreadMessagesBadge.borderColor = [UIColor whiteColor];
        self.unreadMessagesBadge.borderWidth = 1.0f;
        self.unreadMessagesBadge.right = CGRectGetMaxX(frame);
        self.unreadMessagesBadge.top = 0;
        [self addSubview:self.unreadMessagesBadge];
        [self refreshBadge];
        [self registerNotifications];
        
        UIButton *overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        overlayButton.backgroundColor = [UIColor clearColor];
        [overlayButton addTarget:self action:@selector(onOverlayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:overlayButton];
    }
    return self;
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshBadge)
                                                 name:kTTKitUnreadMessagesCountChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshBadge)
                                                 name:kTTKitCurrentOrganizationChangeNotification
                                               object:nil];
}

- (void)refreshBadge
{
    NSUInteger unreadCount = 0;
    NSString *currentOrgToken = [[TTKit sharedInstance] currentOrganizationToken];
    if(currentOrgToken) {
        TTBadgeData *orgBadgeData = [[TTKit sharedInstance] badgeDataForOrganizationToken:currentOrgToken];
        unreadCount = orgBadgeData.unreadCount;
    }
    
    NSUInteger totalUnreadCount = [[TTKit sharedInstance] getTotalUnreadMessageCount];
    if(totalUnreadCount - unreadCount > 0) {
        self.unreadMessagesBadge.hidden = NO;
    } else {
        self.unreadMessagesBadge.hidden = YES;
    }
}

- (void)onOverlayButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(organizationBarButtonPressed:)]) {
        [self.delegate organizationBarButtonPressed:self];
    }
}

@end
