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
 *  Whether the message is sent by self.
 */
- (BOOL)isSelf;

/*
 * Create a text message.
 *
 * @param text Content
 */
+ (OIMMessageInfo *)createTextMessage:(NSString *)text;

/**
 * Complement the use of createTextAtMessage, insert the "@all" flag at a specified position.
 */
+ (OIMAtInfo *)createAtAllFlag:(NSString *)displayText;

+ (NSString *)getAtAllTag;

/*
 * Create an @ text message.
 *
 * @param text       Content
 * @param atUsersID  User IDs to mention
 * @param atUsersInfo User information in the group
 * @param message    Message to reference
 */
+ (OIMMessageInfo *)createTextAtMessage:(NSString *)text
                              atUsersID:(NSArray<NSString *> *)atUsersID
                            atUsersInfo:(NSArray<OIMAtInfo *> *)atUsersInfo
                                message:(OIMMessageInfo * _Nullable)message;

/*
 * Create an @ all members text message.
 *
 * @param text        Content
 * @param displayText Display text, e.g., "@All members"
 * @param message     Message to reference
 */
+ (OIMMessageInfo *)createTextAtAllMessage:(NSString *)text
                               displayText:(NSString * _Nullable)displayText
                                   message:(OIMMessageInfo * _Nullable)message;

/*
 * Create an image message. (If you provided a data cache path during initSDK, you need to copy the image to that path. For example, if the path is "A", you should copy the image to "A/pic/a.png", and the imagePath should be "/pic/a.png").
 *
 * @param imagePath Relative path
 */
+ (OIMMessageInfo *)createImageMessage:(NSString *)imagePath;

/*
 * Create an image message.
 *
 * @param imagePath Absolute path
 */
+ (OIMMessageInfo *)createImageMessageFromFullPath:(NSString *)imagePath;

/*
 * Create an audio message. For example: upload your own audio file and then use the returned URL to send the message.
 *
 */
+ (OIMMessageInfo *)createImageMessageByURL:(NSString *)sourcePath
                              sourcePicture:(OIMPictureInfo *)source
                                 bigPicture:(OIMPictureInfo *)big
                            snapshotPicture:(OIMPictureInfo *)snapshot;

/*
 * Create a sound message. (If you provided a data cache path during initSDK, you need to copy the sound file to that path. For example, if the path is "A", you should copy the sound file to "A/voice/a.m4c", and the soundPath should be "/voice/a.m4c").
 *
 * @param soundPath Relative path
 * @param duration  Duration
 */
+ (OIMMessageInfo *)createSoundMessage:(NSString *)soundPath
                              duration:(NSInteger)duration;

/*
 * Create a sound message.
 *
 * @param soundPath Absolute path
 * @param duration  Duration
 */
+ (OIMMessageInfo *)createSoundMessageFromFullPath:(NSString *)soundPath
                                          duration:(NSInteger)duration;

/*
 * Create an audio message. For example: upload your own audio file and then use the returned URL to send the message.
 *
 */
+ (OIMMessageInfo *)createSoundMessageByURL:(NSString *)fileURL
                                   duration:(NSInteger)duration
                                       size:(NSInteger)size;

/*
 * Create a video message. (If you provided a data cache path during initSDK, you need to copy the video file to that path. For example, if the path is "A", you should copy the video file to "A/video/a.mp4", and the videoPath should be "/video/a.mp4").
 *
 * @param videoPath    Relative video path
 * @param videoType    MIME type
 * @param duration     Duration
 * @param snapshotPath Relative path of the snapshot
 */
+ (OIMMessageInfo *)createVideoMessage:(NSString *)videoPath
                             videoType:(NSString *)videoType
                              duration:(NSInteger)duration
                          snapshotPath:(NSString *)snapshotPath;

/*
 * Create a video message.
 *
 * @param videoPath    Absolute video path
 * @param videoType    MIME type
 * @param duration     Duration
 * @param snapshotPath Absolute snapshot path
 */
+ (OIMMessageInfo *)createVideoMessageFromFullPath:(NSString *)videoPath
                                         videoType:(NSString *)videoType
                                          duration:(NSInteger)duration
                                      snapshotPath:(NSString *)snapshotPath;

/*
 * Create a video message. For example: upload your own video file and then use the returned URL to send the message.
 *
 */
+ (OIMMessageInfo *)createVideoMessageByURL:(NSString *)fileURL
                                  videoType:(NSString * _Nullable)videoType
                                   duration:(NSInteger)duration
                                      size:(NSInteger)size
                                   snapshot:(NSString * _Nullable)snapshotURL;

/*
 * Create a file message. (If you provided a data cache path during initSDK, you need to copy the file to that path. For example, if the path is "A", you should copy the file to "A/file/a.txt", and the filePath should be "/file/a.txt").
 *
 * @param filePath Relative path
 * @param fileName File name
 */
+ (OIMMessageInfo *)createFileMessage:(NSString *)filePath
                             fileName:(NSString *)fileName;

/*
 * Create a file message.
 * (If you provided a data cache path during initSDK, you need to copy the file to that path. For example, if the path is "A", you should copy the file to "A/file/a.txt", and the filePath should be "/file/a.txt").
 *
 * @param filePath Absolute path
 * @param fileName File name
 *
 */
 + (OIMMessageInfo *)createFileMessageFromFullPath:(NSString *)filePath
                                          fileName:(NSString *)fileName;

 /*
  * Create a file message. For example: upload your own file and then use the returned URL to send the message.
  *
  */
 + (OIMMessageInfo *)createFileMessageByURL:(NSString *)fileURL
                                   fileName:(NSString * _Nullable)fileName
                                       size:(NSInteger)size;

 /*
  * Create a merged message.
  *
  * @param title       Title
  * @param summaryList Summaries
  * @param messageList Message list
  */
 + (OIMMessageInfo *)createMergeMessage:(NSArray <OIMMessageInfo *> *)messages
                                  title:(NSString *)title
                            summaryList:(NSArray <NSString *> *)summaries;

 /*
  * Create a forwarded message.
  *
  */
 + (OIMMessageInfo *)createForwardMessage:(OIMMessageInfo *)message;

 /*
  * Create a location message.
  *
  * @param description Description message
  * @param latitude    Latitude
  * @param longitude   Longitude
  */
 + (OIMMessageInfo *)createLocationMessage:(NSString *)description
                                  latitude:(double)latitude
                                 longitude:(double)longitude;

 /*
  * Create a quoted message.
  *
  * @param text    Content
  * @param message Message being quoted
  *
  */
 + (OIMMessageInfo *)createQuoteMessage:(NSString *)text
                                message:(OIMMessageInfo *)message;

 /*
  * Create a business card message.
  *
  * @param content String
  */
 + (OIMMessageInfo *)createCardMessage:(OIMCardElem *)card;

 /*
  * Create a custom message.
  *
  * @param data        JSON String
  * @param extension   JSON String
  * @param description Description
  */
 + (OIMMessageInfo *)createCustomMessage:(NSString *)data
                               extension:(NSString * _Nullable)extension
                             description:(NSString * _Nullable)description;

 /*
  * Create an animated sticker message.
  *
  */
 + (OIMMessageInfo *)createFaceMessageWithIndex:(NSInteger)index
                                           data:(NSString *)dataStr;

 /*
  * Create an advanced message.
  *
  */
 + (OIMMessageInfo *)createAdvancedTextMessage:(NSString *)text
                             messageEntityList:(NSArray <OIMMessageEntity *> *)messageEntityList;

 /*
  * Create an advanced quoted message.
  *
  */
 + (OIMMessageInfo *)createAdvancedQuoteMessage:(NSString *)text
                                        message:(OIMMessageInfo *)message
                              messageEntityList:(NSArray <OIMMessageEntity *> *)messageEntityList;

@end

@interface OIMManager (Message)

/**
 * Send a message
 *
 * @param message       The message body created with Create...Message methods (OIMMessageInfo)
 * @param recvID        User ID for one-on-one chat, or an empty string for group chat
 * @param groupID       Group ID for group chat, or an empty string for one-on-one chat
 * @param offlinePushInfo Offline push information for the message (OIMOfflinePushInfo)
 * @param isOnlineOnly  Whether to send only online messages.
 */
- (void)sendMessage:(OIMMessageInfo *)message
             recvID:(NSString * _Nullable)recvID
            groupID:(NSString * _Nullable)groupID
       isOnlineOnly:(BOOL)isOnlineOnly
    offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
          onSuccess:(nullable OIMMessageInfoCallback)onSuccess
         onProgress:(nullable OIMNumberCallback)onProgress
          onFailure:(nullable OIMFailureCallback)onFailure;

- (void)sendMessage:(OIMMessageInfo *)message
             recvID:(NSString * _Nullable)recvID
            groupID:(NSString * _Nullable)groupID
    offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
          onSuccess:(nullable OIMMessageInfoCallback)onSuccess
         onProgress:(nullable OIMNumberCallback)onProgress
          onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Send a message without uploading multimedia files through the built-in SDK Object Storage Service (OSS)
 *
 * @param message       The message body created with Create...Message methods (OIMMessageInfo)
 * @param recvID        User ID for one-on-one chat, or an empty string for group chat
 * @param groupID       Group ID for group chat, or an empty string for one-on-one chat
 * @param offlinePushInfo Offline push information for the message (OIMOfflinePushInfo)
 * @param isOnlineOnly  Whether to send only online messages.
 */

- (void)sendMessageNotOss:(OIMMessageInfo *)message
                   recvID:(NSString * _Nullable)recvID
                  groupID:(NSString * _Nullable)groupID
             isOnlineOnly:(BOOL)isOnlineOnly
          offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
                onSuccess:(nullable OIMMessageInfoCallback)onSuccess
               onProgress:(nullable OIMNumberCallback)onProgress
                onFailure:(nullable OIMFailureCallback)onFailure;

- (void)sendMessageNotOss:(OIMMessageInfo *)message
                   recvID:(NSString * _Nullable)recvID
                  groupID:(NSString * _Nullable)groupID
          offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
                onSuccess:(nullable OIMMessageInfoCallback)onSuccess
               onProgress:(nullable OIMNumberCallback)onProgress
                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Revoke a message
 *
 * @param conversationID Conversation ID
 * @param clientMsgID    Message ID
 */
- (void)revokeMessage:(NSString *)conversationID
          clientMsgID:(NSString *)clientMsgID
            onSuccess:(OIMSuccessCallback)onSuccess
            onFailure:(OIMFailureCallback)onFailure;

/**
 * Typing status for one-on-one chat
 *
 * @param recvID    Receiver's ID
 * @param msgTip    Customized tip message
 */
- (void)typingStatusUpdate:(NSString *)recvID
                    msgTip:(NSString *)msgTip
                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Mark messages as read
 *
 * @param conversationID    Conversation's ID
 * @param clientMsgIDs      ClientMsg's IDs
 */
- (void)markMessageAsReadByConID:(NSString *)conversationID
                    clientMsgIDs:(NSArray <NSString *> *)clientMsgIDs
                       onSuccess:(nullable OIMSuccessCallback)onSuccess
                       onFailure:(nullable OIMFailureCallback)onFailure __attribute__((deprecated("This method is deprecated. Use markConversationMessageAsRead instead.")));

/**
 * Delete a message from local storage
 *
 * @param conversationID    Conversation's ID
 * @param clientMsgID      ClientMsg's ID
 */
- (void)deleteMessageFromLocalStorage:(NSString *)conversationID
                          clientMsgID:(NSString *)clientMsgID
                            onSuccess:(OIMSuccessCallback)onSuccess
                            onFailure:(OIMFailureCallback)onFailure;

/**
 * Delete a message from local and server
 *
 * @param conversationID    Conversation's ID
 * @param clientMsgID      ClientMsg's ID
 */
- (void)deleteMessage:(NSString *)conversationID
          clientMsgID:(NSString *)clientMsgID
            onSuccess:(nullable OIMSuccessCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Delete all messages from local storage
 */
- (void)deleteAllMsgFromLocalWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Delete all messages from local and server
 */
- (void)deleteAllMsgFromLocalAndSvrWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                       onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Insert a one-on-one chat message into local storage
 *
 * @param recvID    Receiver's user ID
 * @param sendID    Sender's user ID
 */
- (void)insertSingleMessageToLocalStorage:(OIMMessageInfo *)message
                                   recvID:(NSString *)recvID
                                   sendID:(NSString *)sendID
                                onSuccess:(nullable OIMMessageInfoCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Insert a group chat message into local storage
 *
 * @param groupID   Group ID
 * @param sendID    Sender's user ID
 */
- (void)insertGroupMessageToLocalStorage:(OIMMessageInfo *)message
                                 groupID:(NSString * _Nullable)groupID
                                  sendID:(NSString * _Nullable)sendID
                               onSuccess:(nullable OIMMessageInfoCallback)onSuccess
                               onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Search for local messages
 *
 * @param param     search param
 */
- (void)searchLocalMessages:(OIMSearchParam *)param
                  onSuccess:(nullable OIMMessageSearchCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Independently upload a file to the initialized SDK's Object Storage Service (OSS) (Not needed for sending multimedia messages, as it is automatically done by the SDK internally)
 *
 * @param fullPath  Absolute file path.
 * @param name  file's name
 * @param cause  file's catogery
 */
- (void)uploadFile:(NSString *)fullPath
           name:(NSString * _Nullable)name
          cause:(NSString * _Nullable)cause
     onProgress:(OIMUploadProgressCallback)onProgress
   onCompletion:(OIMUploadCompletionCallback)onCompletion
      onSuccess:(OIMSuccessCallback)onSuccess
      onFailure:(OIMFailureCallback)onFailure;

/**
 * Set global message notification options
 *
 * @param opt   receiving method.
 */
- (void)setGlobalRecvMessageOpt:(OIMReceiveMessageOpt)opt
                      onSuccess:(nullable OIMSuccessCallback)onSuccess
                      onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Advanced Message Series Usage
 *
 * @param opts lastMinSeq  is the value passed in the last pull callback, context, to be passed back in the second pull
 */
- (void)getAdvancedHistoryMessageList:(OIMGetAdvancedHistoryMessageListParam *)opts
                            onSuccess:(nullable OIMGetAdvancedHistoryMessageListCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Advanced Message Series Usage
 *
 * @param opts lastMinSeq  is the value passed in the last pull callback, context, to be passed back in the second pull
 */
- (void)getAdvancedHistoryMessageListReverse:(OIMGetAdvancedHistoryMessageListParam *)opts
                                   onSuccess:(nullable OIMGetAdvancedHistoryMessageListCallback)onSuccess
                                   onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Find a list of messages
 *
 * @param param   Find parameters.
 */
- (void)findMessageList:(NSArray<OIMFindMessageListParam *> *)param
              onSuccess:(nullable OIMMessageSearchCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set the application badge count and inform the server of the current count
 *
 * @param count Number of corners.
 */
- (void)setAppBadge:(NSInteger)count
          onSuccess:(nullable OIMSuccessCallback)onSuccess
          onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * For example, store the local state of a message
 * 
 * @param conversationID    Conversation's ID
 * @param clientMsgID      ClientMsg's ID
 * @param localEx      ex
 */
- (void)setMessageLocalEx:(NSString *)conversationID
              clientMsgID:(NSString *)clientMsgID
                  localEx: (NSString *)localEx
                onSuccess:(OIMSuccessCallback)onSuccess
                onFailure:(OIMFailureCallback)onFailure;

@end

NS_ASSUME_NONNULL_END
