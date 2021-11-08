//
//  SendMessageCallbackProxy.h
//  OpenIMUniPlugin
//
//  Created by Snow on 2021/6/24.
//

#import <Foundation/Foundation.h>
#import "OpenIMiOSSDK.h"
@import OpenIMCore;

NS_ASSUME_NONNULL_BEGIN

@interface SendMessageCallbackProxy : NSObject <Open_im_sdkSendMsgCallBack>

- (id)initWithMessage:(onSuccess)onSuccess onProgress:(void(^)(long progress))onProgress onError:(onError)onError;

@end

NS_ASSUME_NONNULL_END
