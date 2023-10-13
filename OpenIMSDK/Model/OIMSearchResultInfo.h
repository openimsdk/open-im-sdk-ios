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
/**
 * Conversation ID
 */
@property (nonatomic, copy) NSString *conversationID;
/**
 * Number of messages in this conversation
 */
@property (nonatomic, assign) NSInteger messageCount;

@property (nonatomic, assign) OIMConversationType conversationType;

@property (nonatomic, copy) NSString *showName;

@property (nonatomic, copy) NSString *faceURL;
/**
 * List of OIMMessageInfo
 */
@property (nonatomic, copy) NSArray <OIMMessageInfo *> *messageList;

@end

@interface OIMSearchResultInfo : NSObject
/**
 * Total number of messages obtained
 */
@property (nonatomic, assign) NSInteger totalCount;
/**
 * Search results
 */
@property (nonatomic, copy) NSArray <OIMSearchResultItemInfo *> *searchResultItems;
/**
 *  Only applicable to the callback result of the findMessageList function
 */
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
