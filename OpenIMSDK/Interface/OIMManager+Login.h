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

/**
 * Log in
 * 
 * @param userID   User ID
 *              The UID is obtained from your own business server.
 * @param token User token
 *              The token needs to be obtained by the business server from the OpenIM server.
 */
- (void)login:(NSString *)userID
        token:(NSString *)token
    onSuccess:(nullable OIMSuccessCallback)onSuccess
    onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get login status
 */
- (OIMLoginStatus)getLoginStatus;

/**
 * Log out
 */
- (void)logoutWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;

@end

NS_ASSUME_NONNULL_END
