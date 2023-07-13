//
//  OIMManager+Login.h
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Login)

#pragma mark -
#pragma mark - Login

/*
 * 登录
 *
 * @param uid   用户ID
 *              uid来自于自身业务服务器
 * @param token 用户token
 *              token需要业务服务器向OpenIM服务端交换获取。
 */
- (void)login:(NSString *)uid
        token:(NSString *)token
    onSuccess:(nullable OIMSuccessCallback)onSuccess
    onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * 获取登录状态
 *
 * Logout   = 1
 * Logging = 2
 * Logged  = 3
 */
- (NSInteger)getLoginStatus;

/*
 * 登出
 *
 */
- (void)logoutWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;

@end

NS_ASSUME_NONNULL_END
