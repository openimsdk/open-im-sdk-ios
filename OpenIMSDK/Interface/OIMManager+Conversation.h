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

/**
 * Get the list of conversations
 */
- (void)getAllConversationListWithOnSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                                  onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get a paginated list of conversations
 * @param offset    Starting offset
 * @param count Number of conversations to fetch
 */
- (void)getConversationListSplitWithOffset:(NSInteger)offset
                                     count:(NSInteger)count
                                 onSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get a conversation; it will be automatically created if it doesn't exist
 * @param sessionType   Type of the conversation, 1 for one-on-one, 2 for group
 * @param sourceID  User ID for one-on-one or group ID for group
 */
- (void)getOneConversationWithSessionType:(OIMConversationType)sessionType
                                 sourceID:(NSString *)sourceID
                                onSuccess:(nullable OIMConversationInfoCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get multiple conversation lists
 * @param conversationIDs   List of conversation IDs
 */
- (void)getMultipleConversation:(NSArray <NSString *> *)conversationIDs
                       onSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                       onFailure:(nullable OIMFailureCallback)onFailure;

- (NSString *)getConversationIDBySessionType:(OIMConversationType)sessionType
                                    sourceID:(NSString *)sourceID;

/**
 * Delete a conversation locally
 * @param conversationID    Conversation ID
 */
- (void)deleteConversationAndDeleteAllMsg:(NSString *)conversationID
                                onSuccess:(nullable OIMSuccessCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Clear a conversation both locally and on the server
 * @param conversationID    Conversation ID
 */
- (void)clearConversationAndDeleteAllMsg:(NSString *)conversationID
                               onSuccess:(nullable OIMSuccessCallback)onSuccess
                               onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Delete all conversations
 */
- (void)deleteAllConversationFromLocalWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                          onFailure:(nullable OIMFailureCallback)onFailure __attribute__((deprecated("Use hideAllConversations instead")));

/**
 * Set the draft for a conversation
 * @param conversationID    Conversation ID
 * @param draftText Draft text; if it's "", the draft will be deleted
 */
- (void)setConversationDraft:(NSString *)conversationID
                   draftText:(NSString *)draftText
                   onSuccess:(nullable OIMSuccessCallback)onSuccess
                   onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Pin or unpin a conversation
 * @param conversationID    Conversation ID
 * @param isPinned  If YES, the conversation will be pinned; if NO, it will be unpinned
 */
- (void)pinConversation:(NSString *)conversationID
               isPinned:(BOOL)isPinned
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get the total number of unread messages
 */
- (void)getTotalUnreadMsgCountWithOnSuccess:(nullable OIMNumberCallback)onSuccess
                                  onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get the "do not disturb" status for a conversation
 */
- (void)getConversationRecvMessageOpt:(NSArray <NSString *> *)conversationIDs
                            onSuccess:(nullable OIMConversationNotDisturbInfoCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set the "do not disturb" status for a conversation
 */
- (void)setConversationRecvMessageOpt:(NSString *)conversationID
                               status:(OIMReceiveMessageOpt)status
                            onSuccess:(nullable OIMSuccessCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set private chat mode, can be used for "self-destructing" messages
 */
- (void)setConversationPrivateChat:(NSString *)conversationID
                         isPrivate:(BOOL)isPrivate
                         onSuccess:(nullable OIMSuccessCallback)onSuccess
                         onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set private chat mode with a self-destruct timer
 */
- (void)setConversationBurnDuration:(NSString *)conversationID
                           duration:(NSInteger)burnDuration
                          onSuccess:(nullable OIMSuccessCallback)onSuccess
                          onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Reset the at symbol for a conversation
 */
- (void)resetConversationGroupAtType:(NSString *)conversationID
                           onSuccess:(nullable OIMSuccessCallback)onSuccess
                           onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Hide a conversation without deleting chat history;
 * If new messages arrive, the conversation will reappear.
 */
- (void)hideConversation:(NSString *)conversationID
               onSuccess:(nullable OIMSuccessCallback)onSuccess
               onFailure:(nullable OIMFailureCallback)onFailure;

- (void)hideAllConversationsWithOnSuccess:(OIMSuccessCallback)onSuccess
                               onFailure:(OIMFailureCallback)onFailure;

/**
 * Clear unread messages
 */
- (void)markConversationMessageAsRead:(NSString *)conversationID
                            onSuccess:(nullable OIMSuccessCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

- (void)setConversationEx:(NSString *)conversationID
                       ex:(NSString *)ex
                onSuccess:(nullable OIMSuccessCallback)onSuccess
                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Search sessions based on session name.
 */
- (void)searchConversation:(NSString *)name
                onSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
