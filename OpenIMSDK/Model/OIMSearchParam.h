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

/**
 * Conversation ID, if empty, it's a global search
 */
@property (nonatomic, copy) NSString *conversationID;

/**
 * Search keyword list, currently supports only one keyword search
 */
@property (nonatomic, strong) NSArray *keywordList;

/**
 * Keyword match mode, 1 means AND, 2 means OR (currently unused)
 */
@property (nonatomic, assign) NSInteger keywordListMatchType;

/**
 * Specify the list of sender user IDs (currently unused)
 */
@property (nonatomic, nullable, strong) NSArray *senderUserIDList;

/**
 * Message type list
 */
@property (nonatomic, nullable, strong) NSArray *messageTypeList;

/**
 * Search start time point. Default is 0, meaning search from now. UTC timestamp, unit: seconds
 */
@property (nonatomic, assign) NSInteger searchTimePosition;

/**
 * Time range from the start time point, in seconds. Default is 0, meaning no time limit. Provide 24x60x60 to represent the past day.
 */
@property (nonatomic, assign) NSInteger searchTimePeriod;

/**
 * Current page number, starting from the first page (1). It's invalid when conversationID is empty, i.e., in the global search context.
 */
@property (nonatomic, assign) NSInteger pageIndex;

/**
 * Number of items per page. It's invalid when conversationID is empty, i.e., in the global search context.
 */
@property (nonatomic, assign) NSInteger count;

@end

// For group search
@interface OIMSearchGroupParam : NSObject

/**
 * Search keywords, currently supports only one keyword (must not be empty)
 */
@property (nonatomic, copy) NSArray *keywordList;

/**
 * Whether to search for group IDs based on keywords (note: both cannot be false at the same time). Default is false.
 */
@property (nonatomic, assign) BOOL isSearchGroupID;

/**
 * Whether to search for group names based on keywords. Default is false.
 */
@property (nonatomic, assign) BOOL isSearchGroupName;

@end

/// For friends search
///
@interface OIMSearchFriendsParam : NSObject

/**
 *  Search keywords, currently supports only one keyword (must not be empty)
 */
@property (nonatomic, copy) NSArray *keywordList;

/**
 *  Whether to search for user IDs based on keywords
 */
@property (nonatomic, assign) BOOL isSearchUserID;

/**
 *  Whether to search for nicknames based on keywords. Default is false.
 */
@property (nonatomic, assign) BOOL isSearchNickname;

/**
 *  Whether to search for remarks based on keywords. Default is false.
 */
@property (nonatomic, assign) BOOL isSearchRemark;
@end

/// For chat history search
///
@interface OIMGetMessageOptions : NSObject

@property (nonatomic, copy, nullable) NSString *userID;
@property (nonatomic, copy, nullable) NSString *groupID;
/**
 *  Conversation ID; if not empty, retrieve messages by conversation ID, otherwise use userID and groupID
 */
@property (nonatomic, copy, nullable) NSString *conversationID;
/**
 *  Start message clientMsgID
 */
@property (nonatomic, copy, nullable) NSString *startClientMsgID;
@property (nonatomic, assign) NSInteger count;
@end

@interface OIMGetAdvancedHistoryMessageListParam : OIMGetMessageOptions

@property (nonatomic, assign) NSInteger lastMinSeq;

@end

@interface OIMFindMessageListParam : NSObject

@property (nonatomic, copy) NSString *conversationID;

@property (nonatomic, copy) NSArray <NSString *> *clientMsgIDList;

@end

/// For group members search
///
@interface OIMSearchGroupMembersParam : NSObject

@property (nonatomic, copy) NSString *groupID;

@property (nonatomic, copy) NSArray *keywordList;
/**
 *  Whether to search user IDs based on keywords
 */
@property (nonatomic, assign) BOOL isSearchUserID;
/**
 *  Whether to search member nicknames based on keywords. Default is false.
 */
@property (nonatomic, assign) BOOL isSearchMemberNickname;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, assign) NSInteger count;
@end

NS_ASSUME_NONNULL_END
