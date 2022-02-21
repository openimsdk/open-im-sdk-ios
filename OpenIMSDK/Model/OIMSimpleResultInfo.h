//
//  OIMSimpleResultInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMSimpleResultInfo : NSObject

@property (nonatomic, nullable, copy) NSString *userID;

/*
 * checkFriend: result为1表示好友（并且不是黑名单）
 */
@property (nonatomic, assign) NSInteger result;

@end

NS_ASSUME_NONNULL_END
