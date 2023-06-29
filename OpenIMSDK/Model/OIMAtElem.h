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

/*
 * at 成员的id
 */
@property (nonatomic, nullable, copy) NSString *atUserID;

/*
 * at 成员的昵称/群名片
 */
@property (nonatomic, nullable, copy) NSString *groupNickname;

@end

@interface OIMAtTextElem : NSObject

/*
 * at 消息内容
 */
@property (nonatomic, nullable, copy) NSString *text;

/*
 * 被@的用户id集合
 */
@property (nonatomic, nullable, copy) NSArray<NSString *> *atUserList;

/*
 * 被@的用户集合
 */
@property (nonatomic, nullable, copy) NSArray<OIMAtInfo *> *atUsersInfo;

/*
 * at 引用消息
 */
@property (nonatomic, nullable, strong) OIMMessageInfo *quoteMessage;

/*
 * 自己是否被@了
 */
@property (nonatomic, assign, readonly) BOOL isAtSelf;


/*
 * 是否@全体成员
 */
@property (nonatomic, assign, readonly) BOOL isAtAll;

@end

NS_ASSUME_NONNULL_END
