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
/**
 * For checkFriend: a result of 1 indicates a friend (and not in the blacklist).
 */
@property (nonatomic, assign) NSInteger result;

@end

NS_ASSUME_NONNULL_END
