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
typedef void (^OIMUserStatusInfoCallback)(OIMUserStatusInfo * _Nullable statusInfo);
typedef void (^OIMUserStatusInfosCallback)(NSArray <OIMUserStatusInfo *> * _Nullable statusInfos);

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

typedef void (^OIMGetAdvancedHistoryMessageListCallback)(OIMGetAdvancedHistoryMessageListInfo * _Nullable result);

/// IMSDK Core Callbacks
@protocol OIMSDKListener <NSObject>
@optional
/**
 *  SDK is connecting to the server.
 */
- (void)onConnecting;

/**
 * SDK has successfully connected to the server.
 */
- (void)onConnectSuccess;

/**
 * SDK connection to the server has failed.
 */
- (void)onConnectFailed:(NSInteger)code err:(NSString *)err;

/**
 * The current user has been kicked offline. You can show a UI notification to the user.
 */
- (void)onKickedOffline;

/**
 * Token has expired while online: You need to generate a new UserToken and re-login.
 */
- (void)onUserTokenExpired;

@end

/// User Status Callbacks
@protocol OIMUserListener <NSObject>
@optional
/**
 * User information has been updated.
 */
- (void)onSelfInfoUpdated:(OIMUserInfo *)info;

/**
 * User status has changed.
 */
- (void)onUserStatusChanged:(OIMUserStatusInfo *)info;

@end

/// Profile and Relationship Callbacks
@protocol OIMFriendshipListener <NSObject>
@optional

/**
 * New friend application notification.
 */
- (void)onFriendApplicationAdded:(OIMFriendApplication *)application;

/**
 * Friend application has been rejected.
 */
- (void)onFriendApplicationRejected:(OIMFriendApplication *)application;

/**
 * Friend application has been accepted.
 */
- (void)onFriendApplicationAccepted:(OIMFriendApplication *)application;

/**
 * Friend application has been deleted.
 */
- (void)onFriendApplicationDeleted:(OIMFriendApplication *)application;

/**
 * New friend notification.
 */
- (void)onFriendAdded:(OIMFriendInfo *)info;

/**
 * Friend deletion notification.
 */
- (void)onFriendDeleted:(OIMFriendInfo *)info;

/**
 * Friend profile change notification.
 */
- (void)onFriendInfoChanged:(OIMFriendInfo *)info;

/**
 * New blacklist notification.
 */
- (void)onBlackAdded:(OIMBlackInfo *)info;

/**
 * Blacklist deletion notification.
 */
- (void)onBlackDeleted:(OIMBlackInfo *)info;

@end

/// IMSDK Group Event Callbacks
@protocol OIMGroupListener <NSObject>
@optional

/**
 *  New member joined the group.
 */
- (void)onGroupMemberAdded:(OIMGroupMemberInfo *)memberInfo;

/**
 *  Member left the group.
 */
- (void)onGroupMemberDeleted:(OIMGroupMemberInfo *)memberInfo;

/**
 *  Information of a member in the group has changed.
 */
- (void)onGroupMemberInfoChanged:(OIMGroupMemberInfo *)changeInfo;

/**
 *  Callback for group addition.
 */
- (void)onJoinedGroupAdded:(OIMGroupInfo *)groupInfo;

/**
 *  Callback for group removal.
 */
- (void)onJoinedGroupDeleted:(OIMGroupInfo *)groupInfo;

/**
 *  Information of a group that the user has joined has been modified.
 */
- (void)onGroupInfoChanged:(OIMGroupInfo *)changeInfo;

/**
 *  Group application has been accepted.
 */
- (void)onGroupApplicationAccepted:(OIMGroupApplicationInfo *)groupApplication;

/**
 *  Someone has applied to join the group.
 */
- (void)onGroupApplicationAdded:(OIMGroupApplicationInfo *)groupApplication;

/**
 *  Group application has been deleted.
 */
- (void)onGroupApplicationDeleted:(OIMGroupApplicationInfo *)groupApplication;

/**
 *  Group application has been rejected.
 */
- (void)onGroupApplicationRejected:(OIMGroupApplicationInfo *)groupApplication;

/**
 *  Group has been disbanded.
 */
- (void)onGroupDismissed:(OIMGroupInfo *)changeInfo;

@end

/// Conversation Event Callbacks
@protocol OIMConversationListener <NSObject>
@optional

/**
 * Synchronization with the server has started for conversations.
 */
- (void)onSyncServerStart;

/**
 * Synchronization with the server for conversations has completed.
 */
- (void)onSyncServerFinish;

/**
 * Synchronization with the server for conversations has failed.
 */
- (void)onSyncServerFailed;

/**
 * New conversations have been added.
 */
- (void)onNewConversation:(NSArray <OIMConversationInfo *> *)conversations;

/**
 * Key information of certain conversations has changed.
 */
- (void)onConversationChanged:(NSArray <OIMConversationInfo *> *)conversations;

/**
 * Notification of changes in the total unread message count of conversations.
 */
- (void)onTotalUnreadMessageCountChanged:(NSInteger)totalUnreadCount;

@end

/// Advanced Message Listener
@protocol OIMAdvancedMsgListener <NSObject>
@optional

/**
 * Received a new message.
 */
- (void)onRecvNewMessage:(OIMMessageInfo *)msg;

/**
 * Read receipt for one-on-one messages.
 */
- (void)onRecvC2CReadReceipt:(NSArray<OIMReceiptInfo *> *)receiptList;

/**
 * Read receipt for group chat messages.
 */
- (void)onRecvGroupReadReceipt:(NSArray<OIMReceiptInfo *> *)groupMsgReceiptList;

/**
 * Received a message retraction.
 */
- (void)onRecvMessageRevoked:(OIMMessageRevokedInfo *)messageRevoked;

- (void)onMsgDeleted:(OIMMessageInfo *)message;

@end

/// Custom Business Callbacks for IM
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

/// Connection Listener
/// Set during InitSDK, called when the IM connection status changes.
@property (nonatomic, nullable, copy) OIMVoidCallback connecting;
@property (nonatomic, nullable, copy) OIMFailureCallback connectFailure;
@property (nonatomic, nullable, copy) OIMVoidCallback connectSuccess;
@property (nonatomic, nullable, copy) OIMVoidCallback kickedOffline;
@property (nonatomic, nullable, copy) OIMVoidCallback userTokenExpired;

/**
 * Add IM SDK listener.
 */
- (void)addIMSDKListener:(id<OIMSDKListener>)listener;

/**
 * Remove IM SDK listener.
 */
- (void)removeIMSDKListener:(id<OIMSDKListener>)listener;

/// User Listener
/// Set after a successful InitSDK and before Login, called when the personal profile of the logged-in user changes.
@property (nonatomic, nullable, copy) OIMUserInfoCallback onSelfInfoUpdated;
@property (nonatomic, nullable, copy) OIMUserStatusInfoCallback onUserStatusChanged;

/**
 * Add User listener.
 */
- (void)addUserListener:(id<OIMUserListener>)listener NS_SWIFT_NAME(addUserListener(listener:));

/**
 * Remove User listener.
 */
- (void)removeUserListener:(id<OIMUserListener>)listener NS_SWIFT_NAME(removeUserListener(listener:));

/// Friendship Listener
/// Set after a successful InitSDK and before Login, called when friend-related information changes.
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
 * Add Friendship listener.
 */
- (void)addFriendListener:(id<OIMFriendshipListener>)listener NS_SWIFT_NAME(addFriendListener(listener:));

/**
 * Remove Friendship listener.
 */
- (void)removeFriendListener:(id<OIMFriendshipListener>)listener NS_SWIFT_NAME(removeFriendListener(listener:));

/// Group Listener
/// Set after a successful InitSDK and before Login, called when group-related information changes.
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

/**
 * Set group listener.
 */
- (void)addGroupListener:(id<OIMGroupListener>)listener NS_SWIFT_NAME(addGroupListener(listener:));

/**
 * Remove group listener.
 */
- (void)removeGroupListener:(id<OIMGroupListener>)listener NS_SWIFT_NAME(removeGroupListener(listener:));

/// Conversation Listener
/// Set after a successful InitSDK and before Login, called when conversation-related information changes.
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerStart;
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerFinish;
@property (nonatomic, nullable, copy) OIMVoidCallback syncServerFailed;
@property (nonatomic, nullable, copy) OIMConversationsInfoCallback onNewConversation;
@property (nonatomic, nullable, copy) OIMConversationsInfoCallback onConversationChanged;
@property (nonatomic, nullable, copy) OIMNumberCallback onTotalUnreadMessageCountChanged;

/**
 * Add conversation listener.
 */
- (void)addConversationListener:(id<OIMConversationListener>)listener NS_SWIFT_NAME(addConversationListener(listener:));

/**
 * Remove conversation listener.
 */
- (void)removeConversationListener:(id<OIMConversationListener>)listener NS_SWIFT_NAME(removeConversationListener(listener:));

/// Message Listener
/// Set after a successful InitSDK and before Login, called when message-related information changes.
@property (nonatomic, nullable, copy) OIMMessageInfoCallback onRecvNewMessage;
@property (nonatomic, nullable, copy) OIMReceiptCallback onRecvC2CReadReceipt;
@property (nonatomic, nullable, copy) OIMReceiptCallback onRecvGroupReadReceipt;
@property (nonatomic, nullable, copy) OIMRevokedCallback onRecvMessageRevoked;
@property (nonatomic, nullable, copy) OIMMessageInfoCallback onMessageDeleted;
/**
 * Add advanced message event listener.
 */
- (void)addAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener NS_SWIFT_NAME(addAdvancedMsgListener(listener:));

/**
 * Remove advanced message event listener.
 */
- (void)removeAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener NS_SWIFT_NAME(removeAdvancedMsgListener(listener:));

/// Custom Business Message Listener
@property (nonatomic, nullable, copy) OIMObjectCallback onRecvCustomBusinessMessage;

/**
 * Add IM listener for custom business events.
 */
- (void)addCustomBusinessListener:(id<OIMCustomBusinessListener>)listener NS_SWIFT_NAME(addCustomBusinessListener(listener:));

/**
 * Remove IM listener for custom business events.
 */
- (void)removeCustomBusinessListener:(id<OIMCustomBusinessListener>)listener NS_SWIFT_NAME(removeCustomBusinessListener(listener:));

@end

NS_ASSUME_NONNULL_END
