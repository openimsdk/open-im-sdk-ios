//
//  OIMManager+Conversation.h
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager.h"
#import "OIMConversationInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Conversation)

/*
 * 获取会话列表
 *
 */
- (void)getAllConversationListWithOnSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                                  onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 分页获取会话列表
 * @param offset    起始偏移量
 * @param count 拉取会话的数量
 */
- (void)getConversationListSplitWithOffset:(NSInteger)offset
                                     count:(NSInteger)count
                                 onSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 获取一个会话，如果不存在会自动创建
 * @param sessionType   会话的类型，单聊为1，群聊为2
 * @param sourceID  单聊为用户ID，群聊为群ID
 */
- (void)getOneConversationWithSessionType:(OIMConversationType)sessionType
                                 sourceID:(NSString *)sourceID
                                onSuccess:(nullable OIMConversationInfoCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 获取会话ID
 * @param sessionType   会话的类型，单聊为1，群聊为2
 * @param sourceID  单聊为用户ID，群聊为群ID
 */
- (NSString *)getConversationIDBySessionType:(OIMConversationType)sessionType
                                    sourceID:(NSString *)sourceID;

/*
 * 获取多个会话列表
 * @param ids   会话ID的列表
 */
- (void)getMultipleConversation:(NSArray <NSString *> *)ids
                       onSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                       onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 本地删除一个会话
 * @param conversationID    会话ID
 */
- (void)deleteConversationFromLocalStorage:(NSString *)conversationID
                                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 删除一个会话
 * @param conversationID    会话ID
 */
- (void)deleteConversation:(NSString *)conversationID
                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 删除所有会话
 *
 */
- (void)deleteAllConversationFromLocalWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                          onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 设置会话的草稿
 * @param conversationID    会话ID
 * @param draftText 草稿文本，如果为""则为删除草稿
 */
- (void)setConversationDraft:(NSString *)conversationID
                   draftText:(NSString *)draftText
                   onSuccess:(nullable OIMSuccessCallback)onSuccess
                   onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 置顶会话
 * @param conversationID    会话ID
 * @param isPinned  为YES时，代表置顶会话，为NO时代表取消置顶
 */
- (void)pinConversation:(NSString *)conversationID
               isPinned:(BOOL)isPinned
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 获取总的消息未读数
 *
 */
- (void)getTotalUnreadMsgCountWithOnSuccess:(nullable OIMNumberCallback)onSuccess
                                  onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 获取会话免打扰状态
 *
 */
- (void)getConversationRecvMessageOpt:(NSArray <NSString *> *)conversationIDs
                            onSuccess:(nullable OIMConversationNotDisturbInfoCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 设置会话免打扰状态
 *
 */
- (void)setConversationRecvMessageOpt:(NSArray <NSString *> *)conversationIDs
                               status:(OIMReceiveMessageOpt)status
                            onSuccess:(nullable OIMSuccessCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 设置私聊, 可做“阅后即焚”功能
 *
 */
- (void)setOneConversationPrivateChat:(NSString *)conversationID
                            isPrivate:(BOOL)isPrivate
                            onSuccess:(nullable OIMSuccessCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
