//
//  OrganizationCell.m
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 11/20/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import "OrganizationCell.h"

@interface OrganizationCell ()

@property (weak, nonatomic) IBOutlet UILabel *organizationNameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *unreadBadgeView;
@property (weak, nonatomic) IBOutlet UILabel *unreadBadgeCountLabel;
@property (nonatomic) TTBadgeData *badgeData;

@end

@implementation OrganizationCell

+ (CGFloat)cellHeight
{
    return 60.0;
}

- (void)awakeFromNib
{
    self.selectedIndicatorView.backgroundColor = self.selectedIndicatorViewColor ?: leadingColor();
}

- (void)setItem:(TTOrganization *)item
{
    _item = item;
    self.organizationNameLabel.text = _item.name;
    UIFont *font = nil;
    UIColor *textColor = nil;
    if ([_item.token isEqualToString:[[TTKit sharedInstance] currentOrganizationToken]]) {
        font = self.selectedOrganizationNameLabelFont ?: mediumFont(self.organizationNameLabel.font.pointSize);
        textColor = self.selectedOrganizationNameLabelColor ?: [UIColor blackColor];
        self.backgroundColor = self.selectedCellBackgroundColor ?: [UIColor colorFromRGB:0xFDEBA9];
        self.selectedIndicatorView.hidden = NO;
    }
    else {
        font = self.organizationNameLabelFont ?: regularFont(self.organizationNameLabel.font.pointSize);
        textColor = self.organizationNameLabelColor ?: defaultGrayColor();
        self.backgroundColor = [UIColor whiteColor];
        self.selectedIndicatorView.hidden = YES;
    }
    [self setUnreadBadge];
    self.organizationNameLabel.font = font;
    self.organizationNameLabel.textColor = textColor;
}

// Setting the unread messages count badge
- (void)setUnreadBadge
{
    self.badgeData = [[TTKit sharedInstance] badgeDataForOrganizationToken:_item.token];
    [self updateUnreadCount:self.badgeData.unreadCount];
    
    __weak __typeof(self) weakSelf = self;
    self.badgeData.updateUnreadCountBlock = ^void(NSUInteger unreadCount) {
        [weakSelf updateUnreadCount:unreadCount];
    };
}

- (void)updateUnreadCount:(NSUInteger)unreadMessagesCountForConversation
{
    if (unreadMessagesCountForConversation > 0) {
        self.unreadBadgeView.hidden = NO;
        self.unreadBadgeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)unreadMessagesCountForConversation];
    }
    else {
        self.unreadBadgeView.hidden = YES;
        self.unreadBadgeCountLabel.text = @"";
    }
    
    self.unreadBadgeView.layer.cornerRadius = MAX(CGRectGetHeight(self.unreadBadgeView.frame), 19)/2;
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.unreadBadgeView setNeedsLayout];
    [self.unreadBadgeView layoutIfNeeded];
    self.unreadBadgeView.layer.cornerRadius = MAX(CGRectGetHeight(self.unreadBadgeView.frame), 19)/2;
}

- (void)prepareForReuse
{
    [self.badgeData prepareForReuse];
    self.unreadBadgeView.hidden = YES;
    self.unreadBadgeCountLabel.text = @"";
    [super prepareForReuse];
}

#pragma mark - UIAppearance

- (void)setOrganizationNameLabelColor:(UIColor *)organizationNameLabelColor
{
    _organizationNameLabelColor = organizationNameLabelColor;
    
    if (![_item.token isEqualToString:[[TTKit sharedInstance] currentOrganizationToken]]) {
        self.organizationNameLabel.textColor = _organizationNameLabelColor;
    }
}

- (void)setOrganizationNameLabelFont:(UIFont *)organizationNameLabelFont
{
    _organizationNameLabelFont = organizationNameLabelFont;
    
    if (![_item.token isEqualToString:[[TTKit sharedInstance] currentOrganizationToken]]) {
        self.organizationNameLabel.font = _organizationNameLabelFont;
    }
}

- (void)setSelectedOrganizationNameLabelColor:(UIColor *)selectedOrganizationNameLabelColor
{
    _selectedOrganizationNameLabelColor = selectedOrganizationNameLabelColor;
    
    if ([_item.token isEqualToString:[[TTKit sharedInstance] currentOrganizationToken]]) {
        self.organizationNameLabel.textColor = _selectedOrganizationNameLabelColor;
    }
}

- (void)setSelectedOrganizationNameLabelFont:(UIFont *)selectedOrganizationNameLabelFont
{
    _selectedOrganizationNameLabelFont = selectedOrganizationNameLabelFont;
    
    if ([_item.token isEqualToString:[[TTKit sharedInstance] currentOrganizationToken]]) {
        self.organizationNameLabel.font = _selectedOrganizationNameLabelFont;
    }
}

- (void)setSelectedIndicatorViewColor:(UIColor *)selectedIndicatorViewColor
{
    _selectedIndicatorViewColor = selectedIndicatorViewColor;
    self.selectedIndicatorView.backgroundColor = _selectedIndicatorViewColor;
}

- (void)setSelectedCellBackgroundColor:(UIColor *)selectedCellBackgroundColor
{
    _selectedCellBackgroundColor = selectedCellBackgroundColor;
    
    if ([_item.token isEqualToString:[[TTKit sharedInstance] currentOrganizationToken]]) {
        self.backgroundColor = _selectedCellBackgroundColor;
    }
}

@end
