//
//  OIMCallbacker.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

#import "OIMDefine.h"
#import "OIMUserInfo.h"
#import "OIMFullUserInfo.h"
#import "OIMFriendApplication.h"
#import "OIMGroupApplicationInfo.h"
#import "OIMGroupInfo.h"
#import "OIMGroupMemberInfo.h"
#import "OIMConversationInfo.h"
#import "OIMMessageInfo.h"
#import "OIMSearchParam.h"
#import "OIMSearchResultInfo.h"
#import "OIMSimpleResultInfo.h"
#import "OIMSimpleRequstInfo.h"
#import "OIMSignalingInfo.h"
#import "OIMDepartmentInfo.h"

@import OpenIMCore;

NS_ASSUME_NONNULL_BEGIN


typedef void (^OIMSimpleResultCallback)(OIMSimpleResultInfo * _Nullable result);
typedef void (^OIMSimpleResultsCallback)(NSArray <OIMSimpleResultInfo *> * _Nullable results);

typedef void (^OIMUserInfoCallback)(OIMUserInfo * _Nullable userInfo);
typedef void (^OIMUsersInfoCallback)(NSArray <OIMUserInfo *> * _Nullable usersInfo);
typedef void (^OIMUsersCallback)(NSArray <OIMFullUserInfo *> * _Nullable userInfos);
typedef void (^OIMFullUserInfoCallback)(OIMFullUserInfo * _Nullable userInfo);
typedef void (^OIMFullUsersInfoCallback)(NSArray <OIMFullUserInfo *> * _Nullable userInfos);
typedef void (^OIMBlacksInfoCallback)(NSArray <OIMBlackInfo *> * _Nullable blackInfos);

typedef void (^OIMFriendApplicationCallback)(OIMFriendApplication * _Nullable friendApplication);
typedef void (^OIMFriendApplicationsCallback)(NSArray <OIMFriendApplication *> * _Nullable friendApplications);

typedef void (^OIMFriendInfoCallback)(OIMFriendInfo * _Nullable friendInfo);
typedef void (^OIMFriendsInfoCallback)(NSArray<OIMFriendInfo *> * _Nullable friendInfo);
typedef void (^OIMBlackInfoCallback)(OIMBlackInfo * _Nullable blackInfo);
typedef void (^OIMBlacksInfoCallback)(NSArray<OIMBlackInfo *> * _Nullable blackInfo);
typedef void (^OIMSearchUsersInfoCallback)(NSArray<OIMSearchFriendsInfo *> * _Nullable usersInfo);

typedef void (^OIMGroupApplicationCallback)(OIMGroupApplicationInfo * _Nullable groupApplication);
typedef void (^OIMGroupsApplicationCallback)(NSArray <OIMGroupApplicationInfo *> * _Nullable groupsInfo);
typedef void (^OIMGroupInfoCallback)(OIMGroupInfo * _Nullable groupInfo);
typedef void (^OIMGroupsInfoCallback)(NSArray <OIMGroupInfo *> * _Nullable groupsInfo);
typedef void (^OIMGroupMemberInfoCallback)(OIMGroupMemberInfo * _Nullable groupMemberInfo);
typedef void (^OIMGroupMembersInfoCallback)(NSArray <OIMGroupMemberInfo *> * _Nullable groupMembersInfo);

typedef void (^OIMConversationsInfoCallback)(NSArray <OIMConversationInfo *> * _Nullable conversations);
typedef void (^OIMConversationInfoCallback)(OIMConversationInfo * _Nullable conversation);
typedef void (^OIMConversationNotDisturbInfoCallback)(NSArray <OIMConversationNotDisturbInfo *> * _Nullable conversations);

typedef void (^OIMMessageInfoCallback)(OIMMessageInfo * _Nullable message);
typedef void (^OIMMessagesInfoCallback)(NSArray <OIMMessageInfo *> * _Nullable messages);
typedef void (^OIMMessageSearchCallback)(OIMSearchResultInfo * _Nullable result);

typedef void (^OIMReceiptCallback)(NSArray <OIMReceiptInfo *> * _Nullable msgReceiptList);
typedef void (^OIMRevokedCallback)(OIMMessageRevokedInfo * _Nullable msgRovoked);

typedef void (^OIMSignalingInvitationCallback)(OIMSignalingInfo * _Nullable result);
typedef void (^OIMSignalingResultCallback)(OIMInvitationResultInfo * _Nullable result);
typedef void (^OIMSignalingParticipantChangeCallback)(OIMParticipantConnectedInfo * _Nullable result);
typedef void (^OIMSignalingMeetingsInfoCallback)(OIMMeetingInfoList * _Nullable result);
typedef void (^OIMSignalingMeetingStreamEventCallback)(OIMMeetingStreamEvent * _Nullable result);

typedef void (^OIMDepartmentInfoCallback)(NSArray <OIMDepartmentInfo *> * _Nullable departmentList);
typedef void (^OIMDepartmentMembersInfoCallback)(NSArray <OIMDepartmentMemberInfo *> * _Nullable members);
typedef void (^OIMUserInDepartmentInfoCallback)(NSArray <OIMUserInDepartmentInfo *> * _Nullable members);
typedef void (^OIMDepartmentMemberAndSubInfoCallback)(OIMDepartmentMemberAndSubInfo * _Nullable items);

typedef void (^OIMGetAdvancedHistoryMessageListCallback)(OIMGetAdvancedHistoryMessageListInfo * _Nullable result);
typedef void (^OIMKeyValueResultCallback)(NSString * _Nullable msgID, NSArray <OIMKeyValue *> * _Nullable result);
typedef void (^OIMKeyValuesResultCallback)(NSArray <OIMKeyValues *> * _Nullable result);
/// IMSDK 主核心回调
@protocol OIMSDKListener <NSObject>
@optional
/*
 *  SDK 正在连接到服务器
 */
- (void)onConnecting;

/*
 * SDK 已经成功连接到服务器
 */
- (void)onConnectSuccess;

/*
 * SDK 连接服务器失败
 */
- (void)onConnectFailed:(NSInteger)code err:(NSString*)err;

/*
 * 当前用户被踢下线，此时可以 UI 提示用户
 */
- (void)onKickedOffline;

/*
 * 在线时票据过期：此时您需要生成新的 UserToken 并再次重新登录。
 */
- (void)onUserTokenExpired;

@end

/// 资料关系链回调
@protocol OIMFriendshipListener <NSObject>
@optional

/*
 *  好友申请新增通知
 */
- (void)onFriendApplicationAdded:(OIMFriendApplication *)application;

/*
 *  好友申请被拒绝
 */
- (void)onFriendApplicationRejected:(OIMFriendApplication *)application;

/*
 *  好友申请被接受
 */
- (void)onFriendApplicationAccepted:(OIMFriendApplication *)application;

/*
 *  好友申请被删除
 */
- (void)onFriendApplicationDeleted:(OIMFriendApplication *)application;

/*
 *  好友新增通知
 */
- (void)onFriendAdded:(OIMFriendInfo *)info;

/*
 *  好友删除通知
 */
- (void)onFriendDeleted:(OIMFriendInfo *)info;

/*
 *  好友资料变更通知
 */
- (void)onFriendInfoChanged:(OIMFriendInfo *)info;

/*
 *  黑名单新增通知
 */
- (void)onBlackAdded:(OIMBlackInfo *)info;

/*
 *  黑名单删除通知
 */
- (void)onBlackDeleted:(OIMBlackInfo *)info;

@end

/// IMSDK 群组事件回调
@protocol OIMGroupListener <NSObject>
@optional

/*
 *  有新成员加入群
 */
- (void)onGroupMemberAdded:(OIMGroupMemberInfo *)memberInfo;

/*
 *  有成员离开群
 */
- (void)onGroupMemberDeleted:(OIMGroupMemberInfo *)memberInfo;

/*
 *  某成员信息发生变更
 */
- (void)onGroupMemberInfoChanged:(OIMGroupMemberInfo *)changeInfo;

/*
 *  例如有邀请进群， UI列表会展示新的item
 */
- (void)onJoinedGroupAdded:(OIMGroupInfo *)groupInfo;

/*
 *  例如群里被踢， UI列表会删除这个的item
 */
- (void)onJoinedGroupDeleted:(OIMGroupInfo *)groupInfo;

/*
 *  某个已加入的群的信息被修改了
 */
- (void)onGroupInfoChanged:(OIMGroupInfo *)changeInfo;

/*
 *  群申请被接受
 */
- (void)onGroupApplicationAccepted:(OIMGroupApplicationInfo *)groupApplication;

/*
 *  有人申请加群
 */
- (void)onGroupApplicationAdded:(OIMGroupApplicationInfo *)groupApplication;

/*
 *  群申请有删除
 */
- (void)onGroupApplicationDeleted:(OIMGroupApplicationInfo *)groupApplication;

/*
 *  群申请有拒绝
 */
- (void)onGroupApplicationRejected:(OIMGroupApplicationInfo *)groupApplication;

/**
 群解散
 */
- (void)onGroupDismissed:(OIMGroupInfo *)changeInfo;

@end

@protocol OIMConversationListener <NSObject>
@optional

/*
 * 同步服务器会话开始
 */
- (void)onSyncServerStart;

/*
 * 同步服务器会话完成
 */
- (void)onSyncServerFinish;

/*
 * 同步服务器会话失败
 */
- (void)onSyncServerFailed;

/*
 * 有新的会话
 */
- (void)onNewConversation:(NSArray <OIMConversationInfo *> *)conversations;

/*
 * 某些会话的关键信息发生变化（
 */
- (void)onConversationChanged:(NSArray <OIMConversationInfo *> *)conversations;

/*
 * 会话未读总数变更通知
 */
- (void)onTotalUnreadMessageCountChanged:(NSInteger)totalUnreadCount;

@end

/// 高级消息监听器
@protocol OIMAdvancedMsgListener <NSObject>
@optional

/*
 *  收到新消息
 */
- (void)onRecvNewMessage:(OIMMessageInfo *)msg;

/*
 *  单聊消息已读回执
 */
- (void)onRecvC2CReadReceipt:(NSArray<OIMReceiptInfo *> *)receiptList;

/*
 *  群聊消息已读回执
 */
- (void)onRecvGroupReadReceipt:(NSArray<OIMReceiptInfo *> *)groupMsgReceiptList;

/*
 *  收到消息撤回
 */
- (void)onRecvMessageRevoked:(NSString *)msgID;

- (void)onNewRecvMessageRevoked:(OIMMessageRevokedInfo *)messageRevoked;

- (void)onRecvMessageExtensionsAdded:(NSString *)msgID reactionExtensionList:(NSArray<OIMKeyValue *> *)reactionExtensionList;

- (void)onRecvMessageExtensionsDeleted:(NSString *)msgID reactionExtensionList:(NSArray<NSString *> *)reactionExtensionList;

- (void)onRecvMessageExtensionsChanged:(NSString *)msgID reactionExtensionKeyList:(NSArray<OIMKeyValue *> *)reactionExtensionKeyList;

- (void)onMsgDeleted:(OIMMessageInfo *)message;

@end

/// IMSDK 主核心回调
@protocol OIMCustomBusinessListener <NSObject>
@optional

- (void)onRecvCustomBusinessMessage:(NSDictionary <NSString *, id>* _Nullable)businessMessage;

@end


@interface OIMCallbacker : NSObject
<
Open_im_sdk_callbackOnConnListener,
Open_im_sdk_callbackOnAdvancedMsgListener,
Open_im_sdk_callbackOnConversationListener,
Open_im_sdk_callbackOnFriendshipListener,
Open_im_sdk_callbackOnGroupListener,
Open_im_sdk_callbackOnUserListener,
Open_im_sdk_callbackOnCustomBusinessListener
>

+ (instancetype)callbacker;

- (void)setListener;

/// 链接监听
/// 在InitSDK时设置，在IM连接状态有变化时回调
@property (nonatomic, nullable, copy) OIMVoidCallback connecting;
@property (nonatomic, nullable, copy) OIMFailureCallback connectFailure;
@property (nonatomic, nullable, copy) OIMVoidCallback connectSuccess;
@property (nonatomic, nullable, copy) OIMVoidCallback kickedOffline;
@property (nonatomic, nullable, copy) OIMVoidCallback userTokenExpired;

/**
 *  添加 IM 监听
 */
- (void)addIMSDKListener:(id<OIMSDKListener>)listener;

/**
 *  移除 IM 监听
 */
- (void)removeIMSDKListener:(id<OIMSDKListener>)listener;

/// 用户监听
/// 在InitSDK成功后，Login之前设置，本登录用户个人资料有变化时回调
@property (nonatomic, nullable, copy) OIMUserInfoCallback onSelfInfoUpdated;

/// 好友监听
/// 在InitSDK成功后，Login之前设置，好友相关信息有变化时回调
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationAdded;
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationDeleted;
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationAccepted;
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationRejected;
@property (nonatomic, nullable, copy) OIMFriendInfoCallback onFriendAdded;
@property (nonatomic, nullable, copy) OIMFriendInfoCallback onFriendDeleted;
@property (nonatomic, nullable, copy) OIMFriendInfoCallback onFriendInfoChanged;
@property (nonatomic, nullable, copy) OIMBlackInfoCallback onBlackAdded;
@property (nonatomic, nullable, copy) OIMBlackInfoCallback onBlackDeleted;

/**
 *  添加关系链监听器
 */
- (void)addFriendListener:(id<OIMFriendshipListener>)listener NS_SWIFT_NAME(addFriendListener(listener:));

/**
 *   移除关系链监听器
 */
- (void)removeFriendListener:(id<OIMFriendshipListener>)listener NS_SWIFT_NAME(removeFriendListener(listener:));

/// 群组监听
/// 在InitSDK成功后，Login之前设置，群组相关信息有变化时回调
@property (nonatomic, nullable, copy) OIMGroupInfoCallback onGroupInfoChanged;
@property (nonatomic, nullable, copy) OIMGroupInfoCallback onJoinedGroupAdded;
@property (nonatomic, nullable, copy) OIMGroupInfoCallback onJoinedGroupDeleted;
@property (nonatomic, nullable, copy) OIMGroupMemberInfoCallback onGroupMemberAdded;
@property (nonatomic, nullable, copy) OIMGroupMemberInfoCallback onGroupMemberDeleted;
@property (nonatomic, nullable, copy) OIMGroupMemberInfoCallback onGroupMemberInfoChanged;
@property (nonatomic, nullable, copy) OIMGroupApplicationCallback onGroupApplicationAdded;
@property (nonatomic, nullable, copy) OIMGroupApplicationCallback onGroupApplicationDeleted;
@property (nonatomic, nullable, copy) OIMGroupApplicationCallback onGroupApplicationAccepted;
@property (nonatomic, nullable, copy) OIMGroupApplicationCallback onGroupApplicationRejected;
@property (nonatomic, nullable, copy) OIMGroupInfoCallback onGroupDismissed;

/*
 *  设置群组监听器
 */
- (void)addGroupListener:(id<OIMGroupListener>)listener NS_SWIFT_NAME(addGroupListener(listener:));

/*
 *  设置群组监听器
 */
- (void)removeGroupListener:(id<OIMGroupListener>)listener NS_SWIFT_NAME(removeGroupListener(listener:));

/// 会话监听
/// 在InitSDK成功后，Login之前设置，会话相关信息有变化时回调
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerStart;
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerFinish;
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerFailed;
@property (nonatomic, nullable, copy) OIMConversationsInfoCallback onNewConversation;
@property (nonatomic, nullable, copy) OIMConversationsInfoCallback onConversationChanged;
@property (nonatomic, nullable, copy) OIMNumberCallback onTotalUnreadMessageCountChanged;

/*
 *  添加会话监听器
 */
- (void)addConversationListener:(id<OIMConversationListener>)listener NS_SWIFT_NAME(addConversationListener(listener:));

/*
 *  移除会话监听器
 */
- (void)removeConversationListener:(id<OIMConversationListener>)listener NS_SWIFT_NAME(removeConversationListener(listener:));

/// 消息监听
/// 在InitSDK成功后，Login之前设置，消息相关信息有变化时回调
@property (nonatomic, nullable, copy) OIMMessageInfoCallback onRecvNewMessage;
@property (nonatomic, nullable, copy) OIMReceiptCallback onRecvC2CReadReceipt;
@property (nonatomic, nullable, copy) OIMReceiptCallback onRecvGroupReadReceipt;
@property (nonatomic, nullable, copy) OIMStringCallback onRecvMessageRevoked;
@property (nonatomic, nullable, copy) OIMRevokedCallback onNewRecvMessageRevoked;
@property (nonatomic, nullable, copy) OIMKeyValueResultCallback onRecvMessageExtensionsChanged;
@property (nonatomic, nullable, copy) OIMStringArrayCallback onRecvMessageExtensionsDeleted;
@property (nonatomic, nullable, copy) OIMKeyValueResultCallback onRecvMessageExtensionsAdded;
@property (nonatomic, nullable, copy) OIMMessageInfoCallback onMessageDeleted;
/*
 *  添加高级消息的事件监听器
 */
- (void)addAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener NS_SWIFT_NAME(addAdvancedMsgListener(listener:));

/*
 *  移除高级消息的事件监听器
 */
- (void)removeAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener NS_SWIFT_NAME(removeAdvancedMsgListener(listener:));

/// 自定义消息监听
@property (nonatomic, nullable, copy) OIMObjectCallback onRecvCustomBusinessMessage;

/**
 *  添加 IM 监听
 */
- (void)addCustomBusinessListener:(id<OIMCustomBusinessListener>)listener NS_SWIFT_NAME(addCustomBusinessListener(listener:));

/**
 *  移除 IM 监听
 */
- (void)removeCustomBusinessListener:(id<OIMCustomBusinessListener>)listener NS_SWIFT_NAME(removeCustomBusinessListener(listener:));

@end

NS_ASSUME_NONNULL_END
