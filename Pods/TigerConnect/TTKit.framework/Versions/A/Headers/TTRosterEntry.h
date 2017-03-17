//
//  TTRosterEntry.h
//  TTKit
//
//  Created by Oren Zitoun on 2/24/16.
//  Copyright © 2016 TigerText, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTMessage, TTOrganization, TTParty;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A TTRosterEntry is a conversation. The conversation may have several properties which are detailed below. A TTRosterEntry must always have a target, which can be a TTUser or a TTGroup (both inherit from TTParty).
 */
@interface TTRosterEntry : NSManagedObject

/**
 *  URL of the TTRosterEntry’s avatar.
 */
@property (nullable, nonatomic, retain) NSString * avatarUrl;

/**
 *  Conversation hash. Can be used to retrieve related objects, such as TTMessages.
 */
@property (nullable, nonatomic, retain) NSString * conversationHash;

/**
 *  Display name of the roster entry.
 */
@property (nullable, nonatomic, retain) NSData * encryptedDisplayName;

/**
 *  Display name of the roster entry.
 */
@property (nullable, nonatomic, retain) NSString * displayName;

/**
 *  When set to YES, TTRosterEntry can only be deleted locally. Default is NO.
 */
@property (nullable, nonatomic, retain) NSNumber * ignoreApiUpdate;

/**
 *  YES if the TTRosterEntry’s target is a TTGroup.
 */
@property (nullable, nonatomic, retain) NSNumber * isGroup;

/**
 *  YES if the TTRosterEntry’s target is a TTUser.
 */
@property (nullable, nonatomic, retain) NSNumber * isUser;

/**
 *  Organization token of the TTOrganization to which the TTRosterEntry belongs to.
 */
@property (nullable, nonatomic, retain) NSString * organizationToken;

/**
 *  Latest message received or sent for this TTRosterEntry. Epoch format.
 */
@property (nullable, nonatomic, retain) NSNumber * timestamp;

/**
 *  TTRosterEntry token. Internal, use conversationHash instead.
 */
@property (nullable, nonatomic, retain) NSString * token;

/**
 *  When set to YES, TTRosterEntry can only be deleted locally. Default is NO.
 */
@property (nullable, nonatomic, retain) NSString * title;

/**
 *  When set to YES, TTRosterEntry can only be deleted locally. Default is NO.
 */
@property (nullable, nonatomic, retain) NSString * department;

/**
 *  Latest TTMessage related to this TTRosterEntry.
 */
@property (nullable, nonatomic, retain) TTMessage *latestMessage;

/**
 *  TTOrganization related to this TTRosterEntry.
 */
@property (nullable, nonatomic, retain) TTOrganization *organization;

/**
 *  The target of the TTRosterEntry. Can be a TTUser or a TTGroup (both inherit from TTParty).
 */
@property (nullable, nonatomic, retain) TTParty *target;

/**
 *  Do not disturb state
 */
@property (nullable, nonatomic, retain) NSNumber * dnd;

/**
 *  Do not disturb text
 */
@property (nullable, nonatomic, retain) NSString * dndText;

/**
 *  Original Autoforwarding receiver token set by the roster target user in a P2P conversation.
 */
@property (nullable, nonatomic, retain) NSString * autoforwardReceiver;

/**
 *  Indicates if the Roster has unread priority messages.
 */
@property (nullable, nonatomic, retain) NSNumber *priority;

/**
 *  Convenience getter for autoforwardReceiver is non-empty, when autoforward is enabled.
 */
@property (readonly) BOOL autoforward;

@end

NS_ASSUME_NONNULL_END