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
           onSuccess:(OIMPublicUsersInfoCallback)onSuccess
           onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMPublicUserInfo mj_objectArrayWithKeyValuesArray:data]);
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
            expireTime:(NSInteger)expireTime
             onSuccess:(OIMSuccessCallback)onSuccess
             onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
        
    Open_im_sdkUpdateFcmToken(callback, [self operationId], fmcToken, expireTime);
}

- (void)subscribeUsersStatus:(NSArray<NSString *> *)userIDs
                   onSuccess:(nullable OIMUserStatusInfosCallback)onSuccess
                   onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMUserStatusInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
        
    Open_im_sdkSubscribeUsersStatus(callback, [self operationId], userIDs.mj_JSONString);
}

- (void)unsubscribeUsersStatus:(NSArray<NSString *> *)userIDs
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
        
    Open_im_sdkUnsubscribeUsersStatus(callback, [self operationId], userIDs.mj_JSONString);
}

- (void)getSubscribeUsersStatusWithOnSuccess:(nullable OIMUserStatusInfosCallback)onSuccess
                                   onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMUserStatusInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
        
    Open_im_sdkGetSubscribeUsersStatus(callback, [self operationId]);
}

- (void)getUserStatus:(NSArray<NSString *> *)userIDs
            onSuccess:(nullable OIMUserStatusInfosCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMUserStatusInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
        
    Open_im_sdkGetUserStatus(callback, [self operationId], userIDs.mj_JSONString);
}

- (void)getUsersInfoWithCache:(NSArray<NSString *> *)userIDs
                     groupID:(NSString *)groupID
                   onSuccess:(nullable OIMPublicUsersInfoCallback)onSuccess
                   onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMPublicUserInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetUsersInfo(callback, [self operationId], userIDs.mj_JSONString);
}

- (void)setGlobalRecvMessageOpt:(NSInteger )status
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                      onFailure:(nullable OIMFailureCallback)onFailure {
    OIMUserInfo *info = [OIMUserInfo new];
    info.globalRecvMsgOpt = status;
    
    [self setSelfInfo:info onSuccess:onSuccess onFailure:onFailure];
}
@end
