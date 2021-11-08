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
    [OpenIMiOSSDK.shared initSDK:IOS ipApi:@"http://1.14.194.38:10000" ipWs:@"ws://1.14.194.38:17778" dbPath:NSHomeDirectory() onConnecting:^{
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
    
    [OpenIMiOSSDK.shared login:@"iostest" token:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVSUQiOiJpb3N0ZXN0IiwiUGxhdGZvcm0iOiJJT1MiLCJleHAiOjE2MzY5NjQ3NzMsImlhdCI6MTYzNjM1OTk3MywibmJmIjoxNjM2MzU5OTczfQ.LkclEddIjAPNU1BoNSj9UWDztUon1sb7bFAmnGu2BHY" onSuccess:^(NSString * _Nullable data) {
        NSLog(@"onSuccess");
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        NSLog(@"onError %@",ErrMsg);
    }];
    
    UserInfo *u = [OpenIMiOSSDK.shared getLoginUser];
    NSLog(@"-----   %@",[u dict]);
    
    [OpenIMiOSSDK.shared getGroupApplicationList:^(GroupApplicationList * _Nonnull groupApplicationList) {
        NSLog(@"getGroupApplicationList getGroupApplicationList %@",[groupApplicationList dict]);
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        NSLog(@"getGroupApplicationList onError");
    }];
    
//    [OpenIMiOSSDK.shared getFriendList:^(NSArray * _Nonnull userInfoList) {
//        NSLog(@"getFriendList userInfoList");
//        for (UserInfo *u in userInfoList) {
//            NSLog(@"%@",[u dict]);
//        }
//    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
//        NSLog(@"getFriendList onError");
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
