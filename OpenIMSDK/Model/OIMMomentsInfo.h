//
//  OIMMomentsInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMMomentsInfo : NSObject

//0为普通评论 1为被喜欢 2为AT提醒看的朋友圈
@property (nonatomic, assign) NSInteger notificationMsgType;
@property (nonatomic, copy) NSString *replyUserName;
@property (nonatomic, copy) NSString *replyUserID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contentID;
@property (nonatomic, copy) NSString *workMomentID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *faceURL;
// 发送朋友圈的json内容
@property (nonatomic, copy) NSString *workMomentContent;
@property (nonatomic, assign) NSTimeInterval createTime;
@end

NS_ASSUME_NONNULL_END
