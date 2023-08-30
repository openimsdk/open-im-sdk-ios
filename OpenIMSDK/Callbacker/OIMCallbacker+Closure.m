//
//  OIMCallbacker+Closure.m
//  OpenIMSDK
//
//  Created by x on 2022/3/3.
//

#import "OIMCallbacker+Closure.h"

@implementation OIMCallbacker (Closure)

- (void)setConversationListenerWithOnSyncServerStart:(OIMVoidCallback)onSyncServerStart
                                  onSyncServerFinish:(OIMVoidCallback)onSyncServerFinish
                                  onSyncServerFailed:(OIMVoidCallback)onSyncServerFailed
                               onConversationChanged:(OIMConversationsInfoCallback)onConversationChanged
                                   onNewConversation:(OIMConversationsInfoCallback)onNewConversation
                    onTotalUnreadMessageCountChanged:(OIMNumberCallback)onTotalUnreadMessageCountChanged {
    self.syncServerStart = onSyncServerStart;
    self.syncServerFinish = onSyncServerFinish;
    self.syncServerFailed = onSyncServerFailed;
    self.onConversationChanged = onConversationChanged;
    self.onNewConversation = onNewConversation;
    self.onTotalUnreadMessageCountChanged = onTotalUnreadMessageCountChanged;
}

- (void)setFriendListenerWithOnBlackAdded:(OIMBlackInfoCallback)onBlackAdded
                           onBlackDeleted:(OIMBlackInfoCallback)onBlackDeleted
              onFriendApplicationAccepted:(OIMFriendApplicationCallback)onFriendApplicationAccepted
                 onFriendApplicationAdded:(OIMFriendApplicationCallback)onFriendApplicationAdded
               onFriendApplicationDeleted:(OIMFriendApplicationCallback)onFriendApplicationDeleted
              onFriendApplicationRejected:(OIMFriendApplicationCallback)onFriendApplicationRejected
                      onFriendInfoChanged:(OIMFriendInfoCallback)onFriendInfoChanged
                            onFriendAdded:(OIMFriendInfoCallback)onFriendAdded
                          onFriendDeleted:(OIMFriendInfoCallback)onFriendDeleted {
    self.onBlackAdded = onBlackAdded;
    self.onBlackDeleted = onBlackDeleted;
    self.onFriendApplicationAccepted = onFriendApplicationAccepted;
    self.onFriendApplicationAdded = onFriendApplicationAdded;
    self.onFriendApplicationDeleted = onFriendApplicationDeleted;
    self.onFriendApplicationRejected = onFriendApplicationRejected;
    self.onFriendInfoChanged = onFriendInfoChanged;
    self.onFriendAdded = onFriendAdded;
    self.onFriendDeleted = onFriendDeleted;
}

- (void)setGroupListenerWithOnGroupInfoChanged:(OIMGroupInfoCallback)onGroupInfoChanged
                            onJoinedGroupAdded:(OIMGroupInfoCallback)onJoinedGroupAdded
                          onJoinedGroupDeleted:(OIMGroupInfoCallback)onJoinedGroupDeleted
                            onGroupMemberAdded:(OIMGroupMemberInfoCallback)onGroupMemberAdded
                          onGroupMemberDeleted:(OIMGroupMemberInfoCallback)onGroupMemberDeleted
                      onGroupMemberInfoChanged:(OIMGroupMemberInfoCallback)onGroupMemberInfoChanged
                       onGroupApplicationAdded:(OIMGroupApplicationCallback)onGroupApplicationAdded
                     onGroupApplicationDeleted:(OIMGroupApplicationCallback)onGroupApplicationDeleted
                    onGroupApplicationAccepted:(OIMGroupApplicationCallback)onGroupApplicationAccepted
                    onGroupApplicationRejected:(OIMGroupApplicationCallback)onGroupApplicationRejected
                              onGroupDismissed:(OIMGroupInfoCallback)onGroupDismissed {
    self.onGroupInfoChanged = onGroupInfoChanged;
    self.onJoinedGroupAdded = onJoinedGroupAdded;
    self.onJoinedGroupDeleted = onJoinedGroupDeleted;
    self.onGroupMemberAdded = onGroupMemberAdded;
    self.onGroupMemberInfoChanged = onGroupMemberInfoChanged;
    self.onGroupApplicationAdded = onGroupApplicationAdded;
    self.onGroupApplicationDeleted = onGroupApplicationDeleted;
    self.onGroupApplicationAccepted = onGroupApplicationAccepted;
    self.onGroupApplicationRejected = onGroupApplicationRejected;
    self.onGroupDismissed = onGroupDismissed;
}

- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(OIMRevokedCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt
                                onRecvGroupReadReceipt:(OIMReceiptCallback)onRecvGroupReadReceipt
                                      onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage {
    
    self.onRecvMessageRevoked = onRecvMessageRevoked;
    self.onRecvC2CReadReceipt = onRecvC2CReadReceipt;
    self.onRecvGroupReadReceipt = onRecvGroupReadReceipt;
    self.onRecvNewMessage = onRecvNewMessage;
}

- (void)setSelfUserInfoUpdateListener:(OIMUserInfoCallback)onUserInfoUpdate {
    [self setUserListenerWithUserInfoUpdate:onUserInfoUpdate onUserStatusChanged:nil];
}

- (void)setUserListenerWithUserInfoUpdate:(OIMUserInfoCallback)onUserInfoUpdate
                      onUserStatusChanged:(OIMUserStatusInfoCallback)onUserStatusChanged {
    self.onSelfInfoUpdated = onUserInfoUpdate;
    self.onUserStatusChanged = onUserStatusChanged;
}

- (void)setRecvCustomBusinessMessageListener:(OIMObjectCallback)onRecvCustomBusinessMessage {
    self.onRecvCustomBusinessMessage = onRecvCustomBusinessMessage;
}

@end
