//
//  OIMManager+Message.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+Message.h"
#import "SendMessageCallbackProxy.h"

@implementation OIMMessageInfo (extension)

- (BOOL)isSelf {
    return [self.sendID isEqualToString:[OIMManager.manager getLoginUid]];
}

+ (OIMMessageInfo *)convertToMessageInfo:(NSString *)json {
    OIMMessageInfo *msg = [OIMMessageInfo mj_objectWithKeyValues:json];
    msg.status = OIMMessageStatusUndefine;
    
    return msg;
}

+ (OIMMessageInfo *)createTextMessage:(NSString *)text {
    NSString *json = Open_im_sdkCreateTextMessage([OIMManager.manager operationId], text);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createTextAtMessage:(NSString *)text
                              atUidList:(NSArray<NSString *> *)atUidList
                            atUsersInfo:(NSArray<OIMAtInfo *> *)atUsersInfo
                                message:(OIMMessageInfo *)message {
    
    NSArray *atUsers = [OIMAtInfo mj_keyValuesArrayWithObjectArray:atUsersInfo];
    NSString *atUsersJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:atUsers options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSString *json = Open_im_sdkCreateTextAtMessage([OIMManager.manager operationId], text, atUidList.mj_JSONString, atUsersJson, message ? message.mj_JSONString : @"");

    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createTextAtAllMessage:(NSString *)text
                               displayText:(NSString *)displayText
                                   message:(OIMMessageInfo * _Nullable)message {
    NSString *json = Open_im_sdkCreateTextAtMessage([OIMManager.manager operationId], text, @[Open_im_sdkGetAtAllTag()].mj_JSONString, @[@{Open_im_sdkGetAtAllTag(): displayText ?: @"@全体成员"}].mj_JSONString, message ? message.mj_JSONString : @"");

    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createImageMessage:(NSString *)imagePath {
    NSString *json = Open_im_sdkCreateImageMessage([OIMManager.manager operationId], imagePath);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createImageMessageFromFullPath:(NSString *)imagePath {
    NSString *json = Open_im_sdkCreateImageMessageFromFullPath([OIMManager.manager operationId], imagePath);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createSoundMessage:(NSString *)soundPath
                              duration:(NSInteger)duration {
    NSString *json = Open_im_sdkCreateSoundMessage([OIMManager.manager operationId], soundPath, duration);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createSoundMessageFromFullPath:(NSString *)soundPath
                                          duration:(NSInteger)duration {
    NSString *json = Open_im_sdkCreateSoundMessageFromFullPath([OIMManager.manager operationId], soundPath, duration);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createVideoMessage:(NSString *)videoPath
                             videoType:(NSString *)videoType
                              duration:(NSInteger)duration
                          snapshotPath:(NSString *)snapshotPath {
    NSString *json = Open_im_sdkCreateVideoMessage([OIMManager.manager operationId], videoPath, videoType, duration, snapshotPath);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createVideoMessageFromFullPath:(NSString *)videoPath
                                         videoType:(NSString *)videoType
                                          duration:(NSInteger)duration
                                      snapshotPath:(NSString *)snapshotPath {
    NSString *json = Open_im_sdkCreateVideoMessageFromFullPath([OIMManager.manager operationId], videoPath, videoType, duration, snapshotPath);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createFileMessage:(NSString *)filePath
                             fileName:(NSString *)fileName {
    NSString *json = Open_im_sdkCreateFileMessage([OIMManager.manager operationId], filePath, fileName);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createFileMessageFromFullPath:(NSString *)filePath
                                         fileName:(NSString *)fileName {
    NSString *json = Open_im_sdkCreateFileMessageFromFullPath([OIMManager.manager operationId], filePath, fileName);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createMergeMessage:(NSArray<OIMMessageInfo *> *)messages
                                  title:(NSString *)title
                            summaryList:(NSArray<NSString *> *)summarys {
    NSArray *msgs = [OIMMessageInfo mj_keyValuesArrayWithObjectArray:messages];
    NSString *json = Open_im_sdkCreateMergerMessage([OIMManager.manager operationId], [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:msgs options:0 error:nil] encoding:NSUTF8StringEncoding], title, summarys.mj_JSONString);

    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createForwardMessage:(OIMMessageInfo *)message {
    NSString *json = Open_im_sdkCreateForwardMessage([OIMManager.manager operationId], message.mj_JSONString);
    
    return [OIMMessageInfo mj_objectWithKeyValues:json];
}

+ (OIMMessageInfo *)createLocationMessage:(NSString *)description
                                 latitude:(double)latitude
                                longitude:(double)longitude {
    NSString *json = Open_im_sdkCreateLocationMessage([OIMManager.manager operationId], description, longitude, latitude);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createQuoteMessage:(NSString *)text
                               message:(OIMMessageInfo *)message {
    NSString *json = Open_im_sdkCreateQuoteMessage([OIMManager.manager operationId], text, message.mj_JSONString);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createCardMessage:(NSString *)content {
    NSString *json = Open_im_sdkCreateCardMessage([OIMManager.manager operationId], content);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createCustomMessage:(NSString *)data
                              extension:(NSString *)extension
                            description:(NSString *)description {
    NSString *json = Open_im_sdkCreateCustomMessage([OIMManager.manager operationId], data, extension, description);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createFaceMessageWithIndex:(NSInteger)index
                                          data:(NSString *)dataStr {
    NSString *json = Open_im_sdkCreateFaceMessage([OIMManager.manager operationId], index, dataStr);
    
    return [self convertToMessageInfo:json];
}

@end

@implementation OIMManager (Message)

- (void)sendMessage:(OIMMessageInfo *)message
             recvID:(NSString *)recvID
            groupID:(NSString *)groupID
    offlinePushInfo:(OIMOfflinePushInfo *)offlinePushInfo
          onSuccess:(OIMSuccessCallback)onSuccess
         onProgress:(OIMNumberCallback)onProgress
          onFailure:(OIMFailureCallback)onFailure {
    SendMessageCallbackProxy *callback = [[SendMessageCallbackProxy alloc]initWithOnSuccess:onSuccess onProgress:onProgress onFailure:onFailure];
    
    Open_im_sdkSendMessage(callback, [self operationId], message.mj_JSONString, recvID ?: @"", groupID ?: @"", offlinePushInfo ? offlinePushInfo.mj_JSONString : @"{}");
}

- (void)sendMessageNotOss:(OIMMessageInfo *)message
                   recvID:(NSString *)recvID
                  groupID:(NSString *)groupID
          offlinePushInfo:(OIMOfflinePushInfo *)offlinePushInfo
                onSuccess:(OIMSuccessCallback)onSuccess
               onProgress:(OIMNumberCallback)onProgress
                onFailure:(OIMFailureCallback)onFailure {
    SendMessageCallbackProxy *callback = [[SendMessageCallbackProxy alloc]initWithOnSuccess:onSuccess onProgress:onProgress onFailure:onFailure];
    
    Open_im_sdkSendMessageNotOss(callback, [self operationId], message.mj_JSONString, recvID, groupID, offlinePushInfo.mj_JSONString);
}

- (void)getHistoryMessageListWithUserId:(NSString *)userID
                                groupID:(NSString *)groupID
                       startClientMsgID:(NSString *)startClientMsgID
                                  count:(NSInteger)count
                              onSuccess:(OIMMessagesInfoCallback)onSuccess
                              onFailure:(OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMessageInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    NSDictionary *param = @{@"userID": userID ?: @"",
                            @"groupID": groupID ?: @"",
                            @"startClientMsgID": startClientMsgID ?: @"",
                            @"count": @(count)};
    
    Open_im_sdkGetHistoryMessageList(callback, [self operationId], param.mj_JSONString);
}

- (void)getHistoryMessageListReverse:(OIMGetMessageOptions *)options
                           onSuccess:(nullable OIMMessagesInfoCallback)onSuccess
                           onFailure:(nullable OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMessageInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    NSString *t = options.mj_JSONString;
    
    Open_im_sdkGetHistoryMessageListReverse(callback, [self operationId], options.mj_JSONString);
}

- (void)revokeMessage:(OIMMessageInfo *)message
            onSuccess:(OIMSuccessCallback)onSuccess
            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkRevokeMessage(callback, [self operationId], message.mj_JSONString);
}

- (void)typingStatusUpdate:(NSString *)recvID
                    msgTip:(NSString *)msgTip
                 onSuccess:(OIMSuccessCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkTypingStatusUpdate(callback, [self operationId], recvID, msgTip);
}

- (void)markC2CMessageAsRead:(NSString *)userID
                   msgIDList:(NSArray<NSString *> *)msgIDList
                   onSuccess:(OIMSuccessCallback)onSuccess
                   onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkMarkC2CMessageAsRead(callback, [self operationId], userID, msgIDList.mj_JSONString);
}

- (void)markGroupMessageAsRead:(NSString *)groupID
                     msgIDList:(NSArray <NSString *> *)msgIDList
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkMarkGroupMessageAsRead(callback, [self operationId], groupID, msgIDList.mj_JSONString);
}

- (void)markMessageAsReadByConID:(NSString *)conversationID
                       msgIDList:(NSArray<NSString *> *)msgIDList
                       onSuccess:(OIMSuccessCallback)onSuccess
                       onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];

    Open_im_sdkMarkMessageAsReadByConID(callback, [self operationId], conversationID, msgIDList.mj_JSONString);
}

- (void)deleteMessage:(OIMMessageInfo *)message
            onSuccess:(nullable OIMSuccessCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteMessageFromLocalAndSvr(callback, [self operationId], message.mj_JSONString);
}

- (void)deleteMessageFromLocalStorage:(OIMMessageInfo *)message
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteMessageFromLocalStorage(callback, [self operationId], message.mj_JSONString);
}

- (void)clearC2CHistoryMessage:(NSString *)userID
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkClearC2CHistoryMessage(callback, [self operationId], userID);
}

- (void)clearC2CHistoryMessageFromLocalAndSvr:(NSString *)userID
                                    onSuccess:(OIMSuccessCallback)onSuccess
                                    onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkClearC2CHistoryMessageFromLocalAndSvr(callback, [self operationId], userID);
}

- (void)clearGroupHistoryMessage:(NSString *)groupID
                       onSuccess:(OIMSuccessCallback)onSuccess
                       onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkClearGroupHistoryMessage(callback, [self operationId], groupID);
}

- (void)clearGroupHistoryMessageFromLocalAndSvr:(NSString *)groupID
                                      onSuccess:(OIMSuccessCallback)onSuccess
                                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkClearGroupHistoryMessageFromLocalAndSvr(callback, [self operationId], groupID);
}

- (void)deleteAllMsgFromLocalWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteAllMsgFromLocal(callback, [self operationId]);
}

- (void)deleteAllMsgFromLocalAndSvrWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                       onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteAllMsgFromLocalAndSvr(callback, [self operationId]);
}

- (void)insertSingleMessageToLocalStorage:(OIMMessageInfo *)message
                                   recvID:(NSString *)recvID
                                   sendID:(NSString *)sendID
                                onSuccess:(OIMSuccessCallback)onSuccess
                                onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkInsertSingleMessageToLocalStorage(callback, [self operationId], message.mj_JSONString, recvID, sendID);
}

- (void)insertGroupMessageToLocalStorage:(OIMMessageInfo *)message
                                 groupID:(NSString *)groupID
                                  sendID:(NSString *)sendID
                               onSuccess:(OIMSuccessCallback)onSuccess
                               onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkInsertGroupMessageToLocalStorage(callback, [self operationId], message.mj_JSONString, groupID, sendID);
}

- (void)searchLocalMessages:(OIMSearchParam *)param
                  onSuccess:(OIMMessageSearchCallback)onSuccess
                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMSearchResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkSearchLocalMessages(callback, [self operationId], param.mj_JSONString);
}
@end
