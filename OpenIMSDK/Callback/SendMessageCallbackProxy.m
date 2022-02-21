//
//  SendMessageCallbackProxy.m
//  OpenIMSDK
//
//  Created by Snow on 2021/6/24.
//

#import "SendMessageCallbackProxy.h"

@interface SendMessageCallbackProxy(){
    OIMSuccessCallback _onSuccess;
    OIMFailureCallback _onFailure;
    OIMNumberCallback _onProgress;
}


@end

@implementation SendMessageCallbackProxy

- (instancetype)initWithOnSuccess:(OIMSuccessCallback)onSuccess
                       onProgress:(OIMNumberCallback)onProgress
                        onFailure:(OIMFailureCallback)onFailure {
    if (self = [super init]) {
        _onSuccess = [onSuccess copy];
        _onFailure = [_onFailure copy];
        _onProgress = [onProgress copy];
    }
    return self;
}

- (void)onError:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    if (_onFailure) {
        _onFailure(errCode, errMsg);
    }
}

- (void)onProgress:(long)progress {
    if (_onProgress) {
        _onProgress(progress);
    }
}

- (void)onSuccess:(NSString * _Nullable)data {
    if (_onSuccess) {
        _onSuccess(data);
    }
}

@end
