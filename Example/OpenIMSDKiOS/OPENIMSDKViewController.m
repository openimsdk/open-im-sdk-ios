//
//  OPENIMSDKViewController.m
//  OpenIMSDKiOS
//
//  Created by xpg on 11/08/2021.
//  Copyright (c) 2021 xpg. All rights reserved.
//

#import "OPENIMSDKViewController.h"
@import OpenIMSDKiOS;

@interface OPENIMSDKViewController ()

@end

@implementation OPENIMSDKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [OpenIMiOSSDK.shared initSDK:IOS ipApi:@"127.0.0.1" ipWs:@"ws://128.123.12.3" dbPath:NSTemporaryDirectory() onConnecting:^{
        NSLog(@"onConnecting");
    } onConnectFailed:^(long ErrCode, NSString * _Nullable ErrMsg) {
        NSLog(@"onConnectFailed");
    } onConnectSuccess:^{
        NSLog(@"onConnectSuccess");
    } onKickedOffline:^{
        NSLog(@"onKickedOffline");
    } onUserTokenExpired:^{
        NSLog(@"onUserTokenExpired");
    } onSelfInfoUpdated:^(UserInfo* _Nullable userInfo) {
        NSLog(@"onSelfInfoUpdated");
    }];
    
    [OpenIMiOSSDK.shared login:@"1" token:@"1" onSuccess:^(NSString * _Nullable data) {
        NSLog(@"onSuccess");
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        NSLog(@"onError %@",ErrMsg);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
