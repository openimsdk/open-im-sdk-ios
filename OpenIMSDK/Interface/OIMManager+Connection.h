//
//  OIMManager+Connection.h
//  OpenIMSDK
//
//  Created by x on 2022/2/15.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Connection) <Open_im_sdk_callbackOnConnListener>

/* 初始化
 * @param platform 平台
 * @param apiAddr    SDK的api地。如http:xxx:10000
 * @param wsAddr     SDK的web socket地址。如： ws:xxx:17778
 * @param dataDir    数据存储路径
 * @param logLevel   默认6
 * @param oss        默认cos
 */
- (BOOL)initSDK:(OIMPlatform)platform
        apiAdrr:(NSString *)apiAddr
         wsAddr:(NSString *)wsAddr
        dataDir:(NSString *)dataDir
       logLevel:(NSInteger)logLevel
  objectStorage:(NSString * _Nullable)os
   onConnecting:(OIMVoidCallback)onConnecting
onConnectFailure:(OIMFailureCallback)onConnectFailure
onConnectSuccess:(OIMVoidCallback)onConnectSuccess
onKickedOffline:(OIMVoidCallback)onKickedOffline
onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired;

@end

NS_ASSUME_NONNULL_END
