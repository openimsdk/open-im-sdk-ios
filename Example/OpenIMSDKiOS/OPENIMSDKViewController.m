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
    
    [OpenIMiOSSDK.shared setSdkLog:true];
    
    [OpenIMiOSSDK.shared initSDK:IOS ipApi:@"http://121.37.25.71:10000" ipWs:@"ws://121.37.25.71:17778" dbPath:[docDir stringByAppendingString:@"/"] onConnecting:^{
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
    
    [OpenIMiOSSDK.shared setConversationRecvMessageOpt:@[@"13123123"] status:2 onSuccess:^(NSString * _Nullable data) {
        
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        
    }];
    
    
    [OpenIMiOSSDK.shared login:@"15678900987" token:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVSUQiOiIxNTY3ODkwMDk4NyIsIlBsYXRmb3JtIjoiSU9TIiwiZXhwIjoxNjQwODQ2NjAzLCJuYmYiOjE2NDAyNDE4MDMsImlhdCI6MTY0MDI0MTgwM30.lPMUH9kqO9ZB2KDnH6MeXniQChVthXxVM4iSLj_Invo" onSuccess:^(NSString * _Nullable data) {
        NSLog(@"onSuccess");
        
        [OpenIMiOSSDK.shared getTotalUnreadMsgCount:nil onError:nil];
        
        [OpenIMiOSSDK.shared getAllConversationList:^(NSArray<ConversationInfo *> * _Nonnull conversationInfoList) {
            
        } on:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        [OpenIMiOSSDK.shared getFriendList:^(NSArray * _Nonnull userInfoList) {
            NSLog(@"getFriendList - %@",userInfoList);
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        [OpenIMiOSSDK.shared getAllConversationList:^(NSArray * _Nonnull conversationInfoList) {
            NSLog(@"getAllConversationList - %@",conversationInfoList);
        } on:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        Message *msg = [OpenIMiOSSDK.shared createTextMessage:@"test message"];
        [OpenIMiOSSDK.shared sendMessage:msg recvUid:@"1442969940624670720" recvGid:@"1" onlineUserOnly:NO onSuccess:^(NSString * _Nullable data) {
            
        } onProgress:^(long progress) {
            
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        [OpenIMiOSSDK.shared getHistoryMessageList:@"1" groupID:@"" startMsg:nil count:100 onSuccess:^(NSArray * _Nonnull messageList) {
            
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                picker.delegate = self;
//                picker.allowsEditing = YES;
//                [self presentViewController:picker animated:YES completion:nil];
//        });
        GroupMemberRole *r = [GroupMemberRole new];
        r.uid = @"15678900987";
        r.setRole = 1;
        [OpenIMiOSSDK.shared createGroup:@"1" notification:nil introduction:nil faceUrl:nil list:@[r] onSuccess:^(NSString * _Nullable data) {
            
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        [OpenIMiOSSDK.shared getGroupApplicationList:^(GroupApplicationList * _Nonnull groupApplicationList) {
            NSLog(@"groupApplicationListgroupApplicationListgroupApplicationListgroupApplicationList------");
            NSLog(@"%d",groupApplicationList.count);
            NSLog(@"%@",groupApplicationList.user.debugDescription);
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
        
        [OpenIMiOSSDK.shared markC2CMessageAsRead:@"1" msgIds:@[@"1",@"2",@"3",@"4"] onSuccess:^(NSString * _Nullable data) {
            
        } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
            
        }];
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        NSLog(@"onError %@",ErrMsg);
    }];
    
//    GroupMemberRole *g = [GroupMemberRole new];
//    g.uid = @"1";
//    g.setRole = 0;
//    [OpenIMiOSSDK.shared createGroup:@"" notification:@"" introduction:@"" faceUrl:nil list:@[g] onSuccess:^(NSString * _Nullable data) {
//
//    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
//
//    }];
    
//    Message *msg = [Message new];
//    NSArray *arr = @[msg];
//    Message *m = [OpenIMiOSSDK.shared createMergerMessage:arr title:@"" summaryList:@[@"123"]];
//
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        [self presentViewController:picker animated:YES completion:nil];
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
        
        Message *m = [OpenIMiOSSDK.shared createSoundMessageFromFullPath:localPath duration:123];
        [OpenIMiOSSDK.shared sendMessage:m recvUid:@"iostest" recvGid:@"1" onlineUserOnly:NO onSuccess:^(NSString * _Nullable data) {
            
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
