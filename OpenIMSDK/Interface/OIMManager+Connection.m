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
        self.dataDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/"];
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
    
    param[@"platform"] = @([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? iPad : iPhone);
    param[@"api_addr"] = config.apiAddr;
    param[@"ws_addr"]  = config.wsAddr;
    param[@"data_dir"] = config.dataDir;
    param[@"log_level"] = @(config.logLevel);
    param[@"object_storage"] = config.objectStorage;
    param[@"is_need_encryption"] = @(config.encryption);
    param[@"is_compression"] = @(config.compression);
    param[@"is_external_extensions"] = @(config.isExternal);
    
    self.objectStorage = config.objectStorage;
    
    return Open_im_sdkInitSDK([self class].callbacker, [self operationId], param.mj_JSONString);
}

- (BOOL)initSDKWithApiAdrr:(NSString *)apiAddr
                    wsAddr:(NSString *)wsAddr
                   dataDir:(NSString *)dataDir
                  logLevel:(NSInteger)logLevel
             objectStorage:(NSString *)os
              onConnecting:(OIMVoidCallback)onConnecting
          onConnectFailure:(OIMFailureCallback)onConnectFailure
          onConnectSuccess:(OIMVoidCallback)onConnectSuccess
           onKickedOffline:(OIMVoidCallback)onKickedOffline
        onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired {
    
    return [self initSDK:[UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? iPad : iPhone
                 apiAdrr:apiAddr
                  wsAddr:wsAddr
                 dataDir:dataDir
                logLevel:logLevel
           objectStorage:os
            onConnecting:onConnecting
        onConnectFailure:onConnectFailure
        onConnectSuccess:onConnectSuccess
         onKickedOffline:onKickedOffline
      onUserTokenExpired:onUserTokenExpired];
}

- (BOOL)initSDK:(OIMPlatform)platform
        apiAdrr:(NSString *)apiAddr
         wsAddr:(NSString *)wsAddr
        dataDir:(NSString *)dataDir
       logLevel:(NSInteger)logLevel
  objectStorage:(NSString *)os
   onConnecting:(OIMVoidCallback)onConnecting
onConnectFailure:(OIMFailureCallback)onConnectFailure
onConnectSuccess:(OIMVoidCallback)onConnectSuccess
onKickedOffline:(OIMVoidCallback)onKickedOffline
onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired {
    return [self initSDK:[UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? iPad : iPhone
                 apiAdrr:apiAddr
                  wsAddr:wsAddr
                 dataDir:dataDir
                logLevel:logLevel
           objectStorage:os
        enableEncryption:NO
       turnOnCompression:NO
            onConnecting:onConnecting
        onConnectFailure:onConnectFailure
        onConnectSuccess:onConnectSuccess
         onKickedOffline:onKickedOffline
      onUserTokenExpired:onUserTokenExpired];
}

- (BOOL)initSDKWithApiAdrr:(NSString *)apiAddr
                    wsAddr:(NSString *)wsAddr
                   dataDir:(NSString *)dataDir
                  logLevel:(NSInteger)logLevel
             objectStorage:(NSString *)os
          enableEncryption:(BOOL)encryption
         turnOnCompression:(BOOL)compression
              onConnecting:(OIMVoidCallback)onConnecting
          onConnectFailure:(OIMFailureCallback)onConnectFailure
          onConnectSuccess:(OIMVoidCallback)onConnectSuccess
           onKickedOffline:(OIMVoidCallback)onKickedOffline
        onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired {
    
    return [self initSDK:[UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? iPad : iPhone
                 apiAdrr:apiAddr
                  wsAddr:wsAddr
                 dataDir:dataDir
                logLevel:logLevel
           objectStorage:os
        enableEncryption:encryption
       turnOnCompression:compression
            onConnecting:onConnecting
        onConnectFailure:onConnectFailure
        onConnectSuccess:onConnectSuccess
         onKickedOffline:onKickedOffline
      onUserTokenExpired:onUserTokenExpired];
}

- (BOOL)initSDK:(OIMPlatform)platform
        apiAdrr:(NSString *)apiAddr
                    wsAddr:(NSString *)wsAddr
                   dataDir:(NSString *)dataDir
                  logLevel:(NSInteger)logLevel
             objectStorage:(NSString *)os
          enableEncryption:(BOOL)encryption
         turnOnCompression:(BOOL)compression
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
    
    NSString *path = dataDir;
    
    if (!dataDir) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths.firstObject stringByAppendingString:@"/"];
    }
    
    param[@"platform"] = @(platform);
    param[@"api_addr"] = apiAddr;
    param[@"ws_addr"]  = wsAddr;
    param[@"data_dir"] = path;
    param[@"log_level"] = logLevel == 0 ? @6 : @(logLevel);
    param[@"object_storage"] = os.length == 0 ? @"cos" : os;
    param[@"is_need_encryption"] = @(encryption);
    param[@"is_compression"] = @(compression);
    
    self.objectStorage = os.length == 0 ? @"cos" : os;
    
    return Open_im_sdkInitSDK([self class].callbacker, [self operationId], param.mj_JSONString);
}

- (void)setHeartbeatInterval:(NSInteger)heartbeatInterval {
    Open_im_sdkSetHeartbeatInterval(heartbeatInterval);
}

- (void)wakeUpWithOnSuccess:(OIMSuccessCallback)onSuccess
                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkWakeUp(callback, [self operationId]);
}

- (void)setAppBackgroundStatus:(BOOL)isBackground
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetAppBackgroundStatus(callback, [self operationId], isBackground);
}
@end
