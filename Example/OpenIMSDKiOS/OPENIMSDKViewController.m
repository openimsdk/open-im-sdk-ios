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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *docDir = [paths objectAtIndex:0];
    
    [OpenIMiOSSDK.shared initSDK:IOS ipApi:@"http://47.112.160.66:10000" ipWs:@"ws://47.112.160.66:17778" dbPath:[docDir stringByAppendingString:@"/"] onConnecting:^{
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
    
    
    [OpenIMiOSSDK.shared login:@"iostest" token:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVSUQiOiJpb3N0ZXN0IiwiUGxhdGZvcm0iOiJJT1MiLCJleHAiOjE2MzgzMjQ4NjIsIm5iZiI6MTYzNzcyMDA2MiwiaWF0IjoxNjM3NzIwMDYyfQ.QUNzY_jHgtzzSamCE1rY8uVMBENJdkfocHhfjwjUMPw" onSuccess:^(NSString * _Nullable data) {
        NSLog(@"onSuccess");
        
        [OpenIMiOSSDK.shared getTotalUnreadMsgCount:nil onError:nil];
        
        [OpenIMiOSSDK.shared getFriendList:^(NSArray * _Nonnull userInfoList) {
            NSLog(@"getFriendList - %@",userInfoList);
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        [OpenIMiOSSDK.shared getAllConversationList:^(NSArray * _Nonnull conversationInfoList) {
            NSLog(@"getAllConversationList - %@",conversationInfoList);
        } on:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        Message *msg = [OpenIMiOSSDK.shared createTextMessage:@"test message"];
        [OpenIMiOSSDK.shared sendMessage:msg recvUid:@"1" recvGid:@"1" onlineUserOnly:NO onSuccess:^(NSString * _Nullable data) {
            
        } onProgress:^(long progress) {
            
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        [OpenIMiOSSDK.shared getHistoryMessageList:@"1" groupID:@"" startMsg:nil count:100 onSuccess:^(NSArray * _Nonnull messageList) {
            
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
        });
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        NSLog(@"onError %@",ErrMsg);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //获取图片
        NSURL *imgUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        
        NSString* imgName = [imgUrl lastPathComponent];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        NSString *docDir = [paths objectAtIndex:0];
        
        NSString* localPath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",imgName]];

        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:localPath atomically:YES];
        
        Message *m = [OpenIMiOSSDK.shared createImageMessageFromFullPath:localPath];
        [OpenIMiOSSDK.shared sendMessage:m recvUid:@"1" recvGid:@"1" onlineUserOnly:NO onSuccess:^(NSString * _Nullable data) {
            
        } onProgress:^(long progress) {
            NSLog(@"%@",@(progress));
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        
        //上传到服务器
        //[self doAddPhoto:image];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
