//
//  OIMCallbacker+Conversation.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCallbacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMCallbacker (Conversation)

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

@end

NS_ASSUME_NONNULL_END
