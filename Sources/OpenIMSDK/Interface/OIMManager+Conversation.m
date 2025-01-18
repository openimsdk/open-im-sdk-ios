//
//  OIMManager+Conversation.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+Conversation.h"
#import "CallbackProxy.h"
#import "OIMConversationInfo.h"

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
    
    Open_im_sdkGetOneConversation(callback, [self operationId], (int32_t)sessionType, sourceID);
}

- (NSString *)getConversationIDBySessionType:(OIMConversationType)sessionType
                                    sourceID:(NSString *)sourceID {
    return Open_im_sdkGetConversationIDBySessionType([self operationId], sourceID, sessionType);
}

- (void)getMultipleConversation:(NSArray<NSString *> *)conversationIDs
                      onSuccess:(OIMConversationsInfoCallback)onSuccess
                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMConversationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetMultipleConversation(callback, [self operationId], conversationIDs.mj_JSONString);
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
    
    [self setConversation:conversationID req:@{@"isPinned": @(isPinned)} onSuccess:onSuccess onFailure:onFailure];
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

- (void)setConversationRecvMessageOpt:(NSString *)conversationID
                               status:(OIMReceiveMessageOpt)status
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {

    [self setConversation:conversationID req:@{@"recvMsgOpt": @(status)} onSuccess:onSuccess onFailure:onFailure];
}

- (void)setConversationPrivateChat:(NSString *)conversationID
                            isPrivate:(BOOL)isPrivate
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    
    [self setConversation:conversationID req:@{@"isPrivateChat": @(isPrivate)} onSuccess:onSuccess onFailure:onFailure];
}

- (void)setConversationBurnDuration:(NSString *)conversationID
                              duration:(NSInteger)burnDuration
                             onSuccess:(OIMSuccessCallback)onSuccess
                             onFailure:(OIMFailureCallback)onFailure {
    
    [self setConversation:conversationID req:@{@"burnDuration": @(burnDuration)} onSuccess:onSuccess onFailure:onFailure];
}

- (void)resetConversationGroupAtType:(NSString *)conversationID
                           onSuccess:(OIMSuccessCallback)onSuccess
                           onFailure:(OIMFailureCallback)onFailure {
    
    [self setConversation:conversationID req:@{@"groupAtType": @0} onSuccess:onSuccess onFailure:onFailure];
}

- (void)hideConversation:(NSString *)conversationID
               onSuccess:(OIMSuccessCallback)onSuccess
               onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkHideConversation(callback, [self operationId], conversationID);
}

- (void)hideAllConversationsWithOnSuccess:(OIMSuccessCallback)onSuccess
                               onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkHideAllConversations(callback, [self operationId]);
}

- (void)markConversationMessageAsRead:(NSString *)conversationID
                            onSuccess:(nullable OIMSuccessCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];

    Open_im_sdkMarkConversationMessageAsRead(callback, [self operationId], conversationID);
}

- (void)setConversationEx:(NSString *)conversationID
                       ex:(NSString *)ex
                onSuccess:(nullable OIMSuccessCallback)onSuccess
                onFailure:(nullable OIMFailureCallback)onFailure {
    
    [self setConversation:conversationID req:@{@"ex": ex} onSuccess:onSuccess onFailure:onFailure];
}

- (void)searchConversation:(NSString *)name
                onSuccess:(nullable OIMConversationsInfoCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMConversationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkSearchConversation(callback, [self operationId], name);
}

- (void)changeInputStates:(NSString *)conversationID
                    focus:(BOOL)focus
                onSuccess:(OIMSuccessCallback)onSuccess
                onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkChangeInputStates(callback, [self operationId], conversationID, focus);
}

- (void)getInputstates:(NSString *)conversationID
                userID:(NSString *)userID
             onSuccess:(OIMInputStatusChangedCallback)onSuccess
             onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess(data.mj_JSONObject);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetInputStates(callback, [self operationId], conversationID, userID);
}

- (void)setConversation:(NSString *)conversationID
                    req:(NSDictionary *)req
             onSuccess:(nullable OIMSuccessCallback)onSuccess
             onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetConversation(callback, [self operationId], conversationID, req.mj_JSONString);
}
@end
