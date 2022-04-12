//
//  OIMMessageInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMOfflinePushInfo.h"
#import "OIMPictureElem.h"
#import "OIMSoundElem.h"
#import "OIMVideoElem.h"
#import "OIMFileElem.h"
#import "OIMMergeElem.h"
#import "OIMAtElem.h"
#import "OIMLocationElem.h"
#import "OIMCustomElem.h"
#import "OIMQuoteElem.h"
#import "OIMNotificationElem.h"
#import "OIMFaceElem.h"
#import "OIMAttachedInfoElem.h"
#import "OIMModelDefine.h"


NS_ASSUME_NONNULL_BEGIN

/// 消息模型
///
@interface OIMMessageInfo : NSObject

@property (nonatomic, nullable, copy) NSString *clientMsgID;

@property (nonatomic, nullable, copy) NSString *serverMsgID;

@property (nonatomic, assign) NSTimeInterval createTime;

@property (nonatomic, assign) NSTimeInterval sendTime;

@property (nonatomic, assign) OIMConversationType sessionType;

@property (nonatomic, nullable, copy) NSString *sendID;

@property (nonatomic, nullable, copy) NSString *recvID;

@property (nonatomic, nullable, copy) NSString *handleMsg;

@property (nonatomic, assign) OIMMessageLevel msgFrom;

@property (nonatomic, assign) OIMMessageContentType contentType;

@property (nonatomic, assign) NSInteger platformID;

@property (nonatomic, nullable, copy) NSString *senderNickname;

@property (nonatomic, nullable, copy) NSString *senderFaceUrl;

@property (nonatomic, nullable, copy) NSString *groupID;

@property (nonatomic, nullable, copy) NSString *content;

/*
 *  消息唯一序列号
 */
@property (nonatomic, assign) NSInteger seq;

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, assign) OIMMessageStatus status;

@property (nonatomic, nullable, copy) NSString *attachedInfo;

@property (nonatomic, nullable, copy) NSString *ex;

@property (nonatomic, strong) OIMOfflinePushInfo *offlinePushInfo;

@property (nonatomic, nullable, strong) OIMPictureElem *pictureElem;

@property (nonatomic, nullable, strong) OIMSoundElem *soundElem;

@property (nonatomic, nullable, strong) OIMVideoElem *videoElem;

@property (nonatomic, nullable, strong) OIMFileElem *fileElem;

@property (nonatomic, nullable, strong) OIMMergeElem *mergeElem;

@property (nonatomic, nullable, strong) OIMAtElem *atElem;

@property (nonatomic, nullable, strong) OIMLocationElem *locationElem;

@property (nonatomic, nullable, strong) OIMQuoteElem *quoteElem;

@property (nonatomic, nullable, strong) OIMCustomElem *customElem;

@property (nonatomic, nullable, strong) OIMNotificationElem *notificationElem;

@property (nonatomic, nullable, strong) OIMFaceElem *faceElem;

@property (nonatomic, nullable, strong) OIMAttachedInfoElem *attachedInfoElem;

@property (nonatomic, assign) NSTimeInterval hasReadTime;

@end



NS_ASSUME_NONNULL_END
