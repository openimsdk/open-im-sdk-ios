//
//  SendMessageCallbackProxy.h
//  OpenIMSDK
//
//  Created by Snow on 2021/6/24.
//

#import <Foundation/Foundation.h>
#import "CallbackProxy.h"

@import OpenIMCore;

NS_ASSUME_NONNULL_BEGIN

@interface SendMessageCallbackProxy : CallbackProxy <Open_im_sdk_callbackSendMsgCallBack>

- (instancetype)initWithOnSuccess:(OIMSuccessCallback)onSuccess
                       onProgress:(OIMNumberCallback)onProgress
                        onFailure:(OIMFailureCallback)onFailure;

@end

NS_ASSUME_NONNULL_END
