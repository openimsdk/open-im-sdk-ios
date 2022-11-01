//
//  OIMManager.m
//  OpenIMSDK
//
//  Created by x on 2022/2/15.
//

#import "OIMManager.h"

@interface OIMManager ()
{
    OIMCallbacker *_callbacker;
    UIBackgroundTaskIdentifier _backgroundTaskIdentifier;
}

@end

@implementation OIMManager
@dynamic callbacker;

+ (instancetype)manager {
    
    static OIMManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OIMManager alloc]init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 13.0, *)) {
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(didEnterBackground)
                                                        name:UISceneDidEnterBackgroundNotification
                                                      object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(willEnterForeground)
                                                        name:UISceneWillEnterForegroundNotification
                                                      object:nil];
        } else {
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(didEnterBackground)
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(willEnterForeground)
                                                        name:UIApplicationWillEnterForegroundNotification
                                                      object:nil];
        }
    }
    
    return  self;
}

- (void)didEnterBackground {
    __weak typeof(self) weakSelf = self;
    _backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"com.oim.background.task" expirationHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf->_backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
            
            [[UIApplication sharedApplication] endBackgroundTask:strongSelf->_backgroundTaskIdentifier];
            strongSelf->_backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    }];
}

- (void)willEnterForeground {
    [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskIdentifier];
}

+ (OIMCallbacker *)callbacker {
    return [OIMManager manager].callbacker;
}

- (OIMCallbacker *)callbacker {
    if (_callbacker == nil) {
        _callbacker = [OIMCallbacker callbacker];
    }
    return _callbacker;
}

+ (NSString *)sdkSdkVersion
{
    return Open_im_sdkSdkVersion();
}

- (NSString *)getLoginUid {
    return Open_im_sdkGetLoginUser();
}

- (NSString *)getLoginUser {
    return Open_im_sdkGetLoginUser();
}

- (NSString *)operationId {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%ld", (NSInteger)time];
}

@end
