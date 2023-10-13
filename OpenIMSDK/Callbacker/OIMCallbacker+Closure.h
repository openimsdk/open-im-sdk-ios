//
//  OIMCallbacker+Closure.h
//  OpenIMSDK
//
//  Created by x on 2022/3/3.
//

#import "OIMCallbacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMCallbacker (Closure)
/**
 * Set conversation listeners
 * If a conversation changes, it triggers onConversationChanged.
 * If a new conversation is added, it triggers onNewConversation.
 * If the total unread message count changes, it triggers onTotalUnreadMessageCountChanged.
 *
 * Actively fetch conversation records at app startup, and later refresh data based on listener callbacks for conversation changes.
 */
- (void)setConversationListenerWithOnSyncServerStart:(OIMVoidCallback)onSyncServerStart
                                  onSyncServerFinish:(OIMVoidCallback)onSyncServerFinish
                                  onSyncServerFailed:(OIMVoidCallback)onSyncServerFailed
                               onConversationChanged:(OIMConversationsInfoCallback)onConversationChanged
                                   onNewConversation:(OIMConversationsInfoCallback)onNewConversation
                    onTotalUnreadMessageCountChanged:(OIMNumberCallback)onTotalUnreadMessageCountChanged;

/**
 * Set friend relationship listeners
 *
 * Callbacks for a friend being added to the blacklist (onBlackAdded),
 * a friend being removed from the blacklist (onBlackDeleted),
 * accepting a friend request initiated by someone (onFriendApplicationAccepted),
 * receiving a friend request initiated by someone (onFriendApplicationAdded),
 * deleting a friend request (onFriendApplicationDeleted),
 * rejecting a friend request (onFriendApplicationRejected),
 * friend profile changes (onFriendInfoChanged),
 * added friends (onFriendAdded),
 * and deleted friends (onFriendDeleted).
 */
- (void)setFriendListenerWithOnBlackAdded:(OIMBlackInfoCallback)onBlackAdded
                           onBlackDeleted:(OIMBlackInfoCallback)onBlackDeleted
              onFriendApplicationAccepted:(OIMFriendApplicationCallback)onFriendApplicationAccepted
                 onFriendApplicationAdded:(OIMFriendApplicationCallback)onFriendApplicationAdded
               onFriendApplicationDeleted:(OIMFriendApplicationCallback)onFriendApplicationDeleted
              onFriendApplicationRejected:(OIMFriendApplicationCallback)onFriendApplicationRejected
                      onFriendInfoChanged:(OIMFriendInfoCallback)onFriendInfoChanged
                            onFriendAdded:(OIMFriendInfoCallback)onFriendAdded
                          onFriendDeleted:(OIMFriendInfoCallback)onFriendDeleted;

/**
 * Set group listeners
 */
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
                              onGroupDismissed:(nullable OIMGroupInfoCallback)onGroupDismissed;

/**
 * Add message listeners
 *
 * When the other party revokes a message (onRecvMessageRevoked), use the callback to replace displayed messages with "xx revoked a message."
 * When the other party reads a message (onRecvC2CReadReceipt), use the callback to change the status of read messages.
 * For new messages (onRecvNewMessage), add messages to the interface.
 */
- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(OIMRevokedCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt
                                onRecvGroupReadReceipt:(OIMReceiptCallback)onRecvGroupReadReceipt
                                      onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage;

/**
 * User information listeners
 */
- (void)setSelfUserInfoUpdateListener:(OIMUserInfoCallback)onUserInfoUpdate;

- (void)setUserListenerWithUserInfoUpdate:(nullable OIMUserInfoCallback)onUserInfoUpdate
                      onUserStatusChanged:(nullable OIMUserStatusInfoCallback)onUserStatusChanged;

/**
 * Custom messages
 */
- (void)setRecvCustomBusinessMessageListener:(OIMObjectCallback)onRecvCustomBusinessMessage;
@end

NS_ASSUME_NONNULL_END
