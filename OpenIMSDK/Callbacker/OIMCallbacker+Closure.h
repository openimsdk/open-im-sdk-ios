//
//  OIMCallbacker+Closure.h
//  OpenIMSDK
//
//  Created by x on 2022/3/3.
//

#import "OIMCallbacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMCallbacker (Closure)
/*
 * 设置会话监听器
 * 如果会话改变，会触发   onConversationChanged
 * 如果新增会话，会触发   onNewConversation
 * 如果未读消息数改变，会触发    onTotalUnreadMessageCountChanged
 *
 * 启动app时主动拉取一次会话记录，后续会话改变可以根据监听器回调再刷新数据
 */
- (void)setConversationListenerWithOnSyncServerStart:(OIMVoidCallback)onSyncServerStart
                                  onSyncServerFinish:(OIMVoidCallback)onSyncServerFinish
                                  onSyncServerFailed:(OIMVoidCallback)onSyncServerFailed
                               onConversationChanged:(OIMConversationsInfoCallback)onConversationChanged
                                   onNewConversation:(OIMConversationsInfoCallback)onNewConversation
                    onTotalUnreadMessageCountChanged:(OIMNumberCallback)onTotalUnreadMessageCountChanged;

/*
 * 设置好友关系监听器
 *
 * 好友被拉入黑名单回调   onBlackAdded
 * 好友从黑名单移除回调   onBlackDeleted
 * 发起的好友请求被接受时回调    onFriendApplicationAccepted
 * 我接受别人的发起的好友请求时回调 onFriendApplicationAdded
 * 删除好友请求时回调    onFriendApplicationDeleted
 * 请求被拒绝回调  onFriendApplicationRejected
 * 好友资料发生变化时回调  onFriendInfoChanged
 * 已添加好友回调  onFriendAdded
 * 好友被删除时回调 onFriendDeleted
 **/
- (void)setFriendListenerWithOnBlackAdded:(OIMBlackInfoCallback)onBlackAdded
                           onBlackDeleted:(OIMBlackInfoCallback)onBlackDeleted
              onFriendApplicationAccepted:(OIMFriendApplicationCallback)onFriendApplicationAccepted
                 onFriendApplicationAdded:(OIMFriendApplicationCallback)onFriendApplicationAdded
               onFriendApplicationDeleted:(OIMFriendApplicationCallback)onFriendApplicationDeleted
              onFriendApplicationRejected:(OIMFriendApplicationCallback)onFriendApplicationRejected
                      onFriendInfoChanged:(OIMFriendInfoCallback)onFriendInfoChanged
                            onFriendAdded:(OIMFriendInfoCallback)onFriendAdded
                          onFriendDeleted:(OIMFriendInfoCallback)onFriendDeleted;

/*
 * 设置组监听器
 *
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
                    onGroupApplicationRejected:(OIMGroupApplicationCallback)onGroupApplicationRejected;

/*
 * 添加消息监听
 *
 * 当对方撤回条消息 onRecvMessageRevoked，通过回调将界面已显示的消息替换为"xx撤回了一套消息"
 * 当对方阅读了消息 onRecvC2CReadReceipt，通过回调将已读的消息更改状态。
 * 新增消息 onRecvNewMessage，向界面添加消息
 */
- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(OIMStringCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt
                                onRecvGroupReadReceipt:(OIMReceiptCallback)onRecvGroupReadReceipt
                                      onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage;

- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(nullable OIMStringCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt
                                onRecvGroupReadReceipt:(OIMReceiptCallback)onRecvGroupReadReceipt
                                      onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage
                               onNewRecvMessageRevoked:(OIMRevokedCallback)onNewRecvMessageRevoked;

- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(nullable OIMStringCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt
                                onRecvGroupReadReceipt:(OIMReceiptCallback)onRecvGroupReadReceipt
                                      onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage
                               onNewRecvMessageRevoked:(nullable OIMRevokedCallback)onNewRecvMessageRevoked
                        onRecvMessageExtensionsChanged:(nullable OIMKeyValueResultCallback)onRecvMessageExtensionsChanged
                        onRecvMessageExtensionsDeleted:(nullable OIMStringArrayCallback)onRecvMessageExtensionsDeleted
                          onRecvMessageExtensionsAdded:(nullable OIMKeyValueResultCallback)onRecvMessageExtensionsAdded;

/*
 * 用户信息监听
 *
 */
- (void)setSelfUserInfoUpdateListener:(OIMUserInfoCallback)onUserInfoUpdate;


/*
 * 设置音视频监听
 *
 * 被邀请者收到：音视频通话邀请   onReceiveNewInvitation
 * 邀请者收到：被邀请者同意音视频通话   onInviteeAccepted
 * 邀请者收到：被邀请者拒绝音视频通话    onInviteeRejected
 * 被邀请者收到：邀请者取消音视频通话 onInvitationCancelled
 * 邀请者收到：被邀请者超时未接通   onInvitationTimeout
 * 被邀请者（其他端）收到：比如被邀请者在手机拒接，在pc上会收到此回调  onInviteeRejectedByOtherDevice
 * 被邀请者（其他端）收到：比如被邀请者在手机拒接，在pc上会收到此回调  onInviteeAcceptedByOtherDevice
 * 房间信息 onRoomParticipantConnected
 * 成员断开 onRoomParticipantDisconnected
 */
- (void)setSignalingListenerWithOnReceiveNewInvitation:(OIMSignalingInvitationCallback)onReceiveNewInvitation
                                     onInviteeAccepted:(OIMSignalingInvitationCallback)onInviteeAccepted
                                     onInviteeRejected:(OIMSignalingInvitationCallback)onInviteeRejected
                                 onInvitationCancelled:(OIMSignalingInvitationCallback)onInvitationCancelled
                                   onInvitationTimeout:(OIMSignalingInvitationCallback)onInvitationTimeout
                        onInviteeRejectedByOtherDevice:(OIMSignalingInvitationCallback)onInviteeRejectedByOtherDevice
                        onInviteeAcceptedByOtherDevice:(OIMSignalingInvitationCallback)onInviteeAcceptedByOtherDevice;

- (void)setSignalingListenerWithOnReceiveNewInvitation:(OIMSignalingInvitationCallback)onReceiveNewInvitation
                                     onInviteeAccepted:(OIMSignalingInvitationCallback)onInviteeAccepted
                                     onInviteeRejected:(OIMSignalingInvitationCallback)onInviteeRejected
                                 onInvitationCancelled:(OIMSignalingInvitationCallback)onInvitationCancelled
                                   onInvitationTimeout:(OIMSignalingInvitationCallback)onInvitationTimeout
                        onInviteeRejectedByOtherDevice:(OIMSignalingInvitationCallback)onInviteeRejectedByOtherDevice
                        onInviteeAcceptedByOtherDevice:(OIMSignalingInvitationCallback)onInviteeAcceptedByOtherDevice
                            onRoomParticipantConnected:(nullable OIMSignalingParticipantChangeCallback)onRoomParticipantConnected
                         onRoomParticipantDisconnected:(nullable OIMSignalingParticipantChangeCallback)onRoomParticipantDisconnected
                                        onStreamChange:(nullable OIMSignalingMeetingStreamEventCallback)onStreamChange;

- (void)setSignalingListenerWithOnReceiveCustomSignal:(OIMStringCallback)onReceiveCustomSignal;

/*
 * 设置组织架构监听
 */
- (void)setOrganizationListenerWithOrganizationUpdated:(OIMVoidCallback)onOrganizationUpdated;
 

/*
 * 设置工作圈监听
 */
- (void)setWorkMomentsListenerWithOrganizationUpdated:(OIMVoidCallback)onRecvNewNotification;
@end

NS_ASSUME_NONNULL_END
