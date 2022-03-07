//
//  OIMManager+Connection.m
//  OpenIMSDK
//
//  Created by x on 2021/2/15.
//

#import "OIMManager+Connection.h"

@implementation OIMManager (Connection)

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
    
    [self class].callbacker.connecting = onConnecting;
    [self class].callbacker.connectFailure = onConnectFailure;
    [self class].callbacker.connectSuccess = onConnectSuccess;
    [self class].callbacker.kickedOffline = onKickedOffline;
    [self class].callbacker.userTokenExpired = onUserTokenExpired;
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    param[@"platform"] = @(platform);
    
    param[@"api_addr"] = apiAddr ?: @"";
    param[@"ws_addr"]  = wsAddr ?: @"";
    param[@"data_dir"] = dataDir ?: @"";
    param[@"log_level"] = logLevel == 0 ? @6 : @(logLevel);
    param[@"object_storage"] = os.length == 0 ? @"cos" : os;
    
    return Open_im_sdkInitSDK([self class].callbacker, [self operationId], param.mj_JSONString);
}

@end
