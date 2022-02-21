//
//  OIMCallbacker.m
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCallbacker.h"

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

#pragma mark -
#pragma mark - User

- (void)onSelfInfoUpdated:(NSString * _Nullable)userInfo {
    if (self.onSelfInfoUpdated) {
        self.onSelfInfoUpdated([OIMUserInfo mj_objectWithKeyValues:userInfo]);
    }
}

#pragma mark -
#pragma mark - Friend

- (void)onBlackAdded:(NSString* _Nullable)blackInfo {
    if (self.onBlackAdded) {
        self.onBlackAdded([OIMBlackInfo mj_objectWithKeyValues:blackInfo]);
    }
}

- (void)onFriendAdded:(NSString * _Nullable)friendInfo {
    if (self.onFriendAdded) {
        self.onFriendAdded([OIMFriendInfo mj_objectWithKeyValues:friendInfo]);
    }
}

- (void)onFriendApplicationAdded:(NSString * _Nullable)friendApplication {
    if (self.onFriendApplicationAdded) {
        self.onFriendApplicationAdded([OIMFriendApplication mj_objectWithKeyValues:friendApplication]);
    }
}

- (void)onFriendApplicationRejected:(NSString * _Nullable)friendApplication {
    if (self.onFriendApplicationRejected) {
        self.onFriendApplicationRejected([OIMFriendApplication mj_objectWithKeyValues:friendApplication]);
    }
}

- (void)onBlackDeleted:(NSString * _Nullable)blackInfo {
    if (self.onBlackAdded) {
        self.onBlackAdded([OIMBlackInfo mj_objectWithKeyValues:blackInfo]);
    }
}

- (void)onFriendApplicationAccepted:(NSString * _Nullable)friendApplication {
    if (self.onFriendApplicationDeleted) {
        self.onFriendApplicationDeleted([OIMFriendApplication mj_objectWithKeyValues:friendApplication]);
    }
}

- (void)onFriendApplicationDeleted:(NSString * _Nullable)friendApplication {
    if (self.onFriendApplicationDeleted) {
        self.onFriendApplicationDeleted([OIMFriendApplication mj_objectWithKeyValues:friendApplication]);
    }
}

- (void)onFriendInfoChanged:(NSString * _Nullable)friendInfo {
    if (self.onFriendAdded) {
        self.onFriendAdded([OIMFriendInfo mj_objectWithKeyValues:friendInfo]);
    }
}

- (void)onFriendDeleted:(NSString * _Nullable)friendInfo {
    if (self.onFriendAdded) {
        self.onFriendAdded([OIMFriendInfo mj_objectWithKeyValues:friendInfo]);
    }
}

#pragma mark -
#pragma mark - Group

- (void)onGroupApplicationAccepted:(NSString * _Nullable)groupApplication {
    if (self.onGroupApplicationAccepted) {
        self.onGroupApplicationAccepted([OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication]);
    }
}
- (void)onGroupApplicationAdded:(NSString * _Nullable)groupApplication {
    if (self.onGroupApplicationAdded) {
        self.onGroupApplicationAdded([OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication]);
    }
}
- (void)onGroupApplicationDeleted:(NSString * _Nullable)groupApplication {
    if (self.onGroupApplicationDeleted) {
        self.onGroupApplicationDeleted([OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication]);
    }
}
- (void)onGroupApplicationRejected:(NSString * _Nullable)groupApplication {
    if (self.onGroupApplicationRejected) {
        self.onGroupApplicationRejected([OIMGroupApplicationInfo mj_objectWithKeyValues:groupApplication]);
    }
}
- (void)onGroupInfoChanged:(NSString * _Nullable)groupInfo {
    if (self.onGroupInfoChanged) {
        self.onGroupInfoChanged([OIMGroupInfo mj_objectWithKeyValues:groupInfo]);
    }
}

- (void)onGroupMemberAdded:(NSString * _Nullable)groupMemberInfo {
    if (self.onGroupMemberAdded) {
        self.onGroupMemberAdded([OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo]);
    }
}

- (void)onGroupMemberDeleted:(NSString * _Nullable)groupMemberInfo {
    if (self.onGroupMemberDeleted) {
        self.onGroupMemberDeleted([OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo]);
    }
}

- (void)onGroupMemberInfoChanged:(NSString * _Nullable)groupMemberInfo {
    if (self.onGroupMemberInfoChanged) {
        self.onGroupMemberInfoChanged([OIMGroupMemberInfo mj_objectWithKeyValues:groupMemberInfo]);
    }
}

- (void)onJoinedGroupAdded:(NSString * _Nullable)groupInfo {
    if (self.onJoinedGroupAdded) {
        self.onJoinedGroupAdded([OIMGroupInfo mj_objectWithKeyValues:groupInfo]);
    }
}

- (void)onJoinedGroupDeleted:(NSString * _Nullable)groupInfo {
    if (self.onJoinedGroupDeleted) {
        self.onJoinedGroupDeleted([OIMGroupInfo mj_objectWithKeyValues:groupInfo]);
    }
}


#pragma mark -
#pragma mark - Message

- (void)onRecvC2CReadReceipt:(NSString * _Nullable)msgReceiptList {
    if (self.onRecvC2CReadReceipt) {
        self.onRecvC2CReadReceipt([OIMReceiptInfo mj_objectArrayWithKeyValuesArray:msgReceiptList]);
    }
}

- (void)onRecvMessageRevoked:(NSString * _Nullable)msgId {
    if (self.onRecvMessageRevoked) {
        self.onRecvMessageRevoked(msgId);
    }
}

- (void)onRecvNewMessage:(NSString * _Nullable)message {
    if (self.onRecvNewMessage) {
        self.onRecvNewMessage([OIMMessageInfo mj_objectWithKeyValues:message]);
    }
}

#pragma mark -
#pragma mark - Conversation

- (void)onConversationChanged:(NSString * _Nullable)conversationList {
    if (self.onConversationChanged) {
        self.onConversationChanged([OIMConversationInfo mj_objectArrayWithKeyValuesArray:conversationList]);
    }
}

- (void)onNewConversation:(NSString * _Nullable)conversationList {
    if (self.onNewConversation) {
        self.onNewConversation([OIMConversationInfo mj_objectArrayWithKeyValuesArray:conversationList]);
    }
}

- (void)onSyncServerFailed {
    if (self.syncServerFailed) {
        self.syncServerFailed();
    }
}

- (void)onSyncServerFinish {
    if (self.syncServerFinish) {
        self.syncServerFinish();
    }
}

- (void)onSyncServerStart {
    if (self.syncServerStart) {
        self.syncServerStart();
    }
}

- (void)onTotalUnreadMessageCountChanged:(int32_t)totalUnreadCount {
    if (self.onTotalUnreadMessageCountChanged) {
        self.onTotalUnreadMessageCountChanged(totalUnreadCount);
    }
}

@end
