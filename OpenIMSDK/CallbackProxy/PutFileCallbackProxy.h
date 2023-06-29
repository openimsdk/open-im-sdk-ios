//
//  PutFileCallbackProxy.h
//  OpenIMSDK
//
//  Created by x on 2023/6/19.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

@import OpenIMCore;

typedef void (^OIMPutStartCallback)(NSInteger currentBytes, NSInteger totalBytes);
typedef void (^OIMProgressCallback)(NSInteger saveBytes, NSInteger currentBytes, NSInteger totalBytes);
typedef void (^OIMPutCompletionCallback)(NSInteger totalBytes, NSInteger putType);

NS_ASSUME_NONNULL_BEGIN

@interface PutFileCallbackProxy : NSObject <Open_im_sdk_callbackPutFileCallback>

- (instancetype)initWithOnStart:(OIMPutStartCallback)start
                     onProgress:(OIMProgressCallback)progress
                   onCompletion:(OIMPutCompletionCallback)completion;

@end

NS_ASSUME_NONNULL_END
