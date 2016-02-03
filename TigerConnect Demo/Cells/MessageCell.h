//
//  MessageCell.h
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 11/24/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>
#import "MessageLoading.h"

/**
 @abstract `MessageCell` is the base class for presenting message text, attachments and more. This class is sublclassed by `OutgoingMessageCell` and `IncomingMessageCell`
 */
@interface MessageCell : UITableViewCell <MessageLoading>

/**
 @abstract TTMessage object to be displayed in the cell.
 */
@property (nonatomic) TTMessage *message;

///-------------------------------------------------------
/// @name UI Configuration
///-------------------------------------------------------

/**
 @abstract Get the cell height.
 */
+ (CGFloat)cellHeight;

///-------------------------------------------------------
/// @name UI elements
///-------------------------------------------------------

/**
 @abstract Message sender avatar view.
 */
@property (weak, nonatomic) IBOutlet TTImageView *avatarView;

/**
 @abstract Messaege status label (i.e sent,delivered,read).
 */
@property (weak, nonatomic) IBOutlet UILabel *messageStatusLabel;

/**
 @abstract Messaege sender name label.
 */
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;

/**
 @abstract Messaege text label.
 */
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;

@end
