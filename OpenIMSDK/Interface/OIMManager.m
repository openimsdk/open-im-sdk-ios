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
