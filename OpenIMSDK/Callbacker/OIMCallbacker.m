//
//  OIMCallbacker.m
//  OpenIMSDK
//
//  Created by x on 2021/2/11.
//

#import "OIMCallbacker.h"

@interface OIMCallbacker ()
@property (nonatomic, strong) NSMutableArray <id<OIMSDKListener>> *sdkListeners;
@property (nonatomic, strong) NSMutableArray <id<OIMFriendshipListener>> *friendshipListeners;
@property (nonatomic, strong) NSMutableArray <id<OIMGroupListener>> *groupListeners;
@property (nonatomic, strong) NSMutableArray <id<OIMConversationListener>> *conversationListeners;
@property (nonatomic, strong) NSMutableArray <id<OIMAdvancedMsgListener>> *advancedMsgListeners;
@property (nonatomic, strong) NSMutableArray <id<OIMSignalingListener>> *signalingListeners;
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
    Open_im_sdkSetSignalingListener(self);
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

- (NSMutableArray<id<OIMSDKListener>> *)sdkListeners {
    if (_sdkListeners == nil) {
        _sdkListeners = [NSMutableArray new];
    }
    
    return _sdkListeners;
}

- (NSMutableArray<id<OIMFriendshipListener>> *)friendshipListeners {
    if (_friendshipListeners == nil) {
        _friendshipListeners = [NSMutableArray new];
    }
    
    return _friendshipListeners;
}

- (NSMutableArray<id<OIMGroupListener>> *)groupListeners {
    if (_groupListeners == nil) {
        _groupListeners = [NSMutableArray new];
    }
    
    return _groupListeners;
}

- (NSArray<id<OIMConversationListener>> *)conversationListeners {
    if (_conversationListeners == nil) {
        _conversationListeners = [NSMutableArray new];
    }
    
    return _conversationListeners;
}

- (NSMutableArray<id<OIMAdvancedMsgListener>> *)advancedMsgListeners {
    if (_advancedMsgListeners == nil) {
        _advancedMsgListeners = [NSMutableArray new];
    }
    
    return _advancedMsgListeners;
}

- (NSMutableArray<id<OIMSignalingListener>> *)signalingListeners {
    if (_signalingListeners == nil) {
        _signalingListeners = [NSMutableArray new];
    }
    
    return _signalingListeners;
}

#pragma mark -
#pragma mark - Add/Remove listener

- (void)addIMSDKListener:(id<OIMSDKListener>)listener {
    if (listener != nil && ![self.sdkListeners containsObject:listener]) {
        [self.sdkListeners addObject:listener];
    }
}

- (void)removeIMSDKListener:(id<OIMSDKListener>)listener {
    if (listener != nil && self.sdkListeners.count > 0) {
        [self.sdkListeners removeObject:listener];
    }
}

- (void)addFriendListener:(id<OIMFriendshipListener>)listener {
    if (listener != nil && ![self.friendshipListeners containsObject:listener]) {
        [self.friendshipListeners addObject:listener];
    }
}

- (void)removeFriendListener:(id<OIMFriendshipListener>)listener {
    if (listener != nil && self.friendshipListeners.count > 0) {
        [self.friendshipListeners removeObject:listener];
    }
}

- (void)addGroupListener:(id<OIMGroupListener>)listener {
    if (listener != nil && ![self.groupListeners containsObject:listener]) {
        [self.groupListeners addObject:listener];
    }
}

- (void)removeGroupListener:(id<OIMGroupListener>)listener {
    if (listener != nil && self.groupListeners.count > 0) {
        [self.groupListeners removeObject:listener];
    }
}

- (void)addConversationListener:(id<OIMConversationListener>)listener {
    if (listener != nil && ![self.conversationListeners containsObject:listener]) {
        [self.conversationListeners addObject:listener];
    }
}

- (void)removeConversationListener:(id<OIMConversationListener>)listener {
    if (listener != nil && self.conversationListeners.count > 0) {
        [self.conversationListeners removeObject:listener];
    }
}

- (void)addAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener {
    if (listener != nil && ![self.advancedMsgListeners containsObject:listener]) {
        [self.advancedMsgListeners addObject:listener];
    }
}

- (void)removeAdvancedMsgListener:(id<OIMAdvancedMsgListener>)listener {
    if (listener != nil && self.advancedMsgListeners.count > 0) {
        [self.advancedMsgListeners removeObject:listener];
    }
}

- (void)addSignalingListener:(id<OIMSignalingListener>)listener {
    if (listener != nil && ![self.signalingListeners containsObject:listener]) {
        [self.signalingListeners addObject:listener];
    }
}

- (void)removeSignalingListener:(id<OIMSignalingListener>)listener {
    if (listener != nil && self.advancedMsgListeners.count > 0) {
        [self.signalingListeners removeObject:listener];
    }
}

#pragma mark -
#pragma mark - Connection

- (void)onConnectFailed:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    
    [self dispatchMainThread:^{
        if (self.connectFailure) {
            self.connectFailure(errCode, errMsg);
        }
        
        [self.sdkListeners enumerateObjectsUsingBlock:^(id<OIMSDKListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onConnectFailed:err:)]) {
                [obj onConnectFailed:errCode err:errMsg];
            }
        }];
    }];
}

- (void)onConnectSuccess {
    [self dispatchMainThread:^{
        if (self.connectSuccess) {
            self.connectSuccess();
        }
        
        [self.sdkListeners enumerateObjectsUsingBlock:^(id<OIMSDKListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onConnectSuccess)]) {
                [obj onConnectSuccess];
            }
        }];
    }];
}

- (void)onConnecting {
    [self dispatchMainThread:^{
        if (self.connecting) {
            self.connecting();
        }
        
        [self.sdkListeners enumerateObjectsUsingBlock:^(id<OIMSDKListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onConnecting)]) {
                [obj onConnecting];
            }
        }];
    }];
}

- (void)onKickedOffline {
    [self dispatchMainThread:^{
        if (self.kickedOffline) {
            self.kickedOffline();
        }
        
        [self.sdkListeners enumerateObjectsUsingBlock:^(id<OIMSDKListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onKickedOffline)]) {
                [obj onKickedOffline];
            }
        }];
    }];
}

- (void)onUserTokenExpired {
    [self dispatchMainThread:^{
        if (self.userTokenExpired) {
            self.userTokenExpired();
        }
        
        [self.sdkListeners enumerateObjectsUsingBlock:^(id<OIMSDKListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onUserTokenExpired)]) {
                [obj onUserTokenExpired];
            }
        }];
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
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onFriendApplicationAdded:)]) {
                [obj onFriendApplicationAdded:info];
            }
        }];
    }];
}

- (void)onFriendApplicationRejected:(NSString * _Nullable)friendApplication {
    OIMFriendApplication *info = [OIMFriendApplication mj_objectWithKeyValues:friendApplication];
    
    [self dispatchMainThread:^{
        if (self.onFriendApplicationRejected) {
            self.onFriendApplicationRejected(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onFriendApplicationRejected:)]) {
                [obj onFriendApplicationRejected:info];
            }
        }];
    }];
}

- (void)onFriendApplicationAccepted:(NSString * _Nullable)friendApplication {
    OIMFriendApplication *info = [OIMFriendApplication mj_objectWithKeyValues:friendApplication];
    
    [self dispatchMainThread:^{
        if (self.onFriendApplicationDeleted) {
            self.onFriendApplicationDeleted(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onFriendApplicationAccepted:)]) {
                [obj onFriendApplicationAccepted:info];
            }
        }];
        
    }];
}

- (void)onFriendApplicationDeleted:(NSString * _Nullable)friendApplication {
    OIMFriendApplication *info = [OIMFriendApplication mj_objectWithKeyValues:friendApplication];

    [self dispatchMainThread:^{
        if (self.onFriendApplicationDeleted) {
            self.onFriendApplicationDeleted(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onFriendApplicationDeleted:)]) {
                [obj onFriendApplicationDeleted:info];
            }
        }];
    }];
}

- (void)onFriendAdded:(NSString * _Nullable)friendInfo {
    OIMFriendInfo *info = [OIMFriendInfo mj_objectWithKeyValues:friendInfo];
    
    [self dispatchMainThread:^{
        if (self.onFriendAdded) {
            self.onFriendAdded(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onFriendAdded:)]) {
                [obj onFriendAdded:info];
            }
        }];
    }];
}

- (void)onFriendDeleted:(NSString * _Nullable)friendInfo {
    OIMFriendInfo *info = [OIMFriendInfo mj_objectWithKeyValues:friendInfo];
    
    [self dispatchMainThread:^{
        if (self.onFriendAdded) {
            self.onFriendAdded(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onFriendDeleted:)]) {
                [obj onFriendDeleted:info];
            }
        }];
    }];
}

- (void)onFriendInfoChanged:(NSString * _Nullable)friendInfo {
    OIMFriendInfo *info = [OIMFriendInfo mj_objectWithKeyValues:friendInfo];
    
    [self dispatchMainThread:^{
        if (self.onFriendAdded) {
            self.onFriendAdded(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onFriendInfoChanged:)]) {
                [obj onFriendInfoChanged:info];
            }
        }];
    }];
}

- (void)onBlackAdded:(NSString* _Nullable)blackInfo {
    OIMBlackInfo *info = [OIMBlackInfo mj_objectWithKeyValues:blackInfo];
    
    [self dispatchMainThread:^{
        if (self.onBlackAdded) {
            self.onBlackAdded(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onBlackAdded:)]) {
                [obj onBlackAdded:info];
            }
        }];
    }];
}

- (void)onBlackDeleted:(NSString * _Nullable)blackInfo {
    OIMBlackInfo *info = [OIMBlackInfo mj_objectWithKeyValues:blackInfo];
    
    [self dispatchMainThread:^{
        if (self.onBlackAdded) {
            self.onBlackAdded(info);
        }
        
        [self.friendshipListeners enumerateObjectsUsingBlock:^(id<OIMFriendshipListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onBlackDeleted:)]) {
                [obj onBlackDeleted:info];
            }
        }];
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
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupMemberAdded:)]) {
                [obj onGroupMemberAdded:info];
            }
        }];
    }];
}

- (void)onGroupMemberDeleted:(NSString * _Nullable)groupMemberInfo {
    OIMGroupMemberInfo *info = [OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo];
    
    [self dispatchMainThread:^{
        if (self.onGroupMemberDeleted) {
            self.onGroupMemberDeleted(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupMemberDeleted:)]) {
                [obj onGroupMemberDeleted:info];
            }
        }];
    }];
}

- (void)onGroupMemberInfoChanged:(NSString * _Nullable)groupMemberInfo {
    OIMGroupMemberInfo *info = [OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo];
    
    [self dispatchMainThread:^{
        if (self.onGroupMemberInfoChanged) {
            self.onGroupMemberInfoChanged(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupMemberInfoChanged:)]) {
                [obj onGroupMemberInfoChanged:info];
            }
        }];
    }];
}

- (void)onGroupInfoChanged:(NSString * _Nullable)groupInfo {
    OIMGroupInfo *info = [OIMGroupInfo mj_objectWithKeyValues:groupInfo];

    [self dispatchMainThread:^{
        if (self.onGroupInfoChanged) {
            self.onGroupInfoChanged(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupInfoChanged:)]) {
                [obj onGroupInfoChanged:info];
            }
        }];
    }];
}

- (void)onJoinedGroupAdded:(NSString * _Nullable)groupInfo {
    OIMGroupInfo *info = [OIMGroupInfo mj_objectWithKeyValues:groupInfo];
    
    [self dispatchMainThread:^{
        if (self.onJoinedGroupAdded) {
            self.onJoinedGroupAdded(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onJoinedGroupAdded:)]) {
                [obj onJoinedGroupAdded:info];
            }
        }];
    }];
}

- (void)onJoinedGroupDeleted:(NSString * _Nullable)groupInfo {
    OIMGroupInfo *info = [OIMGroupInfo mj_objectWithKeyValues:groupInfo];
    
    [self dispatchMainThread:^{
        if (self.onJoinedGroupDeleted) {
            self.onJoinedGroupDeleted(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onJoinedGroupDeleted:)]) {
                [obj onJoinedGroupDeleted:info];
            }
        }];
    }];
}

- (void)onGroupApplicationAccepted:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationAccepted) {
            self.onGroupApplicationAccepted(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupApplicationAccepted:)]) {
                [obj onGroupApplicationAccepted:info];
            }
        }];
    }];
}

- (void)onGroupApplicationAdded:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationAdded) {
            self.onGroupApplicationAdded(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupApplicationAdded:)]) {
                [obj onGroupApplicationAdded:info];
            }
        }];
    }];
}

- (void)onGroupApplicationDeleted:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationDeleted) {
            self.onGroupApplicationDeleted(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupApplicationDeleted:)]) {
                [obj onGroupApplicationDeleted:info];
            }
        }];
    }];
}

- (void)onGroupApplicationRejected:(NSString * _Nullable)groupApplication {
    OIMGroupApplicationInfo *info = [OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication];
    
    [self dispatchMainThread:^{
        if (self.onGroupApplicationRejected) {
            self.onGroupApplicationRejected(info);
        }
        
        [self.groupListeners enumerateObjectsUsingBlock:^(id<OIMGroupListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onGroupApplicationRejected:)]) {
                [obj onGroupApplicationRejected:info];
            }
        }];
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
        
        [self.advancedMsgListeners enumerateObjectsUsingBlock:^(id<OIMAdvancedMsgListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onRecvC2CReadReceipt:)]) {
                [obj onRecvC2CReadReceipt:receipts];
            }
        }];
    }];
}

- (void)onRecvGroupReadReceipt:(NSString* _Nullable)groupMsgReceiptList {
    NSArray *receipts = [OIMReceiptInfo mj_objectArrayWithKeyValuesArray:groupMsgReceiptList];
    
    [self dispatchMainThread:^{
        if (self.onRecvGroupReadReceipt) {
            self.onRecvGroupReadReceipt(receipts);
        }
        
        [self.advancedMsgListeners enumerateObjectsUsingBlock:^(id<OIMAdvancedMsgListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onRecvGroupReadReceipt:)]) {
                [obj onRecvGroupReadReceipt:receipts];
            }
        }];
    }];
}

- (void)onRecvMessageRevoked:(NSString * _Nullable)msgId {
    
    [self dispatchMainThread:^{
        if (self.onRecvMessageRevoked) {
            self.onRecvMessageRevoked(msgId);
        }
        
        [self.advancedMsgListeners enumerateObjectsUsingBlock:^(id<OIMAdvancedMsgListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onRecvMessageRevoked:)]) {
                [obj onRecvMessageRevoked:msgId];
            }
        }];
    }];
}

- (void)onRecvNewMessage:(NSString * _Nullable)message {
    OIMMessageInfo *msg = [OIMMessageInfo mj_objectWithKeyValues:message];
    
    [self dispatchMainThread:^{
        if (self.onRecvNewMessage) {
            self.onRecvNewMessage(msg);
        }
        
        [self.advancedMsgListeners enumerateObjectsUsingBlock:^(id<OIMAdvancedMsgListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onRecvNewMessage:)]) {
                [obj onRecvNewMessage:msg];
            }
        }];
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
        
        [self.conversationListeners enumerateObjectsUsingBlock:^(id<OIMConversationListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onConversationChanged:)]) {
                [obj onConversationChanged:tConversations];
            }
        }];
    }];
}

- (void)onNewConversation:(NSString * _Nullable)conversationList {
    
    NSArray *tConversations = [OIMConversationInfo mj_objectArrayWithKeyValuesArray:conversationList];
    
    [self dispatchMainThread:^{
        if (self.onNewConversation) {
            self.onNewConversation(tConversations);
        }
        
        [self.conversationListeners enumerateObjectsUsingBlock:^(id<OIMConversationListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onNewConversation:)]) {
                [obj onNewConversation:tConversations];
            }
        }];
    }];
}

- (void)onSyncServerFailed {
    [self dispatchMainThread:^{
        if (self.syncServerFailed) {
            self.syncServerFailed();
        }
        
        [self.conversationListeners enumerateObjectsUsingBlock:^(id<OIMConversationListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onSyncServerFailed)]) {
                [obj onSyncServerFailed];
            }
        }];
    }];
}

- (void)onSyncServerFinish {
    [self dispatchMainThread:^{
        if (self.syncServerFinish) {
            self.syncServerFinish();
        }
        
        [self.conversationListeners enumerateObjectsUsingBlock:^(id<OIMConversationListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onSyncServerFinish)]) {
                [obj onSyncServerFinish];
            }
        }];
    }];
}

- (void)onSyncServerStart {
    [self dispatchMainThread:^{
        if (self.syncServerStart) {
            self.syncServerStart();
        }
        
        [self.conversationListeners enumerateObjectsUsingBlock:^(id<OIMConversationListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onSyncServerStart)]) {
                [obj onSyncServerStart];
            }
        }];
    }];
}

- (void)onTotalUnreadMessageCountChanged:(int32_t)totalUnreadCount {
    [self dispatchMainThread:^{
        if (self.onTotalUnreadMessageCountChanged) {
            self.onTotalUnreadMessageCountChanged(totalUnreadCount);
        }
        
        [self.conversationListeners enumerateObjectsUsingBlock:^(id<OIMConversationListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onTotalUnreadMessageCountChanged:)]) {
                [obj onTotalUnreadMessageCountChanged:totalUnreadCount];
            }
        }];
    }];
}

#pragma mark -
#pragma mark - Signaling

- (void)onInvitationCancelled:(NSString * _Nullable)invitationCancelledCallback {
    OIMSignalingInfo *info = [OIMSignalingInfo mj_objectWithKeyValues:invitationCancelledCallback];
    
    [self dispatchMainThread:^{
        if (self.onInvitationCancelled) {
            self.onInvitationCancelled(info);
        }
        
        [self.signalingListeners enumerateObjectsUsingBlock:^(id<OIMSignalingListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onInvitationCancelled:)]) {
                [obj onInvitationCancelled:info];
            }
        }];
    }];
}

- (void)onInvitationTimeout:(NSString * _Nullable)invitationTimeoutCallback {
    OIMSignalingInfo *info = [OIMSignalingInfo mj_objectWithKeyValues:invitationTimeoutCallback];
    
    [self dispatchMainThread:^{
        if (self.onInvitationTimeout) {
            self.onInvitationTimeout(info);
        }
        
        [self.signalingListeners enumerateObjectsUsingBlock:^(id<OIMSignalingListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onInvitationTimeout:)]) {
                [obj onInvitationTimeout:info];
            }
        }];
    }];
}

- (void)onInviteeAccepted:(NSString * _Nullable)inviteeAcceptedCallback {
    OIMSignalingInfo *info = [OIMSignalingInfo mj_objectWithKeyValues:inviteeAcceptedCallback];
    
    [self dispatchMainThread:^{
        if (self.onInviteeAccepted) {
            self.onInviteeAccepted(info);
        }
        
        [self.signalingListeners enumerateObjectsUsingBlock:^(id<OIMSignalingListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onInviteeAccepted:)]) {
                [obj onInviteeAccepted:info];
            }
        }];
    }];
}

- (void)onInviteeAcceptedByOtherDevice:(NSString * _Nullable)inviteeAcceptedCallback {
    OIMSignalingInfo *info = [OIMSignalingInfo mj_objectWithKeyValues:inviteeAcceptedCallback];
    
    [self dispatchMainThread:^{
        if (self.onInviteeAcceptedByOtherDevice) {
            self.onInviteeAcceptedByOtherDevice(info);
        }
        
        [self.signalingListeners enumerateObjectsUsingBlock:^(id<OIMSignalingListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onInviteeAcceptedByOtherDevice:)]) {
                [obj onInviteeAcceptedByOtherDevice:info];
            }
        }];
    }];
}

- (void)onInviteeRejected:(NSString * _Nullable)inviteeRejectedCallback {
    OIMSignalingInfo *info = [OIMSignalingInfo mj_objectWithKeyValues:inviteeRejectedCallback];
    
    [self dispatchMainThread:^{
        if (self.onInviteeRejected) {
            self.onInviteeRejected(info);
        }
        
        [self.signalingListeners enumerateObjectsUsingBlock:^(id<OIMSignalingListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onInviteeRejected:)]) {
                [obj onInviteeRejected:info];
            }
        }];
    }];
}

- (void)onInviteeRejectedByOtherDevice:(NSString * _Nullable)inviteeRejectedCallback {
    OIMSignalingInfo *info = [OIMSignalingInfo mj_objectWithKeyValues:inviteeRejectedCallback];
    
    [self dispatchMainThread:^{
        if (self.onInviteeRejectedByOtherDevice) {
            self.onInviteeRejectedByOtherDevice(info);
        }
        
        [self.signalingListeners enumerateObjectsUsingBlock:^(id<OIMSignalingListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onInviteeRejectedByOtherDevice:)]) {
                [obj onInviteeRejectedByOtherDevice:info];
            }
        }];
    }];
}

- (void)onReceiveNewInvitation:(NSString * _Nullable)receiveNewInvitationCallback {
    OIMSignalingInfo *info = [OIMSignalingInfo mj_objectWithKeyValues:receiveNewInvitationCallback];
    
    [self dispatchMainThread:^{
        if (self.onReceiveNewInvitation) {
            self.onReceiveNewInvitation(info);
        }
        
        [self.signalingListeners enumerateObjectsUsingBlock:^(id<OIMSignalingListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(onReceiveNewInvitation:)]) {
                [obj onReceiveNewInvitation:info];
            }
        }];
    }];
}

@end
