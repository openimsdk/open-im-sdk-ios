//
//  OIMManager+Connection.m
//  OpenIMSDK
//
//  Created by x on 2021/2/15.
//

#import "OIMManager+Connection.h"
#import "CallbackProxy.h"

@implementation OIMInitConfig

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.platform = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? iPad : iPhone;
        self.dataDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/"];
        self.logFilePath = self.dataDir;
        self.isLogStandardOutput = YES;
        self.logLevel = 5;
        self.compression = NO;
        self.systemType = @"native_iOS";
    }
    
    return self;
}

@end


@implementation OIMManager (Connection)

- (BOOL)initSDKWithConfig:(OIMInitConfig *)config
             onConnecting:(OIMVoidCallback)onConnecting
         onConnectFailure:(OIMFailureCallback)onConnectFailure
         onConnectSuccess:(OIMVoidCallback)onConnectSuccess
          onKickedOffline:(OIMVoidCallback)onKickedOffline
       onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired
       onUserTokenInvalid:(OIMStringCallback)onUserTokenInvalid {
    
    [self class].callbacker.connecting = onConnecting;
    [self class].callbacker.connectFailure = onConnectFailure;
    [self class].callbacker.connectSuccess = onConnectSuccess;
    [self class].callbacker.kickedOffline = onKickedOffline;
    [self class].callbacker.userTokenExpired = onUserTokenExpired;
    [self class].callbacker.userTokenInvalid = onUserTokenInvalid;
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    param[@"platformID"] = @(config.platform);
    param[@"apiAddr"] = config.apiAddr;
    param[@"wsAddr"]  = config.wsAddr;
    param[@"dataDir"] = config.dataDir;
    param[@"logLevel"] = @(config.logLevel);
    param[@"isCompression"] = @(config.compression);
    param[@"logFilePath"] = config.logFilePath;
    param[@"isLogStandardOutput"] = @(config.isLogStandardOutput);
    param[@"systemType"] = config.systemType;
        
    return Open_im_sdkInitSDK([self class].callbacker, [self operationId], param.mj_JSONString);
}

- (void)unInitSDK {
    Open_im_sdkUnInitSDK([self operationId]);
}

- (void)uploadLogsWithProgress:(OIMUploadProgressCallback)onProgress 
                          line:(NSInteger )line
                            ex:(NSString *)ex
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    UploadLogsCallbackProxy *progress = [[UploadLogsCallbackProxy alloc] initWithOnProgress:onProgress];
    
    Open_im_sdkUploadLogs(callback, [self operationId], line, ex, progress);
}

- (void)logs:(NSString *)file
        line:(NSInteger)line
        msgs:(NSString *)msgs
         err:(NSString *)err
keyAndValues:(NSArray *)keyAndValues
    logLevel:(NSInteger )logLevel {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg) {
        
    }];

    Open_im_sdkLogs(callback, [self operationId], logLevel, file ?: @"", line, msgs ?: @"", err ?: @"", (keyAndValues ?: @[]).mj_JSONString);
}
@end
