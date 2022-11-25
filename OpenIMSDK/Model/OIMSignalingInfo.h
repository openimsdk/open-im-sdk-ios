//
//  OIMSignalingInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/3/17.
//

#import <Foundation/Foundation.h>
#import "OIMMessageInfo.h"
#import "OIMFullUserInfo.h"
#import "OIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMInvitationInfo : NSObject

/*
 *  被邀请者UserID列表，如果是单聊只有一个元素
 */
@property (nonatomic, copy) NSArray <NSString *> *inviteeUserIDList;

/*
 *  房间ID，必须唯一
 */
@property (nonatomic, copy) NSString *roomID;

/*
 *  邀请超时时间（秒）,默认1000
 */
@property (nonatomic, assign) NSInteger timeout;

/*
 *  video 或者 audio
 */
@property (nonatomic, copy) NSString *mediaType;

/*
 *  1为单聊，2为群聊
 */
@property (nonatomic, assign) OIMConversationType sessionType;


@property (nonatomic, assign) OIMPlatform platformID;

/*
 *  邀请者UserID
 */
@property (nonatomic, copy) NSString *inviterUserID;

/*
 *  如果是单聊，为""
 */
@property (nonatomic, copy) NSString *groupID;

/*
 *  发起时间
 */
@property (nonatomic, assign) NSTimeInterval initiateTime;


- (BOOL)isVideo;

@end


@interface OIMInvitationResultInfo : NSObject

/*
 *  token
 */
@property (nonatomic, copy) NSString *token;

/*
 *  房间ID，必须唯一，可以不设置。
 */
@property (nonatomic, copy) NSString *roomID;

/*
 *  直播地址
 */
@property (nonatomic, copy) NSString *liveURL;

/*
 * 占线列表
 */
@property (nonatomic, copy) NSArray<NSString *>* busyLineUserIDList;

@end


@interface OIMSignalingInfo : NSObject

@property (nonatomic, copy) NSString *opUserID;

@property (nonatomic, strong) OIMInvitationInfo *invitation;

@property (nonatomic, strong) OIMOfflinePushInfo *offlinePushInfo;

@end


/// 参与者信息
@interface OIMParticipantMetaData : NSObject

@property (nonatomic, strong) OIMGroupInfo *groupInfo;

@property (nonatomic, strong) OIMGroupMemberInfo *groupMemberInfo;

@property (nonatomic, strong) OIMPublicUserInfo *publicUserInfo;

@property (nonatomic, strong) OIMPublicUserInfo *userInfo;
@end

@interface OIMParticipantConnectedInfo : NSObject

@property (nonatomic, copy) NSString *groupID;

@property (nonatomic, strong) OIMInvitationInfo *invitation;

@property (nonatomic, copy) NSArray<OIMParticipantMetaData *> *metaData;

// --- 查询房间 ---
@property (nonatomic, copy) NSArray<OIMParticipantMetaData *> *participant;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *roomID;

@property (nonatomic, copy) NSString *liveURL;

@end

// 会议相关
@interface OIMMeetingInfo : NSObject

@property (nonatomic, copy) NSString *meetingID;
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, copy) NSString *hostUserID;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, assign) BOOL participantCanEnableVideo;
@property (nonatomic, assign) BOOL onlyHostInviteUser;
@property (nonatomic, assign) BOOL joinDisableVideo;
@property (nonatomic, assign) BOOL participantCanUnmuteSelf;
@property (nonatomic, assign) BOOL isMuteAllMicrophone;
@property (nonatomic, copy) NSArray<NSString *> *inviteeUserIDList;
@end

@interface OIMMeetingInfoList : NSObject
@property (nonatomic, copy) NSArray<OIMMeetingInfo *> *meetingInfoList;
@end

@interface OIMMeetingStreamEvent : NSObject

@property (nonatomic, copy) NSString *meetingID;
@property (nonatomic, copy) NSString *streamType;
@property (nonatomic, assign) BOOL mute;
@end

NS_ASSUME_NONNULL_END
