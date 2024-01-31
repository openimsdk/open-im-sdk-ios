//
//  OIMManager+Connection.h
//  OpenIMSDK
//
//  Created by x on 2021/2/15.
//

#import "OIMManager.h"
#import "UploadFileCallbackProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMInitConfig : NSObject

// Device type, default setting is based on userInterfaceIdiom for iPhone/iPad
@property (nonatomic, assign) OIMPlatform platform;
// SDK's API address
@property (nonatomic, copy) NSString *apiAddr;
// SDK's WebSocket address
@property (nonatomic, copy) NSString *wsAddr;
// Default is under Documents/
@property (nonatomic, copy, nullable) NSString *dataDir;
// Log level, default is 6
@property (nonatomic, assign) NSInteger logLevel;
// Compression, default is NO
@property (nonatomic, assign) BOOL compression;
// Log output to local, default is YES
@property (nonatomic, assign) BOOL isLogStandardOutput;
@property (nonatomic, copy, nullable) NSString *logFilePath;

@end

@interface OIMManager (Connection)

- (BOOL)initSDKWithConfig:(OIMInitConfig *)config
             onConnecting:(OIMVoidCallback)onConnecting
         onConnectFailure:(OIMFailureCallback)onConnectFailure
         onConnectSuccess:(OIMVoidCallback)onConnectSuccess
          onKickedOffline:(OIMVoidCallback)onKickedOffline
       onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired;

/**
 * Set heartbeat interval
 */
- (void)setHeartbeatInterval:(NSInteger)heartbeatInterval;

- (void)unInitSDK;

- (void)uploadLogsWithProgress:(OIMUploadProgressCallback)onProgress
                            ex:(NSString *)ex
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure;

@end

NS_ASSUME_NONNULL_END
