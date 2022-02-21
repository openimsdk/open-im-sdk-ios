//
//  OIMSearchParam.h
//  OpenIMSDK
//
//  Created by x on 2022/2/17.
//

#import <Foundation/Foundation.h>

#import "OIMModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMSearchParam : NSObject

/*
 * 源ID,单聊为用户ID，群聊为群ID
 */
@property(nonatomic, copy) NSString *sourceID;

/*
 * 会话类型，单聊为1，群聊为2，如果为0，则代表搜索全部
 */
@property(nonatomic, assign) OIMConversationType sessionType;

/*
 * 搜索关键词列表，目前仅支持一个关键词搜索
 */
@property(nonatomic, strong) NSArray *keywordList;

/*
 * 关键词匹配模式，1代表与，2代表或，暂时未用
 */
@property(nonatomic, assign) NSInteger keywordListMatchType;

/*
 * 指定消息发送的uid列表，暂时未用
 */
@property(nonatomic, nullable, strong) NSArray *senderUserIDList;

/*
 * 消息类型列表，暂时未用
 */
@property(nonatomic, nullable, strong) NSArray *messageTypeList;

/*
 * 搜索的起始时间点。默认为0即代表从现在开始搜索。UTC 时间戳，单位：秒
 */
@property(nonatomic, assign) NSInteger searchTimePosition;

/*
 * 从起始时间点开始的过去时间范围，单位秒。默认为0即代表不限制时间范围，传24x60x60代表过去一天
 */
@property(nonatomic, assign) NSInteger searchTimePeriod;

/*
 * 分页使用的偏移，暂时未用
 */
@property(nonatomic, assign) NSInteger pageIndex;

/*
 * 每页数量，暂时未用
 */
@property(nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
