//
//  CallbackProxy.m
//  OpenIMUniPlugin
//
//  Created by Snow on 2021/6/24.
//

#import "CallbackProxy.h"
@import OpenIMCore;

@interface CallbackProxy(){
    onSuccess _onSuccess;
    onError _onError;
}

@end

@implementation CallbackProxy

- (id)initWithCallback:(onSuccess)onSuccess onError:(onError)onError{
    if (self = [super init]) {
        _onSuccess = [onSuccess copy];
        _onError = [onError copy];
    }
    return self;
}

- (void)onError:(long)eCode errMsg:(NSString * _Nullable)errMsg {
    if (errMsg == nil) {
        errMsg = @"";
    }
    _onError(eCode,errMsg);
}

- (void)onSuccess:(NSString * _Nullable)data {
    if (data == nil) {
        data = @"";
    }
    _onSuccess(data);
}

@end
