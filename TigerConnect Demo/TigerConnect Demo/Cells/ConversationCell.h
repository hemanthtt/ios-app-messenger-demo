//
//  ConversationCell.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 11/19/15.
//  Copyright © 2015 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

/**
 @abstract `ConversationCell` presents and manages the presentation of `TTRosterEntry` (Conversation) objects
 */
@interface ConversationCell : UITableViewCell

/**
 @abstract The TTRosterEntry to be displayed.
 */
@property (nonatomic) TTRosterEntry *item;

/**
 @abstract returns the cell height.
 */
+ (CGFloat)cellHeight;

@end
