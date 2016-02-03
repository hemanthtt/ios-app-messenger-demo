//
//  TTGroup.h
//  TTKit
//
//  Created by Oren Zitoun on 9/28/15.
//  Copyright © 2015 TigerText, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTParty.h"

NS_ASSUME_NONNULL_BEGIN

@class TTMessage, TTUser;

/**
 *  TTGroup is a class that represents a TigerText Group or Room.
 */
@interface TTGroup : TTParty

/**
 *  Boolean value. If YES, the group is public and the local user can join it.
 */
@property (nullable, nonatomic, retain) NSNumber *isPublic;

/**
 *  Boolean value. If YES, the local user is a part of this group.
 */
@property (nullable, nonatomic, retain) NSNumber *isUserPartOfGroup;

/**
 *  Boolean value. If YES, the group is a distribution list.
 */
@property (nullable, nonatomic, retain) NSNumber *isDistributionList;

/**
 *  NSSet containing TTUser objects, representing all users which are members of this group.
 */
@property (nullable, nonatomic, retain) NSSet<TTUser *> *members;

/**
 *  Last TTMessage received for this group.
 */
@property (nonatomic, retain) TTMessage *message;

@property (nullable, nonatomic, retain) NSNumber *replayHistory;

/**
 *  Group messages count (only available for public groups/rooms for now).
 */
@property (nullable, nonatomic, retain) NSNumber *messagesCount;

/**
 *  Group members count (only available for public groups/rooms for now).
 */
@property (nullable, nonatomic, retain) NSNumber *roomMembersCount;

/**
 *  Group created date (only available for public groups/rooms for now).
 */
@property (nullable, nonatomic, retain) NSDate *createdTime;

/**
 *  Group description (only available for public groups/rooms for now).
 */
@property (nullable, nonatomic, retain) NSString *groupDescription;

/**
 *  Return the TTUser who created to group (only available for public groups/rooms for now).
 */
@property (nullable, nonatomic, retain) TTUser *createdBy;

- (BOOL)isUserTokenPartOfGroup:(NSString *)token;

- (BOOL)isUserPartOfGroup:(TTUser *)user;

- (void)addMembersAndUpdateApi:(NSSet *)values
                       success:(void (^)(void))success
                       failure:(void (^)(NSError * error))failure;

- (void)removeMember:(TTUser *)value;


@end

@interface TTGroup (CoreDataGeneratedAccessors)

/**
 *  Add a TTUser to this TTGroup.
 *
 *  @param value A TTUser object.
 */
- (void)addMembersObject:(TTUser *)value;

/**
 *  Remove a TTUser from this TTGroup.
 *
 *  @param value A TTUser object.
 */
- (void)removeMembersObject:(TTUser *)value;

/**
 *  Add multiple TTUsers to this TTGroup.
 *
 *  @param values NSSet containing TTUser objects.
 */
- (void)addMembers:(NSSet<TTUser *> *)values;

/**
 *  Remove multiple TTUsers from this group.
 *
 *  @param values NSSet containing TTUser objects.
 */
- (void)removeMembers:(NSSet<TTUser *> *)values;

@end

NS_ASSUME_NONNULL_END
