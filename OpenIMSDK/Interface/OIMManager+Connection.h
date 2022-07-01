//
//  OIMManager+Connection.h
//  OpenIMSDK
//
//  Created by x on 2021/2/15.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Connection)

/* 初始化
 * @param platform 平台
 * @param apiAddr    SDK的api地。如http://xxx:10002
 * @param wsAddr     SDK的web socket地址。如： ws://xxx:10001
 * @param dataDir    数据存储路径，默认documents下
 * @param logLevel   默认6
 * @param oss        默认cos, minio 填'minio‘
 */
- (BOOL)initSDK:(OIMPlatform)platform
        apiAdrr:(NSString *)apiAddr
         wsAddr:(NSString *)wsAddr
        dataDir:(NSString * _Nullable)dataDir
       logLevel:(NSInteger)logLevel
  objectStorage:(NSString * _Nullable)os
   onConnecting:(nullable OIMVoidCallback)onConnecting
onConnectFailure:(nullable OIMFailureCallback)onConnectFailure
onConnectSuccess:(nullable OIMVoidCallback)onConnectSuccess
onKickedOffline:(nullable OIMVoidCallback)onKickedOffline
onUserTokenExpired:(nullable OIMVoidCallback)onUserTokenExpired;

- (BOOL)initSDKWithApiAdrr:(NSString *)apiAddr
                    wsAddr:(NSString *)wsAddr
                   dataDir:(NSString * _Nullable)dataDir
                  logLevel:(NSInteger)logLevel
             objectStorage:(NSString * _Nullable)os
              onConnecting:(nullable OIMVoidCallback)onConnecting
          onConnectFailure:(nullable OIMFailureCallback)onConnectFailure
          onConnectSuccess:(nullable OIMVoidCallback)onConnectSuccess
           onKickedOffline:(nullable OIMVoidCallback)onKickedOffline
        onUserTokenExpired:(nullable OIMVoidCallback)onUserTokenExpired;

/*
 * 设置心跳间隔
 */
- (void)setHeartbeatInterval:(NSInteger)heartbeatInterval;

/*
 * 进入前台
 */
- (void)wakeUpWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
