//
//  CallbackProxy.h
//  OpenIMSDK
//
//  Created by Snow on 2021/6/24.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

@import OpenIMCore;

NS_ASSUME_NONNULL_BEGIN

@interface CallbackProxy : NSObject <Open_im_sdk_callbackBase>

- (instancetype)initWithOnSuccess:(OIMSuccessCallback)onSuccess
                        onFailure:(OIMFailureCallback)onFailure;

- (void)dispatchMainThread:(void (NS_NOESCAPE ^)(void))todo;
@end

NS_ASSUME_NONNULL_END
