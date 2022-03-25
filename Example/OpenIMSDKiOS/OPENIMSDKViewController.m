//
//  OPENIMSDKViewController.m
//  OpenIMSDKiOS
//
//  Created by xpg on 11/08/2021.
//  Copyright (c) 2021 xpg. All rights reserved.
//
//  Modify by x on 21/02/2022

#import "OPENIMSDKViewController.h"
#import "OPENIMSDKTableViewCell.h"

@import OpenIMSDK;

static NSString *OPENIMSDKTableViewCellIdentifier = @"OPENIMSDKTableViewCellIdentifier";

#define OIM_LIST_CELL_TITLE @"title"
#define OIM_LIST_CELL_FUNC @"func"


/*
 *  端口是固定的，勿动
 *  LOGIN_USER_ID 注册以后生成
 *  LOGIN_USER_TOKEN 注册以后生成
 *  OTHER_USER_ID 注册以后生成
 *  GROUP_ID 创建群以后生成
 *  CONVERSASTION_ID 有会话以后生成
 *  注意：部分API只能设置other_user_id 或者 group_id 其中之一，例如发送消息
 */
#define API_ADDRESS         @"http://121.37.25.71:10000"
#define WS_ADDRESS          @"ws://121.37.25.71:17778"

#define LOGIN_USER_ID       @"x2"
#define LOGIN_USER_TOKEN    @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVSUQiOiJ4MiIsIlBsYXRmb3JtIjoiSU9TIiwiZXhwIjoxNjQ2MTA0MDYyLCJuYmYiOjE2NDU0OTkyNjIsImlhdCI6MTY0NTQ5OTI2Mn0.XYGVdQPJTQ2U2fEQTpCYb5CWK4FcSknyJ-gcVgT0QwA"
#define OTHER_USER_ID       @"x1"

#define GROUP_ID            @""
#define CONVERSASTION_ID    @""

@interface OPENIMSDKViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *funcTableView;

@property (nonatomic, copy) NSArray <NSString *> *titles;

@property (nonatomic, copy) NSArray <NSArray <NSDictionary *> *> *funcs;


@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UITextView *errorTipsView;


@property (nonatomic, strong) OIMMessageInfo *testMessage;

@end

@implementation OPENIMSDKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.titles = @[@"登陆", @"用户信息", @"好友", @"群", @"消息", @"会话"];
    self.funcs = @[
        @[@{OIM_LIST_CELL_TITLE: @"登陆", OIM_LIST_CELL_FUNC: @"login"},
          @{OIM_LIST_CELL_TITLE: @"登陆状态", OIM_LIST_CELL_FUNC: @"loginStatus"},
          @{OIM_LIST_CELL_TITLE: @"登出", OIM_LIST_CELL_FUNC: @"logout"}],
        
        @[@{OIM_LIST_CELL_TITLE: @"登录用户信息", OIM_LIST_CELL_FUNC: @"getSelfInfo"},
          @{OIM_LIST_CELL_TITLE: @"修改登录用户信息", OIM_LIST_CELL_FUNC: @"setSelfInfo"},
          @{OIM_LIST_CELL_TITLE: @"获取指定用户信息", OIM_LIST_CELL_FUNC: @"getUsersInfo"}],
        
        @[@{OIM_LIST_CELL_TITLE: @"添加好友", OIM_LIST_CELL_FUNC: @"addFriend"},
          @{OIM_LIST_CELL_TITLE: @"获取好友申请的列表", OIM_LIST_CELL_FUNC: @"getFriendApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"获取申请好友的列表", OIM_LIST_CELL_FUNC: @"getSendFriendApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"同意好友申请", OIM_LIST_CELL_FUNC: @"acceptFriendApplication"},
          @{OIM_LIST_CELL_TITLE: @"拒绝好友申请", OIM_LIST_CELL_FUNC: @"refuseFriendApplication"},
          @{OIM_LIST_CELL_TITLE: @"加黑名单", OIM_LIST_CELL_FUNC: @"addToBlackList"},
          @{OIM_LIST_CELL_TITLE: @"黑名单", OIM_LIST_CELL_FUNC: @"getBlackList"},
          @{OIM_LIST_CELL_TITLE: @"从黑名单移除", OIM_LIST_CELL_FUNC: @"removeFromBlackList"},
          @{OIM_LIST_CELL_TITLE: @"获取指定好友信息", OIM_LIST_CELL_FUNC: @"getDesignatedFriendsInfo"},
          @{OIM_LIST_CELL_TITLE: @"获取好友列表", OIM_LIST_CELL_FUNC: @"getFriendList"},
          @{OIM_LIST_CELL_TITLE: @"验证是否好友关系", OIM_LIST_CELL_FUNC: @"checkFriend"},
          @{OIM_LIST_CELL_TITLE: @"设置好友备注", OIM_LIST_CELL_FUNC: @"setFriendRemark"},
          @{OIM_LIST_CELL_TITLE: @"删除好友", OIM_LIST_CELL_FUNC: @"deleteFriend"}],
        
        @[@{OIM_LIST_CELL_TITLE: @"创建群聊", OIM_LIST_CELL_FUNC: @"createGroup"},
          @{OIM_LIST_CELL_TITLE: @"加入群聊", OIM_LIST_CELL_FUNC: @"joinGroup"},
          @{OIM_LIST_CELL_TITLE: @"退出群聊", OIM_LIST_CELL_FUNC: @"quitGroup"},
          @{OIM_LIST_CELL_TITLE: @"群列表", OIM_LIST_CELL_FUNC: @"getJoinedGroupList"},
          @{OIM_LIST_CELL_TITLE: @"获取指定群信息", OIM_LIST_CELL_FUNC: @"getGroupsInfo"},
          @{OIM_LIST_CELL_TITLE: @"设置群信息", OIM_LIST_CELL_FUNC: @"setGroupInfo"},
          @{OIM_LIST_CELL_TITLE: @"获取群成员列表", OIM_LIST_CELL_FUNC: @"getGroupMemberList"},
          @{OIM_LIST_CELL_TITLE: @"获取指定群成员列表", OIM_LIST_CELL_FUNC: @"getGroupMembersInfo"},
          @{OIM_LIST_CELL_TITLE: @"踢出群", OIM_LIST_CELL_FUNC: @"kickGroupMember"},
          @{OIM_LIST_CELL_TITLE: @"转让群主", OIM_LIST_CELL_FUNC: @"transferGroupOwner"},
          @{OIM_LIST_CELL_TITLE: @"邀请某些人进群", OIM_LIST_CELL_FUNC: @"inviteUserToGroup"},
          @{OIM_LIST_CELL_TITLE: @"获取他人申请进群列表", OIM_LIST_CELL_FUNC: @"getGroupApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"获取发出的进群申请列表", OIM_LIST_CELL_FUNC: @"getSendGroupApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"同意某人进群", OIM_LIST_CELL_FUNC: @"acceptGroupApplication"},
          @{OIM_LIST_CELL_TITLE: @"拒绝某人进群", OIM_LIST_CELL_FUNC: @"refuseGroupApplication"},
          @{OIM_LIST_CELL_TITLE: @"清空群聊天记录", OIM_LIST_CELL_FUNC: @"clearGroupHistoryMessage"},
          @{OIM_LIST_CELL_TITLE: @"解散群", OIM_LIST_CELL_FUNC: @"clearGroupHistoryMessage"},],
        
        @[@{OIM_LIST_CELL_TITLE: @"发送消息", OIM_LIST_CELL_FUNC: @"sendMessage"},
          @{OIM_LIST_CELL_TITLE: @"获取聊天历史", OIM_LIST_CELL_FUNC: @"getHistoryMessageList"},
          @{OIM_LIST_CELL_TITLE: @"撤销消息", OIM_LIST_CELL_FUNC: @"revokeMessage"},
          @{OIM_LIST_CELL_TITLE: @"输入状态", OIM_LIST_CELL_FUNC: @"typingStatusUpdate"},
          @{OIM_LIST_CELL_TITLE: @"单聊已读", OIM_LIST_CELL_FUNC: @"markC2CMessageAsRead"},
          @{OIM_LIST_CELL_TITLE: @"清空历史消息", OIM_LIST_CELL_FUNC: @"clearC2CHistoryMessage"},
          @{OIM_LIST_CELL_TITLE: @"本地插入消息", OIM_LIST_CELL_FUNC: @"insertSingleMessageToLocalStorage"}],
        
        @[@{OIM_LIST_CELL_TITLE: @"会话列表", OIM_LIST_CELL_FUNC: @"getAllConversationList"},
          @{OIM_LIST_CELL_TITLE: @"分页获取会话", OIM_LIST_CELL_FUNC: @"getConversationListSplit"},
          @{OIM_LIST_CELL_TITLE: @"获取一个会话", OIM_LIST_CELL_FUNC: @"getOneConversation"},
          @{OIM_LIST_CELL_TITLE: @"获取多个会话", OIM_LIST_CELL_FUNC: @"getMultipleConversation"},
          @{OIM_LIST_CELL_TITLE: @"删除会话", OIM_LIST_CELL_FUNC: @"deleteConversation"},
          @{OIM_LIST_CELL_TITLE: @"设置会话草稿", OIM_LIST_CELL_FUNC: @"setConversationDraft"},
          @{OIM_LIST_CELL_TITLE: @"置顶会话", OIM_LIST_CELL_FUNC: @"pinConversation"},
          @{OIM_LIST_CELL_TITLE: @"获取未读数", OIM_LIST_CELL_FUNC: @"getTotalUnreadMsgCount"},
          @{OIM_LIST_CELL_TITLE: @"标记已读", OIM_LIST_CELL_FUNC: @"markGroupMessageHasRead"},
          @{OIM_LIST_CELL_TITLE: @"免打扰状态", OIM_LIST_CELL_FUNC: @"getConversationRecvMessageOpt"},
          @{OIM_LIST_CELL_TITLE: @"设置免打扰", OIM_LIST_CELL_FUNC: @"setConversationRecvMessageOpt"},
          @{OIM_LIST_CELL_TITLE: @"本地插入群消息", OIM_LIST_CELL_FUNC: @"insertGroupMessageToLocalStorage"},
          @{OIM_LIST_CELL_TITLE: @"查找本地消息", OIM_LIST_CELL_FUNC: @"searchLocalMessages"}],
    ];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenErrorView)];
    
    [self.errorView addGestureRecognizer:tap];
    
    [self initSDK];
    
    [self login];
    
    [self callback];
}

- (void)hiddenErrorView {
    self.errorView.hidden = YES;
}

- (void)showErrorMsg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.errorView.hidden = NO;
        self.errorTipsView.text = msg;
    });
}

- (void)operate:(SEL)selector todo:(void (NS_NOESCAPE ^)(void (^callback)(NSNumber *code, NSString *msg) ))todo {
    NSLog(@"\n\n ----- %@ -----", NSStringFromSelector(selector));
    todo(^(NSNumber *code, NSString *msg) {
        if (msg.length > 0) {
            NSString *errMsg = [NSString stringWithFormat:@"error msg:%@, code:%@", msg, code];
            [self showErrorMsg:errMsg];
            NSLog(@"\n\n -----%@ Failure -----\n \n%@", NSStringFromSelector(selector), errMsg);
        } else {
            NSLog(@"\n\n -----%@ Success -----\n \n", NSStringFromSelector(selector));
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.funcs[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OPENIMSDKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OPENIMSDKTableViewCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = self.funcs[indexPath.section][indexPath.row];
    
    [cell.funcButton setTitle:[@"点我" stringByAppendingString:item[OIM_LIST_CELL_TITLE]] forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    
    [cell funcButtonAction:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
                
        SEL selector = NSSelectorFromString(item[OIM_LIST_CELL_FUNC]);
        IMP imp = [strongSelf methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(strongSelf, selector);
    }];
    
    return cell;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    return self.titles[section];
}


#pragma mark -
#pragma mark - function

- (void)callback {
    // 亦可使用protocol的方式，请参阅sdk的callback头文件
    
    
    [OIMManager.callbacker setSelfUserInfoUpdateListener:^(OIMUserInfo * _Nullable userInfo) {
        
    }];
    
    [OIMManager.callbacker setConversationListenerWithOnSyncServerStart:^{
        
    } onSyncServerFinish:^{
        
    } onSyncServerFailed:^{
        
    } onConversationChanged:^(NSArray<OIMConversationInfo *> * _Nullable conversations) {
        
    } onNewConversation:^(NSArray<OIMConversationInfo *> * _Nullable conversations) {
        
    } onTotalUnreadMessageCountChanged:^(NSInteger number) {
        
    }];
    
    [OIMManager.callbacker setFriendListenerWithOnBlackAdded:^(OIMBlackInfo * _Nullable blackInfo) {
        
    } onBlackDeleted:^(OIMBlackInfo * _Nullable blackInfo) {
        
    } onFriendApplicationAccepted:^(OIMFriendApplication * _Nullable friendApplication) {
        
    } onFriendApplicationAdded:^(OIMFriendApplication * _Nullable friendApplication) {
        
    } onFriendApplicationDeleted:^(OIMFriendApplication * _Nullable friendApplication) {
        
    } onFriendApplicationRejected:^(OIMFriendApplication * _Nullable friendApplication) {
        
    } onFriendInfoChanged:^(OIMFriendInfo * _Nullable friendInfo) {
        
    } onFriendAdded:^(OIMFriendInfo * _Nullable friendInfo) {
        
    } onFriendDeleted:^(OIMFriendInfo * _Nullable friendInfo) {
        
    }];
    
    [OIMManager.callbacker setGroupListenerWithOnGroupInfoChanged:^(OIMGroupInfo * _Nullable groupInfo) {
        
    } onJoinedGroupAdded:^(OIMGroupInfo * _Nullable groupInfo) {
        
    } onJoinedGroupDeleted:^(OIMGroupInfo * _Nullable groupInfo) {
        
    } onGroupMemberAdded:^(OIMGroupMemberInfo * _Nullable groupMemberInfo) {
        
    } onGroupMemberDeleted:^(OIMGroupMemberInfo * _Nullable groupMemberInfo) {
        
    } onGroupMemberInfoChanged:^(OIMGroupMemberInfo * _Nullable groupMemberInfo) {
        
    } onGroupApplicationAdded:^(OIMGroupApplicationInfo * _Nullable groupApplication) {
        
    } onGroupApplicationDeleted:^(OIMGroupApplicationInfo * _Nullable groupApplication) {
        
    } onGroupApplicationAccepted:^(OIMGroupApplicationInfo * _Nullable groupApplication) {
        
    } onGroupApplicationRejected:^(OIMGroupApplicationInfo * _Nullable groupApplication) {
        
    }];
    
    [OIMManager.callbacker setAdvancedMsgListenerWithOnRecvMessageRevoked:^(NSString * _Nullable item) {
        
    } onRecvC2CReadReceipt:^(NSArray<OIMReceiptInfo *> * _Nullable msgReceiptList) {
        NSLog(@"onRecvC2CReadReceipt:%@", msgReceiptList);
    } onRecvGroupReadReceipt:^(NSArray<OIMReceiptInfo *> * _Nullable msgReceiptList) {
        NSLog(@"onRecvGroupReadReceipt:%@", msgReceiptList);
    } onRecvNewMessage:^(OIMMessageInfo * _Nullable message) {
        
    }];
}

- (void)initSDK {
    
    NSLog(@"\n\n-----初始化------");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths.firstObject stringByAppendingString:@"/"];
    
    BOOL initSuccess = [OIMManager.manager initSDK:iOS
                                           apiAdrr:API_ADDRESS
                                            wsAddr:WS_ADDRESS
                                           dataDir:path
                                          logLevel:6
                                     objectStorage:nil
                                      onConnecting:^{
        NSLog(@"\nconnecting");
    } onConnectFailure:^(NSInteger code, NSString * _Nullable msg) {
        NSLog(@"\n connect failure");
    } onConnectSuccess:^{
        NSLog(@"\nconnect success");
    } onKickedOffline:^{
        NSLog(@"\nkicked offline");
    } onUserTokenExpired:^{
        NSLog(@"\nuser token expired");
    }];
    
    NSLog(@"初始化成功与否：%d", initSuccess);
}

- (void)login {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        [OIMManager.manager login:LOGIN_USER_ID
                            token:LOGIN_USER_TOKEN
                        onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)logout {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        [OIMManager.manager logoutWithOnSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)loginStatus {
    NSLog(@"\n\n -----%@:%d ----- \n", NSStringFromSelector(_cmd), [OIMManager.manager getLoginStatus]);
}

- (void)getSelfInfo {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getSelfInfoWithOnSuccess:^(OIMUserInfo * _Nullable userInfo) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setSelfInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        OIMUserInfo *info = [OIMUserInfo new];
        info.nickname = LOGIN_USER_ID;
        info.email = @"qqx@qq.com";
        info.faceURL = @"https://img0.baidu.com/it/u=2359361020,2055583759&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400";
        
        [OIMManager.manager setSelfInfo:info
                              onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getUsersInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager getUsersInfo:@[OTHER_USER_ID]
                               onSuccess:^(NSArray<OIMUserInfo *> * _Nullable userInfos) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

#pragma mark -
#pragma mark - Friend

- (void)addFriend {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager addFriend:OTHER_USER_ID
                           reqMessage:@"添加一个好友呗"
                            onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getFriendApplicationList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getFriendApplicationListWithOnSuccess:^(NSArray<OIMFriendApplication *> * _Nullable friendApplications) {
        
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getSendFriendApplicationList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getSendFriendApplicationListWithOnSuccess:^(NSArray<OIMFriendApplication *> * _Nullable friendApplications) {
        
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)acceptFriendApplication {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager acceptFriendApplication:OTHER_USER_ID
                                          handleMsg:@"ok"
                                          onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)refuseFriendApplication {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager refuseFriendApplication:OTHER_USER_ID
                                          handleMsg:@"no"
                                          onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)addToBlackList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager addToBlackList:OTHER_USER_ID
                                 onSuccess:^(NSString * _Nullable data) {
        
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getBlackList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getBlackListWithOnSuccess:^(NSArray<OIMFullUserInfo *> * _Nullable userInfos) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)removeFromBlackList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager removeFromBlackList:OTHER_USER_ID
                                      onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getDesignatedFriendsInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getDesignatedFriendsInfo:@[OTHER_USER_ID]
                                           onSuccess:^(NSArray<OIMFullUserInfo *> * _Nullable userInfos) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getFriendList {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getFriendListWithOnSuccess:^(NSArray<OIMFullUserInfo *> * _Nullable userInfos) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)checkFriend {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager checkFriend:@[OTHER_USER_ID]
                              onSuccess:^(NSArray<OIMSimpleResultInfo *> * _Nullable results) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setFriendRemark {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager setFriendRemark:OTHER_USER_ID
                                     remark:@"玲子"
                                  onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)deleteFriend {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager deleteFriend:OTHER_USER_ID
                                  onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

#pragma mark -
#pragma mark - group

- (void)createGroup {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMGroupCreateInfo *t = [OIMGroupCreateInfo new];
        t.groupName = @"x的群";
        t.introduction = @"群的简介";
        
        OIMGroupMemberBaseInfo *m1 = [OIMGroupMemberBaseInfo new];
        m1.userID = OTHER_USER_ID;
        m1.roleLevel = OIMGroupMemberRoleMember;
        
        [OIMManager.manager createGroup:t
                             memberList:@[m1]
                              onSuccess:^(OIMGroupInfo * _Nullable groupInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)joinGroup {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager joinGroup:GROUP_ID
                               reqMsg:nil
                            onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)quitGroup {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager quitGroup:GROUP_ID
                            onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getJoinedGroupList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getJoinedGroupListWithOnSuccess:^(NSArray<OIMGroupInfo *> * _Nullable groupsInfo) {

            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getGroupsInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getGroupsInfo:@[GROUP_ID]
                                onSuccess:^(NSArray<OIMGroupInfo *> * _Nullable groupsInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setGroupInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMGroupBaseInfo *t = [OIMGroupBaseInfo new];
        t.introduction = @"这是一个大群";
        
        [OIMManager.manager setGroupInfo:GROUP_ID
                               groupInfo:t
                               onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getGroupMemberList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getGroupMemberList:GROUP_ID
                                        filter:0
                                        offset:0
                                         count:20
                                     onSuccess:^(NSArray<OIMGroupMemberInfo *> * _Nullable groupMembersInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getGroupMembersInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getGroupMembersInfo:GROUP_ID
                                           uids:@[OTHER_USER_ID]
                                      onSuccess:^(NSArray<OIMGroupMemberInfo *> * _Nullable groupMembersInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)kickGroupMember {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager kickGroupMember:GROUP_ID
                                     reason:@"没有理由"
                                       uids:@[OTHER_USER_ID]
                                  onSuccess:^(NSArray<OIMSimpleResultInfo *> * _Nullable results) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)transferGroupOwner {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager transferGroupOwner:GROUP_ID
                                      newOwner:OTHER_USER_ID
                                     onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)inviteUserToGroup {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager inviteUserToGroup:GROUP_ID
                                       reason:@"邀请不"
                                         uids:@[OTHER_USER_ID]
                                    onSuccess:^(NSArray<OIMSimpleResultInfo *> * _Nullable results) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getGroupApplicationList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getGroupApplicationListWithOnSuccess:^(NSArray<OIMGroupApplicationInfo *> * _Nullable groupsInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getSendGroupApplicationList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getSendGroupApplicationListWithOnSuccess:^(NSArray<OIMGroupApplicationInfo *> * _Nullable groupsInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)acceptGroupApplication {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager acceptGroupApplication:GROUP_ID
                                        fromUserId:OTHER_USER_ID
                                         handleMsg:@"ok"
                                         onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)refuseGroupApplication {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager refuseGroupApplication:GROUP_ID
                                        fromUserId:OTHER_USER_ID
                                         handleMsg:@"ok"
                                         onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)clearGroupHistoryMessage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager clearGroupHistoryMessage:GROUP_ID
                                           onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)dismissGroup {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager dismissGroup:GROUP_ID
                               onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

#pragma mark -
#pragma mark - Message

- (void)sendMessage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        self.testMessage = [OIMMessageInfo createTextMessage:[@"测试消息" stringByAppendingFormat:@"%d", arc4random() % 1000]];
        
//        self.testMessage = [OIMMessageInfo createTextAtMessage:@"" atUidList:@[]];
//        self.testMessage = [OIMMessageInfo createMergeMessage:@[] title:@"" summaryList:@[]];
//        self.testMessage = [OIMMessageInfo createForwardMessage:self.testMessage];
//        self.testMessage = [OIMMessageInfo createLocationMessage:@"" latitude:0 longitude:0];
//        self.testMessage = [OIMMessageInfo createCustomMessage:@"" extension:@"" description:@""];
//        self.testMessage = [OIMMessageInfo createQuoteMessage:@"" message:self.testMessage];
//        NSString *path1 = [[NSBundle mainBundle]pathForResource:@"photo_test" ofType:@"jpeg"];
//        self.testMessage = [OIMMessageInfo createImageMessageFromFullPath:path1];
//
//        NSString *path2 = [[NSBundle mainBundle]pathForResource:@"voice_test" ofType:@"m4a"];
//        self.testMessage = [OIMMessageInfo createSoundMessageFromFullPath:path2 duration:8];
//
//        NSString *path3 = [[NSBundle mainBundle]pathForResource:@"video_test" ofType:@"mp4"];
//        self.testMessage = [OIMMessageInfo createVideoMessageFromFullPath:path3 videoType:@"mp4" duration:43 snapshotPath:path1];
//
//        NSString *path4 = [[NSBundle mainBundle]pathForResource:@"file_test" ofType:@"zip"];
//        self.testMessage = [OIMMessageInfo createFileMessageFromFullPath:path4 fileName:@"file_test"];
        
        [OIMManager.manager sendMessage:self.testMessage
                                 recvID:OTHER_USER_ID
                                groupID:GROUP_ID
                        offlinePushInfo:nil
                              onSuccess:^(NSString * _Nullable data) {
            // 这里特别注意下，返回的这个message 需要替换创建的消息体。
            OIMMessageInfo *newMsg = [OIMMessageInfo mj_objectWithKeyValues:data];
            self.testMessage = newMsg;
            callback(nil, nil);
        } onProgress:^(NSInteger number) {
            NSLog(@"progress:%d", number);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getHistoryMessageList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getHistoryMessageListWithUserId:OTHER_USER_ID
                                                    groupID:nil
                                           startClientMsgID:nil
                                                      count:20
                                                  onSuccess:^(NSArray<OIMMessageInfo *> * _Nullable messages) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)revokeMessage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager revokeMessage:self.testMessage
                                onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)typingStatusUpdate {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager typingStatusUpdate:OTHER_USER_ID
                                        msgTip:@"正在输入消息"
                                     onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)markC2CMessageAsRead {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager markC2CMessageAsRead:OTHER_USER_ID
                                       msgIDList:@[]
                                       onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)deleteMessageFromLocalStorage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager deleteMessageFromLocalStorage:self.testMessage
                                                onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)clearC2CHistoryMessage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager clearC2CHistoryMessage:OTHER_USER_ID
                                         onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)insertSingleMessageToLocalStorage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager insertSingleMessageToLocalStorage:self.testMessage
                                                       recvID:OTHER_USER_ID
                                                       sendID:LOGIN_USER_ID
                                                    onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)insertGroupMessageToLocalStorage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMMessageInfo *t = [OIMMessageInfo createTextMessage:@"插入群消息到本地"];
        
        [OIMManager.manager insertGroupMessageToLocalStorage:t
                                                     groupID:GROUP_ID
                                                      sendID:LOGIN_USER_ID
                                                   onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)searchLocalMessages {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMSearchParam *t = [OIMSearchParam new];
        t.sourceID = OTHER_USER_ID;
        t.sessionType = 1;
        t.keywordList = @[@"x"];
        
        [OIMManager.manager searchLocalMessages:t
                                      onSuccess:^(OIMSearchResultInfo * _Nullable result) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

#pragma mark -
#pragma mark - conversation

- (void)getAllConversationList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getAllConversationListWithOnSuccess:^(NSArray<OIMConversationInfo *> * _Nullable conversations) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getConversationListSplit {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getConversationListSplitWithOffset:0
                                                         count:20
                                                     onSuccess:^(NSArray<OIMConversationInfo *> * _Nullable conversations) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getOneConversation {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getOneConversationWithSessionType:1
                                                     sourceID:OTHER_USER_ID
                                                    onSuccess:^(OIMConversationInfo * _Nullable conversation) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getMultipleConversation {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getMultipleConversation:@[CONVERSASTION_ID]
                                          onSuccess:^(NSArray<OIMConversationInfo *> * _Nullable conversations) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)deleteConversation {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager deleteConversation:CONVERSASTION_ID
                                     onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setConversationDraft {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager setConversationDraft:CONVERSASTION_ID
                                       draftText:@"草稿"
                                       onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)pinConversation {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager pinConversation:CONVERSASTION_ID
                                   isPinned:YES
                                  onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getTotalUnreadMsgCount {
    
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getTotalUnreadMsgCountWithOnSuccess:^(NSInteger number) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)markGroupMessageHasRead {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager markGroupMessageAsRead:GROUP_ID
                                         msgIDList:@[]
                                         onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getConversationRecvMessageOpt {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getConversationRecvMessageOpt:@[CONVERSASTION_ID]
                                                onSuccess:^(NSArray<OIMConversationNotDisturbInfo *> * _Nullable conversations) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setConversationRecvMessageOpt {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager setConversationRecvMessageOpt:@[CONVERSASTION_ID]
                                                   status:OIMReceiveMessageOptReceive
                                                onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

@end
