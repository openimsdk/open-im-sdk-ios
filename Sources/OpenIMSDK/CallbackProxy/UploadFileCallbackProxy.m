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

- (void)complete:(int64_t)size url:(NSString *)url typ:(long)typ {
    [self dispatchMainThread:^{
        onCompletion(size, url, typ);
    }];
}

- (void)hashPartComplete:(NSString* _Nullable)partsHash fileHash:(NSString* _Nullable)fileHash {
    
}

- (void)hashPartProgress:(long)index size:(int64_t)size partHash:(NSString *)partHash {
    
}

- (void)open:(int64_t)size {
    
}

- (void)partSize:(int64_t)partSize num:(long)num {
    
}

- (void)uploadComplete:(int64_t)fileSize streamSize:(int64_t)streamSize storageSize:(int64_t)storageSize {
    [self dispatchMainThread:^{
        onProgress(fileSize, streamSize, storageSize);
    }];
}

- (void)uploadID:(NSString* _Nullable)uploadID {
    
}

- (void)uploadPartComplete:(long)index partSize:(int64_t)partSize partHash:(NSString *)partHash {
    
}

@end

@interface UploadLogsCallbackProxy() {
    OIMUploadProgressCallback onProgress;
}

@end

@implementation UploadLogsCallbackProxy

- (instancetype)initWithOnProgress:(OIMUploadProgressCallback)progress {
    if (self = [super init]) {
        onProgress = progress;
    }
    
    return self;
}

- (void)onProgress:(int64_t)current size:(int64_t)size {
    [self dispatchMainThread:^{
        onProgress(current, current, size);
    }];
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
@end

