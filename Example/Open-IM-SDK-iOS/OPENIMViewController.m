//
//  OPENIMViewController.m
//  Open-IM-SDK-iOS
//
//  Created by xpg on 11/04/2021.
//  Copyright (c) 2021 xpg. All rights reserved.
//

#import "OPENIMViewController.h"
@import Open_IM_SDK_iOS;

@interface OPENIMViewController ()

@end

@implementation OPENIMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [OpenIMiOSSDK.shared initSDK:IOS ipApi:@"127.0.0.1" ipWs:@"ws://128.123.12.3" dbPath:@"" onConnecting:^{
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
