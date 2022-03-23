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

- (NSString *)getConversationIDBySessionType:(OIMConversationType )sessionType
                                    sourceID:(NSString *)sourceID {
    return Open_im_sdkGetConversationIDBySessionType(sourceID, sessionType);
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

- (void)deleteConversationFromLocalStorage:(NSString *)conversationID
                                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteConversation(callback, [self operationId], conversationID);
}

- (void)deleteConversation:(NSString *)conversationID
                 onSuccess:(OIMSuccessCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteConversationMsgFromLocalAndSvr(callback, [self operationId], conversationID);
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

- (void)setConversationRecvMessageOpt:(NSArray<NSString *> *)conversationIDs
                               status:(OIMReceiveMessageOpt)status
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetConversationRecvMessageOpt(callback, [self operationId], conversationIDs.mj_JSONString, status);
}
@end
