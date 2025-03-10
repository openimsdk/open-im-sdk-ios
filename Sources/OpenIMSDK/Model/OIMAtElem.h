//
//  OIMAtElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMQuoteElem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMAtInfo : NSObject

/**
 * ID of the member being mentioned
 */
@property (nonatomic, nullable, copy) NSString *atUserID;

/**
 * Nickname or group nickname of the mentioned member
 */
@property (nonatomic, nullable, copy) NSString *groupNickname;

@end

@interface OIMAtTextElem : NSObject

/**
 * Mentioned message content
 */
@property (nonatomic, nullable, copy) NSString *text;

/**
 * Set of user IDs being mentioned
 */
@property (nonatomic, nullable, copy) NSArray<NSString *> *atUserList;

/**
 * Set of mentioned users
 */
@property (nonatomic, nullable, copy) NSArray<OIMAtInfo *> *atUsersInfo;

/**
 * Quoted message with @ mention
 */
@property (nonatomic, nullable, strong) OIMMessageInfo *quoteMessage;

/**
 * Whether the sender is mentioned (@)
 */
@property (nonatomic, assign, readonly) BOOL isAtSelf;

/**
 * Whether @ all members
 */
@property (nonatomic, assign, readonly) BOOL isAtAll;

@end

NS_ASSUME_NONNULL_END
