//
//  ConversationCell.h
//  TigerConnect Messenger
//
//  Created by Oren Zitoun on 11/19/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

/**
 @abstract `ConversationCell` presents and manages the presentation of `TTRosterEntry` (Conversation) objects
 @discussion If you wish to change the default font and colors of this cell please refer to `ConversationCell.xib` or refer to `AppearanceUtilities`
 */
@interface ConversationCell : UITableViewCell

/**
 @abstract The TTRosterEntry to be displayed.
 */
@property (nonatomic) TTRosterEntry *item;

/**
 @abstract Conversation name text color.
 */
@property (nonatomic) UIColor *conversationNameTextColor UI_APPEARANCE_SELECTOR;

/**
 @abstract Conversation name font.
 */
@property (nonatomic) UIFont *conversationNameFont UI_APPEARANCE_SELECTOR;

/**
 @abstract Last Message text color.
 */
@property (nonatomic) UIColor *lastMessageTextColor UI_APPEARANCE_SELECTOR;

/**
 @abstract Last Message font.
 */
@property (nonatomic) UIFont *lastMessageFont UI_APPEARANCE_SELECTOR;

/**
 @abstract Last Message timestamp text color.
 */
@property (nonatomic) UIColor *lastMessageTimestampColor UI_APPEARANCE_SELECTOR;

/**
 @abstract Last Message timestamp font.
 */
@property (nonatomic) UIFont *lastMessageTimestampFont UI_APPEARANCE_SELECTOR;

/**
 @abstract Last Message status label font.
 */
@property (nonatomic) UIFont *lastMessageStatusFont UI_APPEARANCE_SELECTOR;

/**
 @abstract returns the cell height.
 */
+ (CGFloat)cellHeight;

@end
