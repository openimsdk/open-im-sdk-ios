//
//  CallbackProxy.m
//  OpenIMSDK
//
//  Created by Snow on 2021/6/24.
//

#import "CallbackProxy.h"

@interface CallbackProxy() {
    OIMSuccessCallback _onSuccess;
    OIMFailureCallback _onError;
}

@end

@implementation CallbackProxy

- (instancetype)initWithOnSuccess:(OIMSuccessCallback)onSuccess
                        onFailure:(OIMFailureCallback)onFailure {
    if (self = [super init]) {
        _onSuccess = [onSuccess copy];
        _onError = [onFailure copy];
    }
    return self;
}

- (void)onError:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    if (_onError) {
        _onError(errCode, errMsg);
    }
}

- (void)onSuccess:(NSString * _Nullable)data {
    if (_onSuccess) {
        _onSuccess(data);
    }
}

@end
