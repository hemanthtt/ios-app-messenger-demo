//
//  ConversationBackView.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

#import "ConversationBackView.h"
#import "BadgeView.h"

@interface ConversationBackView ()

@property (nonatomic) UIImageView *backArrowImageView;
@property (nonatomic) NSString *conversationHash;
@property (nonatomic) NSUInteger initialUnreadCount;
@property (nonatomic) BadgeView *badgeView;

@end

@implementation ConversationBackView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)conversationBackViewWithConversationHash:(NSString *)conversationHash
{
    ConversationBackView *view = [[ConversationBackView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    view.conversationHash = conversationHash;
    [view refreshBadge];
    [view registerNotifications];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8*1.2, 14*1.2)];
        self.backArrowImageView.left = 10;
        self.backArrowImageView.centerY = CGRectGetMidY(frame);
        self.backArrowImageView.backgroundColor = [UIColor clearColor];
        self.backArrowImageView.image = [[UIImage imageNamed:@"back-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.backArrowImageView.tintColor = [UIColor whiteColor];
        [self addSubview:self.backArrowImageView];
        
        self.badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        self.badgeView.left = self.backArrowImageView.right + 5;
        self.badgeView.centerY = self.backArrowImageView.centerY;
        [self addSubview:self.badgeView];
        
        UIButton *overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
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
}

- (void)refreshBadge
{
    NSUInteger organizationUnreadCount = 0;
    NSString *currentOrgToken = [[TTKit sharedInstance] currentOrganizationToken];
    if(currentOrgToken) {
        TTBadgeData *orgBadgeData = [[TTKit sharedInstance] badgeDataForOrganizationToken:currentOrgToken];
        organizationUnreadCount = orgBadgeData.unreadCount;
    }
    
    NSInteger count = [[[TTKit sharedInstance] badgeDataForConversationHash:self.conversationHash] unreadCount];
    NSUInteger unreadCount = organizationUnreadCount - count;
    if (unreadCount > 0) {
        self.badgeView.hidden = NO;
        [self.badgeView setBadgeCount:unreadCount];
    } else {
        self.badgeView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.badgeView setNeedsLayout];
}

- (void)onOverlayButtonPressed:(id)sender
{
    UINavigationController *nav = (UINavigationController *)[self firstAvailableUIViewController];
    [nav popViewControllerAnimated:YES];
}

@end
