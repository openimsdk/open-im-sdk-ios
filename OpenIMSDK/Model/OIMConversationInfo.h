//
//  OIMConversationInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// 会话信息
///
@interface OIMConversationBaseInfo : NSObject

@property (nonatomic, nullable, copy) NSString *conversationID;

@end

/// 会话信息
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

/// 是否开启了私聊（阅后即焚）
@property (nonatomic, assign) BOOL isPrivateChat;
// 私聊时长
@property (nonatomic, assign) NSTimeInterval burnDuration;

/// 是否还在组内，如果退群返回true
@property (nonatomic, assign) BOOL isNotInGroup;

@property (nonatomic, nullable, copy) NSString *attachedInfo;

@property (nonatomic, nullable, strong) OIMMessageInfo *latestMsg;

@property (nonatomic, nullable, copy) NSString *ex;

@end

/// 免打扰会话信息
///
@interface OIMConversationNotDisturbInfo : OIMConversationBaseInfo

/*
 * 免打扰状态
 */
@property (nonatomic, assign) OIMReceiveMessageOpt result;

@end

NS_ASSUME_NONNULL_END
