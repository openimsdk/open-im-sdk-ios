//
//  OIMManager+Login.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+Login.h"
#import "CallbackProxy.h"

@implementation OIMManager (Login)

- (void)login:(NSString *)userID
        token:(NSString *)token
    onSuccess:(OIMSuccessCallback)onSuccess
    onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
     
        self.token = token;
        
        if (onSuccess) {
            onSuccess(data);
        }
    } onFailure:onFailure];
    
    [[self class].callbacker setListener];
    
    Open_im_sdkLogin(callback, [self operationId], userID, token);
}

- (OIMLoginStatus)getLoginStatus {
    return Open_im_sdkGetLoginStatus([self operationId]);
}

- (void)logoutWithOnSuccess:(OIMSuccessCallback)onSuccess
                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkLogout(callback, [self operationId]);
}

@end
