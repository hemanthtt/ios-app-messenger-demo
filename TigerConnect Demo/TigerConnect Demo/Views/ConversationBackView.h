//
//  ConversationBackView.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @abstract `ConversationBackView` handles the display of the back arrow and unread badge count in the conversation navigation bar.
 */
@interface ConversationBackView : UIView

+ (instancetype)conversationBackViewWithConversationHash:(NSString *)conversationHash;

@end
