//
//  MessageCell.m
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 11/24/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import "MessageCell.h"
#import "DateHelpers.h"
#import "MessageUtilities.h"

CGFloat const MessageCellTag = 1;

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageInfoLabel;

@end

@implementation MessageCell

+ (CGFloat)cellHeight
{
    return 90.0;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadMessage:(TTMessage *)message
{
    _message = message;

    self.messageStatusLabel.text = _message.status;
    self.messageInfoLabel.text = [NSString stringWithFormat:@"%@ %@",[DateHelpers relativeTimeStampFromDate:_message.createdTime],[DateHelpers messageExpireTimeString:_message.expireTime]];
    
    if (_message.groupStatus) {
        self.messageStatusLabel.text = _message.groupStatus;
    }else {
        self.messageStatusLabel.text = _message.status;
    }
    self.messageStatusLabel.textColor = [MessageUtilities messageStatusColorForMessage:_message];
    self.messageTextLabel.text = [MessageUtilities sanitizeText:message.body];
    [self.avatarView setPathToNetworkImage:self.message.sender.avatarURL forDisplaySize:self.avatarView.size contentMode:UIViewContentModeScaleAspectFill circleCrop:YES];
}

- (void)prepareForReuse
{
    [self.avatarView prepareForReuse];
}

@end
