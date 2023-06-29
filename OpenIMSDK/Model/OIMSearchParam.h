//
//  OIMSearchParam.h
//  OpenIMSDK
//
//  Created by x on 2022/2/17.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

@class OIMMessageInfo;

NS_ASSUME_NONNULL_BEGIN

@interface OIMSearchParam : NSObject

/*
 * 会话ID，如果为空，则为全局搜素
 */
@property (nonatomic, copy) NSString *conversationID;

/*
 * 搜索关键词列表，目前仅支持一个关键词搜索
 */
@property (nonatomic, strong) NSArray *keywordList;

/*
 * 关键词匹配模式，1代表与，2代表或，暂时未用
 */
@property (nonatomic, assign) NSInteger keywordListMatchType;

/*
 * 指定消息发送的uid列表，暂时未用
 */
@property (nonatomic, nullable, strong) NSArray *senderUserIDList;

/*
 * 消息类型列表
 */
@property (nonatomic, nullable, strong) NSArray *messageTypeList;

/*
 * 搜索的起始时间点。默认为0即代表从现在开始搜索。UTC 时间戳，单位：秒
 */
@property (nonatomic, assign) NSInteger searchTimePosition;

/*
 * 从起始时间点开始的过去时间范围，单位秒。默认为0即代表不限制时间范围，传24x60x60代表过去一天
 */
@property (nonatomic, assign) NSInteger searchTimePeriod;

/*
 * 当前页数，起始第一页为 1,conversationID为空时候，即全局搜素情況下，无效
 */
@property (nonatomic, assign) NSInteger pageIndex;

/*
 * 每页数量，conversationID为空时候，即全局搜素情况下，无效
 */
@property (nonatomic, assign) NSInteger count;

@end



// 查询群使用
@interface OIMSearchGroupParam : NSObject

// 搜索关键词，目前仅支持一个关键词搜索，不能为空
@property (nonatomic, copy) NSArray *keywordList;

// 是否以关键词搜索群ID(注：两个不可以同时为false)，默认false
@property (nonatomic, assign) BOOL isSearchGroupID;

// 是否以关键词搜索群名字，默认false
@property (nonatomic, assign) BOOL isSearchGroupName;

@end

// 查询好友使用
@interface OIMSearchFriendsParam : NSObject

// 搜索关键词，目前仅支持一个关键词搜索，不能为空
@property (nonatomic, copy) NSArray *keywordList;

// 是否以关键词搜索UserID
@property (nonatomic, assign) BOOL isSearchUserID;

// 是否以关键词搜索昵称，默认false
@property (nonatomic, assign) BOOL isSearchNickname;

// 是否以关键词搜索备注，默认false
@property (nonatomic, assign) BOOL isSearchRemark;
@end


// 查询聊天记录使用
@interface OIMGetMessageOptions : NSObject

@property (nonatomic, copy, nullable) NSString *userID;
@property (nonatomic, copy, nullable) NSString *groupID;
@property (nonatomic, copy, nullable) NSString *conversationID; //会话ID，如果不为空则以会话ID获取，否则通过userID和groupID获取
@property (nonatomic, copy, nullable) NSString *startClientMsgID; // 起始的消息clientMsgID
@property (nonatomic, assign) NSInteger count;

@end

@interface OIMGetAdvancedHistoryMessageListParam : OIMGetMessageOptions

@property (nonatomic, assign) NSInteger lastMinSeq;

@end


@interface OIMFindMessageListParam : NSObject

@property (nonatomic, copy) NSString *conversationID;

@property (nonatomic, copy) NSArray <NSString *> *clientMsgIDList;

@end

// 查询组织架构使用
@interface OIMSearchOrganizationParam : NSObject

// 搜索关键词，目前仅支持一个关键词搜索，不能为空
@property (nonatomic, copy) NSString *keyword;

// 是否以关键词搜索UserID
@property (nonatomic, assign) BOOL isSearchUserID;

// 是否以关键词搜索昵称，默认false
@property (nonatomic, assign) BOOL isSearchUserName;

// 是否以英文搜索备注，默认false
@property (nonatomic, assign) BOOL isSearchEnglishName;

// 是否以职位搜索备注，默认false
@property (nonatomic, assign) BOOL isSearchPosition;

// 是否以移动号码搜索备注，默认false
@property (nonatomic, assign) BOOL isSearchMobile;

// 是否以邮箱搜索备注，默认false
@property (nonatomic, assign) BOOL isSearchEmail;

// 是否以电话号码搜索备注，默认false
@property (nonatomic, assign) BOOL isSearchTelephone;
@end

// 查询群成员使用
@interface OIMSearchGroupMembersParam : NSObject

@property (nonatomic, copy) NSString *groupID;

@property (nonatomic, copy) NSArray *keywordList;

// 是否以关键词搜索UserID
@property (nonatomic, assign) BOOL isSearchUserID;

// 是否以关键词搜索昵称，默认false
@property (nonatomic, assign) BOOL isSearchMemberNickname;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, assign) NSInteger count;
@end

NS_ASSUME_NONNULL_END
