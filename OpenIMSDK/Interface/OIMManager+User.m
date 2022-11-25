//
//  OIMManager+User.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+User.h"
#import "CallbackProxy.h"

@implementation OIMManager (User)

- (void)getUsersInfo:(NSArray <NSString *> *)uids
           onSuccess:(OIMFullUsersInfoCallback)onSuccess
           onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFullUserInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetUsersInfo(callback, [self operationId], uids.mj_JSONString);
}

- (void)setSelfInfo:(OIMUserInfo *)userInfo
          onSuccess:(OIMSuccessCallback)onSuccess
          onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
        
    Open_im_sdkSetSelfInfo(callback, [self operationId], userInfo.mj_JSONString);
}

- (void)getSelfInfoWithOnSuccess:(OIMUserInfoCallback)onSuccess
                       onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMUserInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetSelfUserInfo(callback, [self operationId]);
}

- (void)updateFcmToken:(NSString *)fmcToken
             onSuccess:(OIMSuccessCallback)onSuccess
             onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
        
    Open_im_sdkUpdateFcmToken(callback, [self operationId], fmcToken);
}
@end
