//
//  OIMManager+Message.h
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager.h"
#import "UploadFileCallbackProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMMessageInfo (extension)

/*
 *  是否是发送出去的消息
 */
- (BOOL)isSelf;

/*
 * 创建文本消息
 *
 * @param text 内容
 */
+ (OIMMessageInfo *)createTextMessage:(NSString *)text;


/**
   可配套createTextAtMessage使用，将@所有人标识插入指定位置
 */
+ (OIMAtInfo *)createAtAllFlag:(NSString *)displayText;


/*
 * 创建@文本消息
 *
 * @param text      内容
 * @param atUsersID 用户id列表
 * @param atUsersInfo 用户在群内的信息
 * @param message 引用消息的时候使用
 */
+ (OIMMessageInfo *)createTextAtMessage:(NSString *)text
                              atUsersID:(NSArray<NSString *> *)atUsersID
                            atUsersInfo:(NSArray<OIMAtInfo *> *)atUsersInfo
                                message:(OIMMessageInfo * _Nullable)message;

/*
 * 创建@全体成员文本消息
 *
 * @param text      内容
 * @param displayText 展示的内容, 例如“@全体成员“
 * @param message 引用消息的时候使用
 */
+ (OIMMessageInfo *)createTextAtAllMessage:(NSString *)text
                               displayText:(NSString * _Nullable)displayText
                                   message:(OIMMessageInfo * _Nullable)message;

/*
 * 创建图片消息（
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将图片复制到A路径下后，如 A/pic/a.png路径，imagePath的值：“/pic/.png”
 *
 * @param imagePath 相对路径
 */
+ (OIMMessageInfo *)createImageMessage:(NSString *)imagePath;

/*
 * 创建图片消息
 *
 * @param imagePath 绝对路径
 */
+ (OIMMessageInfo *)createImageMessageFromFullPath:(NSString *)imagePath;

/*
 * 创建音频消息
 * 例如：自行上传的文件，然后使用返回的url发送消息
 *
 */
+ (OIMMessageInfo *)createImageMessageByURL:(OIMPictureInfo *)source
                                 bigPicture:(OIMPictureInfo *)big
                            snapshotPicture:(OIMPictureInfo *)snapshot;
                                   

/*
 * 创建声音消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/voice/a.m4c路径，soundPath的值：“/voice/.m4c”
 *
 * @param soundPath 相对路径
 * @param duration  时长
 */
+ (OIMMessageInfo *)createSoundMessage:(NSString *)soundPath
                              duration:(NSInteger)duration;

/*
 * 创建声音消息
 *
 * @param soundPath 绝对路径
 * @param duration  时长
 */
+ (OIMMessageInfo *)createSoundMessageFromFullPath:(NSString *)soundPath
                                          duration:(NSInteger)duration;

/*
 * 创建音频消息
 * 例如：自行上传的文件，然后使用返回的url发送消息
 *
 */
+ (OIMMessageInfo *)createSoundMessageByURL:(NSString *)fileURL
                                   duration:(NSInteger)duration
                                       size:(NSInteger)size;

/*
 * 创建视频消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/video/a.mp4路径，soundPath的值：“/video/.mp4”
 *
 * @param videoPath    视频相对路径
 * @param videoType    mine type
 * @param duration     时长
 * @param snapshotPath 缩略图相对路径
 */
+ (OIMMessageInfo *)createVideoMessage:(NSString *)videoPath
                             videoType:(NSString *)videoType
                              duration:(NSInteger)duration
                          snapshotPath:(NSString *)snapshotPath;

/*
 * 创建视频消息
 *
 * @param videoPath    绝对路径
 * @param videoType    mine type
 * @param duration     时长
 * @param snapshotPath 缩略图绝对路径
 *
 */
+ (OIMMessageInfo *)createVideoMessageFromFullPath:(NSString *)videoPath
                                         videoType:(NSString *)videoType
                                          duration:(NSInteger)duration
                                      snapshotPath:(NSString *)snapshotPath;

/*
 * 创建视频频消息
 * 例如：自行上传的文件，然后使用返回的url发送消息
 *
 */
+ (OIMMessageInfo *)createVideoMessageByURL:(NSString *)fileURL
                                  videoType:(NSString * _Nullable)videoType
                                   duration:(NSInteger)duration
                                      size:(NSInteger)size
                                   snapshot:(NSString * _Nullable)snapshotURL
;

/*
 * 创建文件消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/file/a.txt路径，soundPath的值：“/file/.txt”
 *
 * @param filePath 相对路径
 * @param fileName 文件名
 */
+ (OIMMessageInfo *)createFileMessage:(NSString *)filePath
                             fileName:(NSString *)fileName;

/*
 * 创建文件消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/file/a.txt路径，soundPath的值：“/file/.txt”
 *
 * @param filePath 绝对路径
 * @param fileName 文件名
 *
 */
+ (OIMMessageInfo *)createFileMessageFromFullPath:(NSString *)filePath
                                         fileName:(NSString *)fileName;

/*
 * 创建文件消息
 * 例如：自行上传的文件，然后使用返回的url发送消息
 *
 */
+ (OIMMessageInfo *)createFileMessageByURL:(NSString *)fileURL
                                  fileName:(NSString * _Nullable)fileName
                                      size:(NSInteger)size;

/*
 * 创建合并消息
 *
 * @param title       标题
 * @param summaryList 摘要
 * @param messageList 消息列表
 */
+ (OIMMessageInfo *)createMergeMessage:(NSArray <OIMMessageInfo *> *)messages
                                 title:(NSString *)title
                           summaryList:(NSArray <NSString *> *)summarys;

/*
 * 创建转发消息
 *
 */
+ (OIMMessageInfo *)createForwardMessage:(OIMMessageInfo *)message;

/*
 * 创建位置消息
 *
 * @param latitude    经度
 * @param longitude   纬度
 * @param description 描述消息
 */
+ (OIMMessageInfo *)createLocationMessage:(NSString *)description
                                 latitude:(double)latitude
                                longitude:(double)longitude;

/*
 * 创建引用消息
 *
 * @param text    内容
 * @param message 被引用的消息体
 * 
 */
+ (OIMMessageInfo *)createQuoteMessage:(NSString *)text
                               message:(OIMMessageInfo *)message;

/*
 * 创建名片消息
 *
 * @param content String
*/
+ (OIMMessageInfo *)createCardMessage:(OIMCardElem *)card;

/*
 * 创建自定义消息
 *
 * @param data        json String
 * @param extension   json String
 * @param description 描述
 */
+ (OIMMessageInfo *)createCustomMessage:(NSString *)data
                              extension:(NSString * _Nullable)extension
                            description:(NSString * _Nullable)description;

/*
 * 创建动图消息
 *
 */
+ (OIMMessageInfo *)createFaceMessageWithIndex:(NSInteger)index
                                          data:(NSString *)dataStr;


/*
 * 创建高级消息
 *
 */
+ (OIMMessageInfo *)createAdvancedTextMessage:(NSString *)text
                            messageEntityList:(NSArray <OIMMessageEntity *> *)messageEntityList;

/*
 * 创建高级引用消息
 *
 */
+ (OIMMessageInfo *)createAdvancedQuoteMessage:(NSString *)text
                                       message:(OIMMessageInfo *)message
                             messageEntityList:(NSArray <OIMMessageEntity *> *)messageEntityList;

@end

@interface OIMManager (Message)

/*
 * 发送消息
 *
 * @param message       消息体为通过Create...Message创建的OIMMessageInfo
 * @param recvID        单聊的用户ID，如果为群聊则为""
 * @param groupID       群聊的群ID，如果为单聊则为""
 * @param offlinePushInfo 离线推送的消息为OIMOfflinePushInfo
 */
- (void)sendMessage:(OIMMessageInfo *)message
             recvID:(NSString * _Nullable)recvID
            groupID:(NSString * _Nullable)groupID
    offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
          onSuccess:(nullable OIMMessageInfoCallback)onSuccess
         onProgress:(nullable OIMNumberCallback)onProgress
          onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 发送消息不通过sdk内置OSS上传多媒体文件
 *
 * @param message       消息体为通过Create...Message创建的OIMMessageInfo
 * @param recvID        单聊的用户ID，如果为群聊则为""
 * @param groupID       群聊的群ID，如果为单聊则为""
 * @param offlinePushInfo 离线推送的消息为OIMOfflinePushInfo
 */
- (void)sendMessageNotOss:(OIMMessageInfo *)message
                   recvID:(NSString * _Nullable)recvID
                  groupID:(NSString * _Nullable)groupID
          offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
                onSuccess:(nullable OIMMessageInfoCallback)onSuccess
               onProgress:(nullable OIMNumberCallback)onProgress
                onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 撤回一条消息
 *
 * @param conversationID 会话ID
 * @param clientMsgID    消息ID
 *
 */
- (void)revokeMessage:(NSString *)conversationID
          clientMsgID:(NSString *)clientMsgID
            onSuccess:(OIMSuccessCallback)onSuccess
            onFailure:(OIMFailureCallback)onFailure;

/*
 * 单聊正在输入消息
 *
 * @param recvID    接收者的ID
 * @param msgTip    自定义的提示信息
 */
- (void)typingStatusUpdate:(NSString *)recvID
                    msgTip:(NSString *)msgTip
                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 标记会话已读
 */
- (void)markConversationMessageAsRead:(NSString *)conversationID
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure;

/*
 * 标记消息已读
 *
 */
- (void)markMessageAsReadByMsgID:(NSString *)conversationID
                    clientMsgIDs:(NSArray <NSString *> *)clientMsgIDs
                       onSuccess:(nullable OIMSuccessCallback)onSuccess
                       onFailure:(nullable OIMFailureCallback)onFailure;

/**
 从本地删除一条消息
 */
- (void)deleteMessageFromLocalStorage:(NSString *)conversationID
                          clientMsgID:(NSString *)clientMsgID
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure;

/**
 删除一条消息  本地 & 服务器
 */
- (void)deleteMessage:(NSString *)conversationID
          clientMsgID:(NSString *)clientMsgID
            onSuccess:(nullable OIMSuccessCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure;

/**
 从本地删除所有消息
 */
- (void)deleteAllMsgFromLocalWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 删除所有消息  本地 & 服务器
 */
- (void)deleteAllMsgFromLocalAndSvrWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                       onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 插入一条单聊消息到本地
 *
 * @param recvID    接收用户ID
 * @param sendID    发送者ID
 */
- (void)insertSingleMessageToLocalStorage:(OIMMessageInfo *)message
                                   recvID:(NSString *)recvID
                                   sendID:(NSString *)sendID
                                onSuccess:(nullable OIMMessageInfoCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 插入一条群聊消息到本地
 *
 * @param groupID   群ID
 * @param sendID    发送者ID
 */
- (void)insertGroupMessageToLocalStorage:(OIMMessageInfo *)message
                                 groupID:(NSString * _Nullable)groupID
                                  sendID:(NSString * _Nullable)sendID
                               onSuccess:(nullable OIMMessageInfoCallback)onSuccess
                               onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 查找本地消息
 *
 */
- (void)searchLocalMessages:(OIMSearchParam *)param
                  onSuccess:(nullable OIMMessageSearchCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * 独立上传文件到初始化sdk的objectStorage（发送多媒体消息不需调用此函数，其在sdk内部自动上传）
 *
 */
- (void)uploadFile:(NSString *)fullPath
           name:(NSString * _Nullable)name
          cause:(NSString * _Nullable)cause
     onProgress:(OIMUploadProgressCallback)onProgress
   onCompletion:(OIMUploadCompletionCallback)onCompletion
      onSuccess:(OIMSuccessCallback)onSuccess
      onFailure:(OIMFailureCallback)onFailure;

/*
 * 全局设置消息提示
 *
 */
- (void)setGlobalRecvMessageOpt:(OIMReceiveMessageOpt)opt
                      onSuccess:(nullable OIMSuccessCallback)onSuccess
                      onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Advanced Message 系列使用
 @param opts lastMinSeq  是上一次拉取回调给的值，上下文，第二次拉取需要回传
 */
- (void)getAdvancedHistoryMessageList:(OIMGetAdvancedHistoryMessageListParam *)opts
                            onSuccess:(nullable OIMGetAdvancedHistoryMessageListCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Advanced Message 系列使用
 @param opts lastMinSeq  是上一次拉取回调给的值，上下文，第二次拉取需要回传
 */
- (void)getAdvancedHistoryMessageListReverse:(OIMGetAdvancedHistoryMessageListParam *)opts
                                   onSuccess:(nullable OIMGetAdvancedHistoryMessageListCallback)onSuccess
                                   onFailure:(nullable OIMFailureCallback)onFailure;

/**
 查找消息列表
 */
- (void)findMessageList:(NSArray<OIMFindMessageListParam *> *)param
              onSuccess:(nullable OIMMessageSearchCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 设置角标使用，告知服务器 客户端现有的数量
 */
- (void)setAppBadge:(NSInteger)count
          onSuccess:(nullable OIMSuccessCallback)onSuccess
          onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
