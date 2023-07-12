//
//  UploadFileCallbackProxy.m
//  OpenIMSDK
//
//  Created by x on 2023/6/19.
//

#import "UploadFileCallbackProxy.h"

@interface UploadFileCallbackProxy() {
    OIMUploadProgressCallback onProgress;
    OIMUploadCompletionCallback onCompletion;
}

@end

@implementation UploadFileCallbackProxy

- (instancetype)initWithOnProgress:(OIMUploadProgressCallback)progress
                   onCompletion:(OIMUploadCompletionCallback)completion {
    
    if (self = [super init]) {
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

- (void)complete:(int64_t)size url:(NSString* _Nullable)url typ:(int32_t)typ {
    [self dispatchMainThread:^{
        onCompletion(size, url, typ);
    }];
}

- (void)hashPartComplete:(NSString* _Nullable)partsHash fileHash:(NSString* _Nullable)fileHash {
    
}

- (void)hashPartProgress:(int32_t)index size:(int64_t)size partHash:(NSString* _Nullable)partHash {
    
}

- (void)open:(int64_t)size {
    
}

- (void)partSize:(int64_t)partSize num:(int32_t)num {
    
}

- (void)uploadComplete:(int64_t)fileSize streamSize:(int64_t)streamSize storageSize:(int64_t)storageSize {
    [self dispatchMainThread:^{
        onProgress(fileSize, streamSize, storageSize);
    }];
}

- (void)uploadID:(NSString* _Nullable)uploadID {
    
}

- (void)uploadPartComplete:(int32_t)index partSize:(int64_t)partSize partHash:(NSString* _Nullable)partHash {
    
}

@end
