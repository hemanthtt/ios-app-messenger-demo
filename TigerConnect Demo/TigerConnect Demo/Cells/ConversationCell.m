//
//  ConversationCell.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 11/19/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <TTKit/TTImageView.h>

#import "ConversationCell.h"
#import "DateHelpers.h"

@interface ConversationCell ()

@property (weak, nonatomic) IBOutlet TTImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *conversationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageTimestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *unreadBadgeView;
@property (weak, nonatomic) IBOutlet UILabel *unreadBadgeCountLabel;

@property (nonatomic) TTBadgeData *badgeData;

@end

@implementation ConversationCell

+ (CGFloat)cellHeight
{
    return 73.0;
}

- (void)dealloc
{
    [_badgeData prepareForReuse];
    _badgeData = nil;
}

- (void)setItem:(TTRosterEntry *)item
{
    _item = item;
    
    self.conversationNameLabel.text = _item.target.displayName;
    if (_item.latestMessage.body.length > 0) {
        self.lastMessageLabel.text = [self sanitizeLastMessageText:_item.latestMessage.body];
    } else {
        self.lastMessageLabel.text = [self lastMessageStringForAttachment:_item.latestMessage.attachmentDescriptors.firstObject];
    }
    
    if ([[TTKit sharedInstance] isUserLocalUser:(TTUser *)_item.latestMessage.sender]) {
        [self setLastMessageStatus:_item.latestMessage.status];
    } else {
        self.lastMessageStatusLabel.text = @" ";
    }
    
    [self setUnreadBadge];
    self.lastMessageTimestampLabel.text = [DateHelpers relativeTimeStampFromDate:_item.latestMessage.createdTime];
    
    [self.avatarImageView setPathToNetworkImage:_item.target.avatarURL forDisplaySize:self.avatarImageView.frame.size  contentMode:UIViewContentModeScaleAspectFill circleCrop:YES];
}

- (void)setUnreadBadge
{
    self.badgeData.updateUnreadCountBlock = nil;
    self.badgeData = nil;
    self.badgeData = [[TTKit sharedInstance] badgeDataForConversationHash:_item.conversationHash];
    [self updateUnreadCount:self.badgeData.unreadCount];
    
    __weak __typeof(self) weakSelf = self;
    self.badgeData.updateUnreadCountBlock = ^void(NSUInteger unreadCount){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateUnreadCount:unreadCount];
        });
    };
}

- (void)updateUnreadCount:(NSUInteger)unreadMessagesCountForConversation
{
    if (unreadMessagesCountForConversation > 0) {
        self.unreadBadgeView.hidden = NO;
        self.unreadBadgeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)unreadMessagesCountForConversation];
    } else {
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

- (void)setLastMessageStatus:(NSString *)status
{
    NSString *text = @" ";
    UIColor *color = [UIColor whiteColor];
    
    if ([status isEqualToString:kTTKitMessageStatusRead]) {
        text = @"Read";
        color = defaultGreenColor();
    } else if ([status isEqualToString:kTTKitMessageStatusDelivered]) {
        text = @"Delivered";
        color = defaultBlueColor();
    } else if ([status isEqualToString:kTTKitMessageStatusSending]) {
        text = @"Sending...";
        color = defaultGrayColor();
    } else if ([status isEqualToString:kTTKitMessageStatusSent]) {
        text = @"Sent";
        color = defaultBlueColor();
    } else if ([status isEqualToString:kTTKitMessageStatusFailed]) {
        text = @"Message Failed";
        color = defaultRedColor();
    }
    
    self.lastMessageStatusLabel.text = text;
    self.lastMessageStatusLabel.textColor = color;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.avatarImageView prepareForReuse];
    [self.badgeData prepareForReuse];
    self.unreadBadgeView.hidden = YES;
    self.unreadBadgeCountLabel.text = @"";
}

- (NSString *)sanitizeLastMessageText:(NSString *)text
{
    if (text.length == 0) return nil;
    
    NSString *sanitizedText = [text stringByReplacingOccurrencesOfString:@" \n" withString:@" "];
    sanitizedText = [sanitizedText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSString *senderDisplayName = _item.latestMessage.sender.displayName;
    if (senderDisplayName.length > 0 && [_item.target isKindOfClass:[TTGroup class]]) {
        NSString *firstNameOfSender = [[senderDisplayName componentsSeparatedByString:@" "] firstObject];
        sanitizedText = firstNameOfSender ? [NSString stringWithFormat:@"%@: %@",firstNameOfSender, sanitizedText] : sanitizedText;
    }
    return sanitizedText;
}

- (NSString *)lastMessageStringForAttachment:(TTAttachmentDescriptor *)attachment
{
    NSString *string = nil;
    TTAttachmentType type = attachment.type.integerValue;
    switch (type) {
        case TTAttachmentTypeAudio:
            string = @"Audio Message";
            break;
            
        case TTAttachmentTypeVideo:
            string = @"Video Message";
            break;
            
        case TTAttachmentTypeDocument:
            string = @"Document Message";
            break;
            
        case TTAttachmentTypeImage:
            string = @"Image Message";
            break;
            
        default:
            break;
    }
    return string;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = highlighted ? defaultLightGrayColor() : [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.backgroundColor = selected ? defaultLightGrayColor() : [UIColor whiteColor];
}

@end
