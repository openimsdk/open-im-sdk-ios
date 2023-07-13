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
    return [self.sendID isEqualToString:[OIMManager.manager getLoginUserID]];
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

+ (OIMAtInfo *)createAtAllFlag:(NSString *)displayText {
    OIMAtInfo *all = [OIMAtInfo new];
    all.atUserID = Open_im_sdkGetAtAllTag([[NSUUID UUID]UUIDString]);
    all.groupNickname = displayText ?: @"Mention All";
    
    return all;
}

+ (OIMMessageInfo *)createTextAtMessage:(NSString *)text
                              atUsersID:(NSArray<NSString *> *)atUsersID
                            atUsersInfo:(NSArray<OIMAtInfo *> *)atUsersInfo
                                message:(OIMMessageInfo *)message {
    
    NSArray *atUsers = [OIMAtInfo mj_keyValuesArrayWithObjectArray:atUsersInfo];
    NSString *atUsersJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:atUsers options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSString *json = Open_im_sdkCreateTextAtMessage([OIMManager.manager operationId], text, atUsersID.mj_JSONString, atUsersJson, message ? message.mj_JSONString : @"");
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createTextAtAllMessage:(NSString *)text
                               displayText:(NSString *)displayText
                                   message:(OIMMessageInfo * _Nullable)message {
    NSString *json = Open_im_sdkCreateTextAtMessage([OIMManager.manager operationId], text, @[Open_im_sdkGetAtAllTag([[NSUUID UUID]UUIDString])].mj_JSONString, @[@{Open_im_sdkGetAtAllTag([[NSUUID UUID]UUIDString]): displayText ?: @"@全体成员"}].mj_JSONString, message ? message.mj_JSONString : @"");
    
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

+ (OIMMessageInfo *)createImageMessageByURL:(OIMPictureInfo *)source
                                 bigPicture:(OIMPictureInfo *)big
                            snapshotPicture:(OIMPictureInfo *)snapshot {
    
    NSString *json = Open_im_sdkCreateImageMessageByURL([OIMManager.manager operationId], source.mj_JSONString, big.mj_JSONString, snapshot.mj_JSONString);
    
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

+ (OIMMessageInfo *)createSoundMessageByURL:(NSString *)fileURL
                                   duration:(NSInteger)duration
                                       size:(NSInteger)size {
    OIMSoundElem *elem = [OIMSoundElem new];
    elem.sourceUrl = fileURL;
    elem.duration = duration;
    elem.dataSize = size;
    
    NSString *json = Open_im_sdkCreateSoundMessageByURL([OIMManager.manager operationId], elem.mj_JSONString);
    
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

+ (OIMMessageInfo *)createVideoMessageByURL:(NSString *)fileURL
                                  videoType:(NSString *)videoType
                                   duration:(NSInteger)duration
                                       size:(NSInteger)size
                                   snapshot:(NSString *)snapshotURL {
    OIMVideoElem *elem = [OIMVideoElem new];
    elem.videoUrl = fileURL;
    elem.videoType = videoType;
    elem.duration = duration;
    elem.videoSize = size;
    elem.snapshotUrl = snapshotURL;
    
    NSString *json = Open_im_sdkCreateVideoMessageByURL([OIMManager.manager operationId], elem.mj_JSONString);
    
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

+ (OIMMessageInfo *)createFileMessageByURL:(NSString *)fileURL
                                  fileName:(NSString *)fileName
                                      size:(NSInteger)size {
    OIMFileElem *elem = [OIMFileElem new];
    elem.sourceUrl = fileURL;
    elem.fileName = fileName ?: fileURL.lastPathComponent;
    elem.fileSize = size;
    
    NSString *json = Open_im_sdkCreateFileMessageByURL([OIMManager.manager operationId], elem.mj_JSONString);
    
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

+ (OIMMessageInfo *)createCardMessage:(OIMCardElem *)card {
    
    NSString *json = Open_im_sdkCreateCardMessage([OIMManager.manager operationId], card.mj_JSONString);
    
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

+ (OIMMessageInfo *)createAdvancedTextMessage:(NSString *)text
                            messageEntityList:(NSArray<OIMMessageEntity *> *)messageEntityList {
    NSArray *msgs = [OIMMessageEntity mj_keyValuesArrayWithObjectArray:messageEntityList];
    NSString *json = Open_im_sdkCreateAdvancedTextMessage([OIMManager.manager operationId], text, [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:msgs options:0 error:nil] encoding:NSUTF8StringEncoding]);
    
    return [self convertToMessageInfo:json];
}

+ (OIMMessageInfo *)createAdvancedQuoteMessage:(NSString *)text
                                       message:(OIMMessageInfo *)message
                             messageEntityList:(NSArray<OIMMessageEntity *> *)messageEntityList {
    NSArray *msgs = [OIMMessageEntity mj_keyValuesArrayWithObjectArray:messageEntityList];
    NSString *json = Open_im_sdkCreateAdvancedQuoteMessage([OIMManager.manager operationId], text, message.mj_JSONString, [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:msgs options:0 error:nil] encoding:NSUTF8StringEncoding]);
    
    return [self convertToMessageInfo:json];
}

@end

@implementation OIMManager (Message)

- (void)sendMessage:(OIMMessageInfo *)message
             recvID:(NSString *)recvID
            groupID:(NSString *)groupID
    offlinePushInfo:(OIMOfflinePushInfo *)offlinePushInfo
          onSuccess:(OIMMessageInfoCallback)onSuccess
         onProgress:(OIMNumberCallback)onProgress
          onFailure:(OIMFailureCallback)onFailure {
    
    assert(recvID.length != 0 || groupID.length != 0);
    
    SendMessageCallbackProxy *callback = [[SendMessageCallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMessageInfo mj_objectWithKeyValues:data]);
        }
    } onProgress:onProgress onFailure:onFailure];
    
    Open_im_sdkSendMessage(callback, [self operationId], message.mj_JSONString, recvID ?: @"", groupID ?: @"", offlinePushInfo ? offlinePushInfo.mj_JSONString : @"{}");
}

- (void)sendMessageNotOss:(OIMMessageInfo *)message
                   recvID:(NSString *)recvID
                  groupID:(NSString *)groupID
          offlinePushInfo:(OIMOfflinePushInfo *)offlinePushInfo
                onSuccess:(OIMMessageInfoCallback)onSuccess
               onProgress:(OIMNumberCallback)onProgress
                onFailure:(OIMFailureCallback)onFailure {
    
    assert(recvID.length != 0 || groupID.length != 0);
    
    SendMessageCallbackProxy *callback = [[SendMessageCallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMessageInfo mj_objectWithKeyValues:data]);
        }
    } onProgress:onProgress onFailure:onFailure];
    
    Open_im_sdkSendMessageNotOss(callback, [self operationId], message.mj_JSONString, recvID, groupID, offlinePushInfo.mj_JSONString);
}

- (void)revokeMessage:(NSString *)conversationID
          clientMsgID:(NSString *)clientMsgID
            onSuccess:(OIMSuccessCallback)onSuccess
            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkRevokeMessage(callback, [self operationId], conversationID, clientMsgID);
}

- (void)typingStatusUpdate:(NSString *)recvID
                    msgTip:(NSString *)msgTip
                 onSuccess:(OIMSuccessCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkTypingStatusUpdate(callback, [self operationId], recvID, msgTip);
}

- (void)markConversationMessageAsRead:(NSString *)conversationID
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkMarkConversationMessageAsRead(callback, [self operationId], conversationID);
}

- (void)markMessageAsReadByMsgID:(NSString *)conversationID
                    clientMsgIDs:(NSArray <NSString *> *)clientMsgIDs
                       onSuccess:(nullable OIMSuccessCallback)onSuccess
                       onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkMarkMessagesAsReadByMsgID(callback, [self operationId], conversationID, clientMsgIDs.mj_JSONString);
}

- (void)deleteMessage:(NSString *)conversationID
          clientMsgID:(NSString *)clientMsgID
            onSuccess:(nullable OIMSuccessCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteMessage(callback, [self operationId], conversationID, clientMsgID);
}

- (void)deleteMessageFromLocalStorage:(NSString *)conversationID
                          clientMsgID:(NSString *)clientMsgID
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteMessageFromLocalStorage(callback, [self operationId], conversationID, clientMsgID);
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
                                onSuccess:(OIMMessageInfoCallback)onSuccess
                                onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMessageInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkInsertSingleMessageToLocalStorage(callback, [self operationId], message.mj_JSONString, recvID, sendID);
}

- (void)insertGroupMessageToLocalStorage:(OIMMessageInfo *)message
                                 groupID:(NSString *)groupID
                                  sendID:(NSString *)sendID
                               onSuccess:(OIMMessageInfoCallback)onSuccess
                               onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMessageInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
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

- (void)uploadFile:(NSString *)fullPath
           name:(NSString * _Nullable)name
          cause:(NSString * _Nullable)cause
     onProgress:(OIMUploadProgressCallback)onProgress
   onCompletion:(OIMUploadCompletionCallback)onCompletion
      onSuccess:(OIMSuccessCallback)onSuccess
      onFailure:(OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    UploadFileCallbackProxy *upload = [[UploadFileCallbackProxy alloc]initWithOnProgress:onProgress onCompletion:onCompletion];
    
    NSDictionary *param = @{@"putID": fullPath.lastPathComponent,
                            @"name": name ?: fullPath.lastPathComponent,
                            @"filepath": fullPath,
                            @"cause": cause ?: @""};
    
    Open_im_sdkUploadFile(callback, [self operationId], param.mj_JSONString, upload);
}

- (void)setGlobalRecvMessageOpt:(OIMReceiveMessageOpt)opt
                      onSuccess:(OIMSuccessCallback)onSuccess
                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGlobalRecvMessageOpt(callback, [self operationId], opt);
}

- (void)getAdvancedHistoryMessageList:(OIMGetAdvancedHistoryMessageListParam *)opts
                            onSuccess:(OIMGetAdvancedHistoryMessageListCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGetAdvancedHistoryMessageListInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetAdvancedHistoryMessageList(callback, [self operationId], opts.mj_JSONString);
}

- (void)getAdvancedHistoryMessageListReverse:(OIMGetAdvancedHistoryMessageListParam *)opts
                                   onSuccess:(nullable OIMGetAdvancedHistoryMessageListCallback)onSuccess
                                   onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGetAdvancedHistoryMessageListInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetAdvancedHistoryMessageListReverse(callback, [self operationId], opts.mj_JSONString);
}

- (void)findMessageList:(NSArray<OIMFindMessageListParam *> *)param
              onSuccess:(OIMMessageSearchCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMSearchResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    NSArray *params = [OIMFindMessageListParam mj_keyValuesArrayWithObjectArray:param];
    
    Open_im_sdkFindMessageList(callback, [self operationId], params.mj_JSONString);
}

- (void)setAppBadge:(NSInteger)count
          onSuccess:(OIMSuccessCallback)onSuccess
          onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetAppBadge(callback, [self operationId], (int32_t)count);
}

@end
