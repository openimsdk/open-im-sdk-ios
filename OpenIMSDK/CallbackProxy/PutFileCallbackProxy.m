//
//  PutFileCallbackProxy.m
//  OpenIMSDK
//
//  Created by x on 2023/6/19.
//

#import "PutFileCallbackProxy.h"

@interface PutFileCallbackProxy() {
    OIMPutStartCallback onStart;
    OIMProgressCallback onProgress;
    OIMPutCompletionCallback onCompletion;
}

@end

@implementation PutFileCallbackProxy

- (instancetype)initWithOnStart:(OIMPutStartCallback)start
                     onProgress:(OIMProgressCallback)progress
                   onCompletion:(OIMPutCompletionCallback)completion {
    
    if (self = [super init]) {
        onStart = start;
        onProgress = progress;
        onCompletion = completion;
    }
    
    return self;
}

- (void)dispatchMainThread:(void (NS_NOESCAPE ^)(void))todo {
    if ([NSThread isMainThread]) {
        todo();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            todo();
        });
    }
}

- (void)open:(int64_t)size {
    
}

- (void)hashProgress:(int64_t)current total:(int64_t)total {
    
}

- (void)hashComplete:(NSString *)hash total:(int64_t)total {
    
}

- (void)putStart:(int64_t)current total:(int64_t)total {
    [self dispatchMainThread:^{
        onStart(current, total);
    }];
}

- (void)putProgress:(int64_t)save current:(int64_t)current total:(int64_t)total {
    [self dispatchMainThread:^{
        onProgress(save, current, total);
    }];
}

- (void)putComplete:(int64_t)total putType:(long)putType {
    [self dispatchMainThread:^{
        onCompletion(total, putType);
    }];
}

@end
