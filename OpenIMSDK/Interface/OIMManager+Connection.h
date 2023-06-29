//
//  OIMManager+Connection.h
//  OpenIMSDK
//
//  Created by x on 2021/2/15.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMInitConfig : NSObject

// 设备类型 默认根据userInterfaceIdiom设置iPhone / iPad
@property (nonatomic, assign) OIMPlatform platform;
// SDK的API地址
@property (nonatomic, copy) NSString *apiAddr;
// SDK的Web Socket地址
@property (nonatomic, copy) NSString *wsAddr;
// 默认 Documents/下
@property (nonatomic, copy, nullable) NSString *dataDir;
// 日志等级默认6
@property (nonatomic, assign) NSInteger logLevel;
// 默认minio
@property (nonatomic, copy, nullable) NSString *objectStorage;
// 加密，默认NO
@property (nonatomic, assign) BOOL encryption;
// 压缩，默认NO
@property (nonatomic, assign) BOOL compression;
@property (nonatomic, assign) BOOL isExternal;
// 日志输入本地，默认YES
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

/*
 * 设置心跳间隔
 */
- (void)setHeartbeatInterval:(NSInteger)heartbeatInterval;

@end

NS_ASSUME_NONNULL_END
