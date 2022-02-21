//
//  OIMCallbacker+User.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCallbacker.h"


NS_ASSUME_NONNULL_BEGIN

/// 用户监听
///
@interface OIMCallbacker (User)

/*
 * 用户信息监听
 *
 */
- (void)setSelfUserInfoUpdateListener:(OIMUserInfoCallback)onUserInfoUpdate;

@end

NS_ASSUME_NONNULL_END
