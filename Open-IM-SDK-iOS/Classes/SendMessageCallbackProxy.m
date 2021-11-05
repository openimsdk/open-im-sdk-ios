//
//  SendMessageCallbackProxy.m
//  OpenIMUniPlugin
//
//  Created by Snow on 2021/6/24.
//

#import "SendMessageCallbackProxy.h"

@interface SendMessageCallbackProxy(){
    onSuccess _onSuccess;
    onError _onError;
    void(^_onProgress)(long progress);
}


@end

@implementation SendMessageCallbackProxy

- (id)initWithMessage:(onSuccess)onSuccess onProgress:(void(^)(long progress))onProgress onError:(onError)onError{
    if (self = [super init]) {
        _onSuccess = [onSuccess copy];
        _onError = [onError copy];
        _onProgress = [onProgress copy];
    }
    return self;
}

- (void)onError:(long)errCode errMsg:(NSString * _Nullable)errMsg {
    _onError(errCode,errMsg);
}

- (void)onSuccess:(NSString * _Nullable)data {
    _onSuccess(data);
}

- (void)onProgress:(long)progress {
    _onProgress(progress);
}

@end
