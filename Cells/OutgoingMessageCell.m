//
//  OutgoingMessageCell.m
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 12/14/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import "OutgoingMessageCell.h"

@implementation OutgoingMessageCell

- (void)loadMessage:(TTMessage *)message {
    [super loadMessage:message];
    self.messageTextLabel.textColor = [UIColor grayColor];
    self.senderNameLabel.text = @" ";
}

@end
