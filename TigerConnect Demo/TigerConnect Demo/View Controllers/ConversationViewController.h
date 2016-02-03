//
//  ConversationViewController.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <TTKit/TTKit.h>

/**
 @abstract The `ConversationViewController` displays message cells and other user interface components associated with a conversation and more.
 */
@interface ConversationViewController : UIViewController

///----------------------------------------------
/// @name Initializing
///----------------------------------------------

/**
 @abstract The 'TTRosterEntry' object will represent the conversation and messages this controller will display
 */
@property (nonatomic) TTRosterEntry *rosterEntry;

/**
 @abstract The 'TTUser' object will be used to initialize this controller and will represent the P2P conversation this controller will display
 */
@property (nonatomic) TTUser *user;

@end
