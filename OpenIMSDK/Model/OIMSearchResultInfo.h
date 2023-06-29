//
//  OIMSearchResultInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/17.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

@class OIMMessageInfo;

NS_ASSUME_NONNULL_BEGIN

@interface OIMSearchResultItemInfo : NSObject

/*
 * 会话ID
 */
@property (nonatomic, copy) NSString *conversationID;

/*
 * 这个会话下的消息数量
 */
@property (nonatomic, assign) NSInteger messageCount;

@property (nonatomic, assign) OIMConversationType conversationType;

@property (nonatomic, copy) NSString *showName;

@property (nonatomic, copy) NSString *faceURL;

/*
 * OIMMessageInfo的列表
 */
@property (nonatomic, copy) NSArray <OIMMessageInfo *> *messageList;

@end

@interface OIMSearchResultInfo : NSObject

/*
 * 获取到的总的消息数量
 */
@property (nonatomic, assign) NSInteger totalCount;

/*
 * 搜索结果
 */
@property (nonatomic, copy) NSArray <OIMSearchResultItemInfo *> *searchResultItems;

// 仅适用于findMessageList函数的回调结果
@property (nonatomic, copy) NSArray <OIMSearchResultItemInfo *> *findResultItems;

@end

@interface OIMGetAdvancedHistoryMessageListInfo : NSObject

@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, assign) NSInteger lastMinSeq;

@property (nonatomic, assign) NSInteger errCode;

@property (nonatomic, copy) NSString *errMsg;

@property (nonatomic, copy) NSArray <OIMMessageInfo *> *messageList;

@end

NS_ASSUME_NONNULL_END
