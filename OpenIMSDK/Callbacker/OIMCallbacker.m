//
//  OIMCallbacker.m
//  OpenIMSDK
//
//  Created by x on 2021/2/11.
//

#import "OIMCallbacker.h"
#import "OIMGCDMulticastDelegate.h"

@interface OIMCallbacker ()
@property (nonatomic, strong) OIMGCDMulticastDelegate<OIMSDKListener> *sdkListeners;
@property (nonatomic, strong) OIMGCDMulticastDelegate<OIMFriendshipListener> *friendshipListeners;
@property (nonatomic, strong) OIMGCDMulticastDelegate<OIMGroupListener> *groupListeners;
@property (nonatomic, strong) OIMGCDMulticastDelegate<OIMConversationListener> *conversationListeners;
@property (nonatomic, strong) OIMGCDMulticastDelegate<OIMAdvancedMsgListener> *advancedMsgListeners;

@end

@implementation OIMCallbacker

+ (instancetype)callbacker {
    return [OIMCallbacker new];
}

- (void)setListener {
    Open_im_sdkSetUserListener(self);
    Open_im_sdkSetFriendListener(self);
    Open_im_sdkSetGroupListener(self);
    Open_im_sdkSetConversationListener(self);
    Open_im_sdkSetAdvancedMsgListener(self);
}

- (void)dispatchMainThread:(void (NS_NOESCAPE ^)(void))todo {
    if ([NSThread isMainThread]) {
        todo();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            todo();
        });
    }
}

#pragma mark -
#pragma mark - Listeners getter

- (OIMGCDMulticastDelegate<OIMSDKListener> *)sdkListeners {
    if (!_sdkListeners) {
        _sdkListeners = (OIMGCDMulticastDelegate <OIMSDKListener> *)[[OIMGCDMulticastDelegate alloc] init];
    }
    return _sdkListeners;
}

- (OIMGCDMulticastDelegate<OIMFriendshipListener> *)friendshipListeners {
    if (!_friendshipListeners) {
        _friendshipListeners = (OIMGCDMulticastDelegate <OIMFriendshipListener> *)[[OIMGCDMulticastDelegate alloc] init];
    }
    return _friendshipListeners;
}

- (OIMGCDMulticastDelegate<OIMGroupListener> *)groupListeners {
    if (!_groupListeners) {
        _groupListeners = (OIMGCDMulticastDelegate <OIMGroupListener> *)[[OIMGCDMulticastDelegate alloc] init];
    }
    return _groupListeners;
}

- (OIMGCDMulticastDelegate<OIMConversationListener> *)conversationListeners {
    if (!_conversationListeners) {
        _conversationListeners = (OIMGCDMulticastDelegate <OIMConversationListener> *)[[OIMGCDMulticastDelegate alloc] init];
    }
    return _conversationListeners;
}

- (OIMGCDMulticastDelegate<OIMAdvancedMsgListener> *)advancedMsgListeners {
    if (!_advancedMsgListeners) {
        _advancedMsgListeners = (OIMGCDMulticastDelegate <OIMAdvancedMsgListener> *)[[OIMGCDMulticastDelegate alloc] init];
    }
    return _advancedMsgListeners;
}

#pragma mark -
#pragma mark - Add/Remove listener

- (void)addIMSDKListener:(id<OIMSDKListener>)listener {
    [self.sdkListeners addDelegate:listener delegateQueue:dispatch_get_main_queue()];
}

- (void)removeIMSDKListener:(id<OIMSDKListener>)listener {
    [self.sdkListeners removeDelegate:listener];
}

- (void)addFriendListener:(id<OIMFriendshipListener>)listener {
    [self.friendshipListeners addDelegate:listener delegateQueue:dispatch_get_main_queue()];
}

- (void)removeFriendListener:(id<OIMFriendshipListener>)listener {
    [self.friendshipListeners removeDelegate:listener];
}

- (void)addGroupListener:(id<OIMGroupListener>)listener {
    [self.groupListeners addDelegate:listener delegateQueue:dispatch_get_main_queue()];
}

- (void)removeGroupListener:(id<OIMGroupListener>)listener {
    [self.groupListeners removeDelegate:listener];
}

- (void)addConversationListener:(id<OIMConversationListener>)listener {
    [self.conversationListeners addDelegate:listener delegateQueue:dispatch_get_main_queue()];
}

- (void)removeConversationListener:(id<OIMConversationListener>)listener {
    [self.conversationListeners removeDelegate:listener];
}

- (void)addAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener {
    [self.advancedMsgListeners addDelegate:listener delegateQueue:dispatch_get_main_queue()];
}

- (void)removeAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener {
    [self.advancedMsgListeners removeDelegate:listener];
}

#pragma mark -
#pragma mark - Connection

- (void)onConnectFailed:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    
    [self dispatchMainThread:^{
        if (self.connectFailure) {
            self.connectFailure(errCode, errMsg);
        }
        
        if ([self.sdkListeners respondsToSelector:@selector(onConnectFailed:err:)]) {
            [self.sdkListeners onConnectFailed:errCode err:errMsg];
        }
    }];
}

- (void)onConnectSuccess {
    [self dispatchMainThread:^{
        if (self.connectSuccess) {
            self.connectSuccess();
        }
        if ([self.sdkListeners respondsToSelector:@selector(onConnectSuccess)]) {
            [self.sdkListeners onConnectSuccess];
        }
    }];
}

- (void)onConnecting {
    [self dispatchMainThread:^{
        if (self.connecting) {
            self.connecting();
        }
        if ([self.sdkListeners respondsToSelector:@selector(onConnecting)]) {
            [self.sdkListeners onConnecting];
        }
    }];
}

- (void)onKickedOffline {
    [self dispatchMainThread:^{
        if (self.kickedOffline) {
            self.kickedOffline();
        }
        if ([self.sdkListeners respondsToSelector:@selector(onKickedOffline)]) {
            [self.sdkListeners onKickedOffline];
        }
    }];
}

- (void)onUserTokenExpired {
    [self dispatchMainThread:^{
        if (self.userTokenExpired) {
            self.userTokenExpired();
        }
        if ([self.sdkListeners respondsToSelector:@selector(onUserTokenExpired)]) {
            [self.sdkListeners onUserTokenExpired];
        }
    }];
}

#pragma mark -
#pragma mark - User

- (void)onSelfInfoUpdated:(NSString * _Nullable)userInfo {
    
    [self dispatchMainThread:^{
        if (self.onSelfInfoUpdated) {
            self.onSelfInfoUpdated([OIMUserInfo mj_objectWithKeyValues:userInfo]);
        }
    }];
}

#pragma mark -
#pragma mark - Friend

- (void)onFriendApplicationAdded:(NSString * _Nullable)friendApplication {
    OIMFriendApplication *info = [OIMFriendApplication mj_objectWithKeyValues:friendApplication];
    
    [self dispatchMainThread:^{
        if (self.onFriendApplicationAdded) {
            self.onFriendApplicationAdded(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onFriendApplicationAdded:)]) {
            [self.friendshipListeners onFriendApplicationAdded:info];
        }
    }];
}

- (void)onFriendApplicationRejected:(NSString * _Nullable)friendApplication {
    OIMFriendApplication *info = [OIMFriendApplication mj_objectWithKeyValues:friendApplication];
    
    [self dispatchMainThread:^{
        if (self.onFriendApplicationRejected) {
            self.onFriendApplicationRejected(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onFriendApplicationRejected:)]) {
            [self.friendshipListeners onFriendApplicationRejected:info];
        }
    }];
}

- (void)onFriendApplicationAccepted:(NSString * _Nullable)friendApplication {
    OIMFriendApplication *info = [OIMFriendApplication mj_objectWithKeyValues:friendApplication];
    
    [self dispatchMainThread:^{
        if (self.onFriendApplicationDeleted) {
            self.onFriendApplicationDeleted(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onFriendApplicationAccepted:)]) {
            [self.friendshipListeners onFriendApplicationAccepted:info];
        }
    }];
}

- (void)onFriendApplicationDeleted:(NSString * _Nullable)friendApplication {
    OIMFriendApplication *info = [OIMFriendApplication mj_objectWithKeyValues:friendApplication];

    [self dispatchMainThread:^{
        if (self.onFriendApplicationDeleted) {
            self.onFriendApplicationDeleted(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onFriendApplicationDeleted:)]) {
            [self.friendshipListeners onFriendApplicationDeleted:info];
        }
    }];
}

- (void)onFriendAdded:(NSString * _Nullable)friendInfo {
    OIMFriendInfo *info = [OIMFriendInfo mj_objectWithKeyValues:friendInfo];
    
    [self dispatchMainThread:^{
        if (self.onFriendAdded) {
            self.onFriendAdded(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onFriendAdded:)]) {
            [self.friendshipListeners onFriendAdded:info];
        }
    }];
}

- (void)onFriendDeleted:(NSString * _Nullable)friendInfo {
    OIMFriendInfo *info = [OIMFriendInfo mj_objectWithKeyValues:friendInfo];
    
    [self dispatchMainThread:^{
        if (self.onFriendAdded) {
            self.onFriendAdded(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onFriendDeleted:)]) {
            [self.friendshipListeners onFriendDeleted:info];
        }
    }];
}

- (void)onFriendInfoChanged:(NSString * _Nullable)friendInfo {
    OIMFriendInfo *info = [OIMFriendInfo mj_objectWithKeyValues:friendInfo];
    
    [self dispatchMainThread:^{
        if (self.onFriendAdded) {
            self.onFriendAdded(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onFriendInfoChanged:)]) {
            [self.friendshipListeners onFriendInfoChanged:info];
        }
    }];
}

- (void)onBlackAdded:(NSString* _Nullable)blackInfo {
    OIMBlackInfo *info = [OIMBlackInfo mj_objectWithKeyValues:blackInfo];
    
    [self dispatchMainThread:^{
        if (self.onBlackAdded) {
            self.onBlackAdded(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onBlackAdded:)]) {
            [self.friendshipListeners onBlackAdded:info];
        }
    }];
}

- (void)onBlackDeleted:(NSString * _Nullable)blackInfo {
    OIMBlackInfo *info = [OIMBlackInfo mj_objectWithKeyValues:blackInfo];
    
    [self dispatchMainThread:^{
        if (self.onBlackAdded) {
            self.onBlackAdded(info);
        }
        if ([self.friendshipListeners respondsToSelector:@selector(onBlackDeleted:)]) {
            [self.friendshipListeners onBlackDeleted:info];
        }
    }];
}

#pragma mark -
#pragma mark - Group

- (void)onGroupMemberAdded:(NSString * _Nullable)groupMemberInfo {
    OIMGroupMemberInfo *info = [OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo];
    
    [self dispatchMainThread:^{
        if (self.onGroupMemberAdded) {
            self.onGroupMemberAdded(info);
        }
        if ([self.groupListeners respondsToSelector:@selector(onGroupMemberAdded:)]) {
            [self.groupListeners onGroupMemberAdded:info];
        }
    }];
}

- (void)onGroupMemberDeleted:(NSString * _Nullable)groupMemberInfo {
    OIMGroupMemberInfo *info = [OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo];
    
    [self dispatchMainThread:^{
        if (self.onGroupMemberDeleted) {
            self.onGroupMemberDeleted(info);
        }
        
        if ([self.groupListeners respondsToSelector:@selector(onGroupMemberDeleted:)]) {
            [self.groupListeners onGroupMemberDeleted:info];
        }
    }];
}

- (void)onGroupMemberInfoChanged:(NSString * _Nullable)groupMemberInfo {
    OIMGroupMemberInfo *info = [OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo];
    
    [self dispatchMainThread:^{
        if (self.onGroupMemberInfoChanged) {
            self.onGroupMemberInfoChanged(info);
        }
        
        if ([self.groupListeners respondsToSelector:@selector(onGroupMemberInfoChanged:)]) {
            [self.groupListeners onGroupMemberInfoChanged:info];
        }
    }];
}

- (void)onGroupInfoChanged:(NSString * _Nullable)groupInfo {
    OIMGroupInfo *info = [OIMGroupInfo mj_objectWithKeyValues:groupInfo];

    [self dispatchMainThread:^{
        if (self.onGroupInfoChanged) {
            self.onGroupInfoChanged(info);
        }

        if ([self.groupListeners respondsToSelector:@selector(onGroupInfoChanged:)]) {
            [self.groupListeners onGroupInfoChanged:info];
        }
    }];
}

- (void)onJoinedGroupAdded:(NSString * _Nullable)groupInfo {
    OIMGroupInfo *info = [OIMGroupInfo mj_objectWithKeyValues:groupInfo];
    
    [self dispatchMainThread:^{
        if (self.onJoinedGroupAdded) {
            self.onJoinedGroupAdded(info);
        }
        
        if ([self.groupListeners respondsToSelector:@selector(onJoinedGroupAdded:)]) {
            [self.groupListeners onJoinedGroupAdded:info];
        }
    }];
}

- (void)onJoinedGroupDeleted:(NSString * _Nullable)groupInfo {
    OIMGroupInfo *info = [OIMGroupInfo mj_objectWithKeyValues:groupInfo];
    
    [self dispatchMainThread:^{
        if (self.onJoinedGroupDeleted) {
            self.onJoinedGroupDeleted(info);
        }

        if ([self.groupListeners respondsToSelector:@selector(onJoinedGroupDeleted:)]) {
            [self.groupListeners onJoinedGroupDeleted:info];
        }
    }];
}

- (void)onGroupApplicationAccepted:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationAccepted) {
            self.onGroupApplicationAccepted(info);
        }
        
        if ([self.groupListeners respondsToSelector:@selector(onGroupApplicationAccepted:)]) {
            [self.groupListeners onGroupApplicationAccepted:info];
        }
    }];
}

- (void)onGroupApplicationAdded:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationAdded) {
            self.onGroupApplicationAdded(info);
        }

        if ([self.groupListeners respondsToSelector:@selector(onGroupApplicationAdded:)]) {
            [self.groupListeners onGroupApplicationAdded:info];
        }
    }];
}

- (void)onGroupApplicationDeleted:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationDeleted) {
            self.onGroupApplicationDeleted(info);
        }

        if ([self.groupListeners respondsToSelector:@selector(onGroupApplicationDeleted:)]) {
            [self.groupListeners onGroupApplicationDeleted:info];
        }
    }];
}

- (void)onGroupApplicationRejected:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationRejected) {
            self.onGroupApplicationRejected(info);
        }
        
        if ([self.groupListeners respondsToSelector:@selector(onGroupApplicationRejected:)]) {
            [self.groupListeners onGroupApplicationRejected:info];
        }
    }];
}

#pragma mark -
#pragma mark - Message

- (void)onRecvC2CReadReceipt:(NSString * _Nullable)msgReceiptList {
    NSArray *receipts = [OIMReceiptInfo mj_objectArrayWithKeyValuesArray:msgReceiptList];
    
    [self dispatchMainThread:^{
        if (self.onRecvC2CReadReceipt) {
            self.onRecvC2CReadReceipt(receipts);
        }

        if ([self.advancedMsgListeners respondsToSelector:@selector(onRecvC2CReadReceipt:)]) {
            [self.advancedMsgListeners onRecvC2CReadReceipt:receipts];
        }
    }];
}

- (void)onRecvMessageRevoked:(NSString * _Nullable)msgId {
    
    [self dispatchMainThread:^{
        if (self.onRecvMessageRevoked) {
            self.onRecvMessageRevoked(msgId);
        }
        
        if ([self.advancedMsgListeners respondsToSelector:@selector(onRecvMessageRevoked:)]) {
            [self.advancedMsgListeners onRecvMessageRevoked:msgId];
        }
    }];
}

- (void)onRecvNewMessage:(NSString * _Nullable)message {
    OIMMessageInfo *msg = [OIMMessageInfo mj_objectWithKeyValues:message];
    
    [self dispatchMainThread:^{
        if (self.onRecvNewMessage) {
            self.onRecvNewMessage(msg);
        }
        
        if ([self.advancedMsgListeners respondsToSelector:@selector(onRecvNewMessage:)]) {
            [self.advancedMsgListeners onRecvNewMessage:msg];
        }
    }];
}

#pragma mark -
#pragma mark - Conversation

- (void)onConversationChanged:(NSString * _Nullable)conversationList {
    
    NSArray *tConversations = [OIMConversationInfo mj_objectArrayWithKeyValuesArray:conversationList];
    
    [self dispatchMainThread:^{
        if (self.onConversationChanged) {
            self.onConversationChanged(tConversations);
        }

        if ([self.conversationListeners respondsToSelector:@selector(onConversationChanged:)]) {
            [self.conversationListeners onConversationChanged:tConversations];
        }
    }];
}

- (void)onNewConversation:(NSString * _Nullable)conversationList {
    
    NSArray *tConversations = [OIMConversationInfo mj_objectArrayWithKeyValuesArray:conversationList];
    
    [self dispatchMainThread:^{
        if (self.onNewConversation) {
            self.onNewConversation(tConversations);
        }
        
        if ([self.conversationListeners respondsToSelector:@selector(onNewConversation:)]) {
            [self.conversationListeners onNewConversation:tConversations];
        }
    }];
}

- (void)onSyncServerFailed {
    [self dispatchMainThread:^{
        if (self.syncServerFailed) {
            self.syncServerFailed();
        }
        
        if ([self.conversationListeners respondsToSelector:@selector(onSyncServerFailed)]) {
            [self.conversationListeners onSyncServerFailed];
        }
    }];
}

- (void)onSyncServerFinish {
    [self dispatchMainThread:^{
        if (self.syncServerFinish) {
            self.syncServerFinish();
        }

        if ([self.conversationListeners respondsToSelector:@selector(onSyncServerFinish)]) {
            [self.conversationListeners onSyncServerFinish];
        }
    }];
}

- (void)onSyncServerStart {
    [self dispatchMainThread:^{
        if (self.syncServerStart) {
            self.syncServerStart();
        }
        
        if ([self.conversationListeners respondsToSelector:@selector(onSyncServerStart)]) {
            [self.conversationListeners onSyncServerStart];
        }
    }];
}

- (void)onTotalUnreadMessageCountChanged:(int32_t)totalUnreadCount {
    [self dispatchMainThread:^{
        if (self.onTotalUnreadMessageCountChanged) {
            self.onTotalUnreadMessageCountChanged(totalUnreadCount);
        }
        
        if ([self.conversationListeners respondsToSelector:@selector(onTotalUnreadMessageCountChanged:)]) {
            [self.conversationListeners onTotalUnreadMessageCountChanged:totalUnreadCount];
        }
    }];
}

@end
