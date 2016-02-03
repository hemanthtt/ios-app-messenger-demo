//
//  IncomingMessageCell.m
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 12/14/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import "IncomingMessageCell.h"

@implementation IncomingMessageCell

- (void)loadMessage:(TTMessage *)message {
    [super loadMessage:message];
    self.messageTextLabel.textColor = [UIColor blackColor];
    self.senderNameLabel.text = self.message.sender.displayName;
}

@end
