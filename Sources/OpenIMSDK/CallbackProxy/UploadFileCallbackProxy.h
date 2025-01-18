//
//  UploadFileCallbackProxy.h
//  OpenIMSDK
//
//  Created by x on 2023/6/19.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

@import OpenIMCore;

typedef void (^OIMUploadProgressCallback)(NSInteger saveBytes, NSInteger currentBytes, NSInteger totalBytes);
typedef void (^OIMUploadCompletionCallback)(NSInteger totalBytes, NSString * _Nonnull url, NSInteger putType);

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileCallbackProxy : NSObject <Open_im_sdk_callbackUploadFileCallback>

- (instancetype)initWithOnProgress:(OIMUploadProgressCallback)progress
                      onCompletion:(OIMUploadCompletionCallback)completion;

@end

@interface UploadLogsCallbackProxy : NSObject <Open_im_sdk_callbackUploadLogProgress>

- (instancetype)initWithOnProgress:(OIMUploadProgressCallback)progress;

@end
NS_ASSUME_NONNULL_END
