//
//  CallbackProxy.h
//  OpenIMUniPlugin
//
//  Created by Snow on 2021/6/24.
//

#import <Foundation/Foundation.h>
@import OpenIMCore;

NS_ASSUME_NONNULL_BEGIN

typedef void (^onError)(long ErrCode,NSString* _Nullable ErrMsg);
typedef void (^onSuccess)(NSString* _Nullable data);

@interface CallbackProxy : NSObject <Open_im_sdkBase>

- (id)initWithCallback:(onSuccess)onSuccess onError:(onError)onError;

@end

NS_ASSUME_NONNULL_END
