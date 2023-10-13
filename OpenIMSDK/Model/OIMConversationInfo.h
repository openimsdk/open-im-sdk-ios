//
//  OIMConversationInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// Conversation Information
///
@interface OIMConversationBaseInfo : NSObject

@property (nonatomic, nullable, copy) NSString *conversationID;

@end

/// Conversation Information
///
@interface OIMConversationInfo : OIMConversationBaseInfo

@property (nonatomic, assign) OIMConversationType conversationType;

@property (nonatomic, nullable, copy) NSString *userID;

@property (nonatomic, nullable, copy) NSString *groupID;

@property (nonatomic, nullable, copy) NSString *showName;

@property (nonatomic, nullable, copy) NSString *faceURL;

@property (nonatomic, assign) OIMReceiveMessageOpt recvMsgOpt;

@property (nonatomic, assign) NSInteger unreadCount;

@property (nonatomic, assign) OIMGroupAtType groupAtType;

@property (nonatomic, assign) NSInteger latestMsgSendTime;

@property (nonatomic, nullable, copy) NSString *draftText;

@property (nonatomic, assign) NSInteger draftTextTime;

@property (nonatomic, assign) BOOL isPinned;

/**
 *  Whether private chat (burn after reading) is enabled
 */
@property (nonatomic, assign) BOOL isPrivateChat;
/**
 *  Private chat duration
 */
@property (nonatomic, assign) NSTimeInterval burnDuration;

/**
 *  Whether still in the group, return true if left the group
 */
@property (nonatomic, assign) BOOL isNotInGroup;

@property (nonatomic, nullable, copy) NSString *attachedInfo;

@property (nonatomic, nullable, strong) OIMMessageInfo *latestMsg;

@property (nonatomic, nullable, copy) NSString *ex;

@end

/// Do Not Disturb Conversation Information
///
@interface OIMConversationNotDisturbInfo : OIMConversationBaseInfo

/**
 * Do Not Disturb Status
 */
@property (nonatomic, assign) OIMReceiveMessageOpt result;

@end

NS_ASSUME_NONNULL_END
