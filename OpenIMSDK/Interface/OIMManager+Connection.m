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
        self.logLevel = 6;
        self.objectStorage = @"minio";
        self.encryption = NO;
        self.compression = NO;
        self.isExternal = NO;
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
       onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired {
    
    [self class].callbacker.connecting = onConnecting;
    [self class].callbacker.connectFailure = onConnectFailure;
    [self class].callbacker.connectSuccess = onConnectSuccess;
    [self class].callbacker.kickedOffline = onKickedOffline;
    [self class].callbacker.userTokenExpired = onUserTokenExpired;
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    param[@"platformID"] = @(config.platform);
    param[@"apiAddr"] = config.apiAddr;
    param[@"wsAddr"]  = config.wsAddr;
    param[@"dataDir"] = config.dataDir;
    param[@"logLevel"] = @(config.logLevel);
    param[@"objectStorage"] = config.objectStorage;
    param[@"isNeedEncryption"] = @(config.encryption);
    param[@"isCompression"] = @(config.compression);
    param[@"isExternalExtensions"] = @(config.isExternal);
    param[@"logFilePath"] = config.logFilePath;
    param[@"isLogStandardOutput"] = @(config.isLogStandardOutput);
    
    self.objectStorage = config.objectStorage;
    
    return Open_im_sdkInitSDK([self class].callbacker, [self operationId], param.mj_JSONString);
}

- (void)setHeartbeatInterval:(NSInteger)heartbeatInterval {
    Open_im_sdkSetHeartbeatInterval(heartbeatInterval);
}

@end
