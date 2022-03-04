//
//  OIMSearchResultInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/17.
//

#import <Foundation/Foundation.h>

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
@property (nonatomic, strong) NSArray <OIMSearchResultItemInfo *> *searchResultItems;

@end

NS_ASSUME_NONNULL_END
