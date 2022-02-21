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

#import "OIMFriendInfo.h"
#import "OIMBlackInfo.h"

#import "OIMConversationInfo.h"
#import "OIMMessageInfo.h"
#import "OIMReceiptInfo.h"
#import "OIMSearchParam.h"
#import "OIMSearchResultInfo.h"

#import "OIMSimpleResultInfo.h"
#import "OIMSimpleRequstInfo.h"

@import OpenIMCore;

NS_ASSUME_NONNULL_BEGIN

typedef void (^OIMSimpleResultCallback)(OIMSimpleResultInfo * _Nullable result);
typedef void (^OIMSimpleResultsCallback)(NSArray <OIMSimpleResultInfo *> * _Nullable results);

typedef void (^OIMUserInfoCallback)(OIMUserInfo * _Nullable userInfo);
typedef void (^OIMUsersCallback)(NSArray <OIMFullUserInfo *> * _Nullable userInfos);
typedef void (^OIMFullUserInfoCallback)(OIMFullUserInfo * _Nullable userInfo);
typedef void (^OIMFullUsersInfoCallback)(NSArray <OIMFullUserInfo *> * _Nullable userInfos);

typedef void (^OIMFriendApplicationCallback)(OIMFriendApplication * _Nullable friendApplication);
typedef void (^OIMFriendApplicationsCallback)(NSArray <OIMFriendApplication *> * _Nullable friendApplications);

typedef void (^OIMFriendInfoCallback)(OIMFriendInfo * _Nullable friendInfo);
typedef void (^OIMBlackInfoCallback)(OIMBlackInfo * _Nullable blackInfo);

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

@interface OIMCallbacker : NSObject
<
Open_im_sdk_callbackOnAdvancedMsgListener,
Open_im_sdk_callbackOnConversationListener,
Open_im_sdk_callbackOnFriendshipListener,
Open_im_sdk_callbackOnGroupListener,
Open_im_sdk_callbackOnUserListener
>

+ (instancetype)callbacker;

- (void)setListener;

/// 链接监听
/// 在InitSDK时设置，在IM连接状态有变化时回调
@property (nonatomic, nullable, copy) OIMVoidCallback onConnecting;
@property (nonatomic, nullable, copy) OIMFailureCallback onConnectFailure;
@property (nonatomic, nullable, copy) OIMVoidCallback onConnectSuccess;
@property (nonatomic, nullable, copy) OIMVoidCallback onKickedOffline;
@property (nonatomic, nullable, copy) OIMVoidCallback onUserTokenExpired;

/// 用户监听
/// 在InitSDK成功后，Login之前设置，本登录用户个人资料有变化时回调
/// 可调用OIMCallbacker+User相关函数设置所有监
@property (nonatomic, nullable, copy) OIMUserInfoCallback onSelfInfoUpdated;

/// 好友监听
/// 在InitSDK成功后，Login之前设置，好友相关信息有变化时回调
/// 可调用OIMCallbacker+Friend相关函数设置所有监听
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationAdded;
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationDeleted;
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationAccepted;
@property (nonatomic, nullable, copy) OIMFriendApplicationCallback onFriendApplicationRejected;
@property (nonatomic, nullable, copy) OIMFriendInfoCallback onFriendAdded;
@property (nonatomic, nullable, copy) OIMFriendInfoCallback onFriendDeleted;
@property (nonatomic, nullable, copy) OIMFriendInfoCallback onFriendInfoChanged;
@property (nonatomic, nullable, copy) OIMBlackInfoCallback onBlackAdded;
@property (nonatomic, nullable, copy) OIMBlackInfoCallback onBlackDeleted;

/// 群组监听
/// 在InitSDK成功后，Login之前设置，群组相关信息有变化时回调
/// 可调用OIMCallbacker+Group相关函数设置所有监听
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

/// 会话监听
/// 在InitSDK成功后，Login之前设置，群组相关信息有变化时回调
/// 可调用OIMCallbacker+Conversation相关函数设置所有监听
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerStart;
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerFinish;
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerFailed;
@property (nonatomic, nullable, copy) OIMConversationsInfoCallback onNewConversation;
@property (nonatomic, nullable, copy) OIMConversationsInfoCallback onConversationChanged;
@property (nonatomic, nullable, copy) OIMNumberCallback onTotalUnreadMessageCountChanged;

/// 消息监听
/// 在InitSDK成功后，Login之前设置，群组相关信息有变化时回调
/// 可调用OIMCallbacker+Message相关函数设置所有监听
@property (nonatomic, nullable, copy) OIMMessageInfoCallback onRecvNewMessage;
@property (nonatomic, nullable, copy) OIMReceiptCallback onRecvC2CReadReceipt;
@property (nonatomic, nullable, copy) OIMStringCallback onRecvMessageRevoked;

@end

NS_ASSUME_NONNULL_END
