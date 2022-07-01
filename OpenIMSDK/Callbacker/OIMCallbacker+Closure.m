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
                    onGroupApplicationRejected:(OIMGroupApplicationCallback)onGroupApplicationRejected {
    self.onGroupInfoChanged = onGroupInfoChanged;
    self.onJoinedGroupAdded = onJoinedGroupAdded;
    self.onJoinedGroupDeleted = onJoinedGroupDeleted;
    self.onGroupMemberAdded = onGroupMemberAdded;
    self.onGroupMemberInfoChanged = onGroupMemberInfoChanged;
    self.onGroupApplicationAdded = onGroupApplicationAdded;
    self.onGroupApplicationDeleted = onGroupApplicationDeleted;
    self.onGroupApplicationAccepted = onGroupApplicationAccepted;
    self.onGroupApplicationRejected = onGroupApplicationRejected;
}

- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(OIMStringCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt
                                onRecvGroupReadReceipt:(OIMReceiptCallback)onRecvGroupReadReceipt
                                      onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage {
    
    self.onRecvMessageRevoked = onRecvMessageRevoked;
    self.onRecvC2CReadReceipt = onRecvC2CReadReceipt;
    self.onRecvGroupReadReceipt = onRecvGroupReadReceipt;
    self.onRecvNewMessage = onRecvNewMessage;
}

- (void)setSelfUserInfoUpdateListener:(OIMUserInfoCallback)onUserInfoUpdate {
    self.onSelfInfoUpdated = onUserInfoUpdate;
}

- (void)setSignalingListenerWithOnReceiveNewInvitation:(OIMSignalingInvitationCallback)onReceiveNewInvitation
                                     onInviteeAccepted:(OIMSignalingInvitationCallback)onInviteeAccepted
                                     onInviteeRejected:(OIMSignalingInvitationCallback)onInviteeRejected
                                 onInvitationCancelled:(OIMSignalingInvitationCallback)onInvitationCancelled
                                   onInvitationTimeout:(OIMSignalingInvitationCallback)onInvitationTimeout
                        onInviteeRejectedByOtherDevice:(OIMSignalingInvitationCallback)onInviteeRejectedByOtherDevice
                        onInviteeAcceptedByOtherDevice:(OIMSignalingInvitationCallback)onInviteeAcceptedByOtherDevice {
    self.onReceiveNewInvitation = onReceiveNewInvitation;
    self.onInviteeAccepted = onInviteeAccepted;
    self.onInviteeRejected = onInviteeRejected;
    self.onInvitationCancelled = onInvitationCancelled;
    self.onInvitationTimeout = onInvitationTimeout;
    self.onInviteeRejectedByOtherDevice = onInviteeRejectedByOtherDevice;
    self.onInviteeAcceptedByOtherDevice = onInviteeAcceptedByOtherDevice;
}

- (void)setOrganizationListenerWithOrganizationUpdated:(OIMVoidCallback)onOrganizationUpdated {
    
    self.organizationUpdated = onOrganizationUpdated;
}

- (void)setWorkMomentsListenerWithOrganizationUpdated:(OIMVoidCallback)onRecvNewNotification {
    
    self.recvNewNotification = onRecvNewNotification;
}

@end
