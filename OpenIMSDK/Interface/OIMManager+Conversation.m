//
//  OIMManager+Conversation.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+Conversation.h"
#import "CallbackProxy.h"

@implementation OIMManager (Conversation)

- (void)getAllConversationListWithOnSuccess:(OIMConversationsInfoCallback)onSuccess
                                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMConversationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetAllConversationList(callback, [self operationId]);
}

- (void)getConversationListSplitWithOffset:(NSInteger)offset
                                     count:(NSInteger)count
                                 onSuccess:(OIMConversationsInfoCallback)onSuccess
                                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMConversationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetConversationListSplit(callback, [self operationId], offset, count);
}

- (void)getOneConversationWithSessionType:(OIMConversationType)sessionType
                                 sourceID:(NSString *)sourceID
                                onSuccess:(OIMConversationInfoCallback)onSuccess
                                onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMConversationInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetOneConversation(callback, [self operationId], sessionType, sourceID);
}

- (void)getMultipleConversation:(NSArray<NSString *> *)ids
                      onSuccess:(OIMConversationsInfoCallback)onSuccess
                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMConversationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetMultipleConversation(callback, [self operationId], ids.mj_JSONString);
}

- (void)deleteConversationAndDeleteAllMsg:(NSString *)conversationID
                                onSuccess:(nullable OIMSuccessCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteConversationAndDeleteAllMsg(callback, [self operationId], conversationID);
}

- (void)clearConversationAndDeleteAllMsg:(NSString *)conversationID
                               onSuccess:(OIMSuccessCallback)onSuccess
                               onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkClearConversationAndDeleteAllMsg(callback, [self operationId], conversationID);
}

- (void)deleteAllConversationFromLocalWithOnSuccess:(OIMSuccessCallback)onSuccess
                                          onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteAllConversationFromLocal(callback, [self operationId]);
}

- (void)setConversationDraft:(NSString *)conversationID
                   draftText:(NSString *)draftText
                   onSuccess:(OIMSuccessCallback)onSuccess
                   onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetConversationDraft(callback, [self operationId], conversationID, draftText);
}

- (void)pinConversation:(NSString *)conversationID
               isPinned:(BOOL)isPinned
              onSuccess:(OIMSuccessCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkPinConversation(callback, [self operationId], conversationID, isPinned);
}

- (void)getTotalUnreadMsgCountWithOnSuccess:(OIMNumberCallback)onSuccess
                                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess(data.integerValue);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetTotalUnreadMsgCount(callback, [self operationId]);
}

- (void)getConversationRecvMessageOpt:(NSArray<NSString *> *)conversationIDs
                            onSuccess:(OIMConversationNotDisturbInfoCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMConversationNotDisturbInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetConversationRecvMessageOpt(callback, [self operationId], conversationIDs.mj_JSONString);
}

- (void)setConversationRecvMessageOpt:(NSString *)conversationID
                               status:(OIMReceiveMessageOpt)status
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetConversationRecvMessageOpt(callback, [self operationId], conversationID, status);
}

- (void)setConversationPrivateChat:(NSString *)conversationID
                            isPrivate:(BOOL)isPrivate
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetConversationPrivateChat(callback, [self operationId], conversationID, isPrivate);
}

- (void)setConversationBurnDuration:(NSString *)conversationID
                              duration:(NSInteger)burnDuration
                             onSuccess:(OIMSuccessCallback)onSuccess
                             onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetConversationBurnDuration(callback, [self operationId], conversationID, (int32_t)burnDuration);
}

- (void)resetConversationGroupAtType:(NSString *)conversationID
                           onSuccess:(OIMSuccessCallback)onSuccess
                           onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkResetConversationGroupAtType(callback, [self operationId], conversationID);
}

- (void)hideConversation:(NSString *)conversationID
               onSuccess:(OIMSuccessCallback)onSuccess
               onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkHideConversation(callback, [self operationId], conversationID);
}

- (void)markConversationMessageAsRead:(NSString *)conversationID
                            onSuccess:(nullable OIMSuccessCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];

    Open_im_sdkMarkConversationMessageAsRead(callback, [self operationId], conversationID);
}
@end
