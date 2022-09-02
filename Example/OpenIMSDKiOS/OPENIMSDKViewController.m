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
#define API_ADDRESS         @"http://121.37.25.71:10002"
#define WS_ADDRESS          @"ws://121.37.25.71:10001"

#define LOGIN_USER_ID       @""
#define LOGIN_USER_TOKEN    @""
#define OTHER_USER_ID       @""

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
    
    self.titles = @[@"登陆", @"用户信息", @"好友", @"群", @"消息", @"会话", @"组织架构"];
    self.funcs = @[
        @[@{OIM_LIST_CELL_TITLE: @"登陆", OIM_LIST_CELL_FUNC: @"login"},
          @{OIM_LIST_CELL_TITLE: @"登陆状态", OIM_LIST_CELL_FUNC: @"loginStatus"},
          @{OIM_LIST_CELL_TITLE: @"登出", OIM_LIST_CELL_FUNC: @"logout"},
          @{OIM_LIST_CELL_TITLE: @"设置心跳", OIM_LIST_CELL_FUNC: @"setHeartbeatInterval"},
        ],
        
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
          @{OIM_LIST_CELL_TITLE: @"删除好友", OIM_LIST_CELL_FUNC: @"deleteFriend"},
          @{OIM_LIST_CELL_TITLE: @"本地查询好友", OIM_LIST_CELL_FUNC: @"searchFriends"}],
        
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
          @{OIM_LIST_CELL_TITLE: @"解散群", OIM_LIST_CELL_FUNC: @"clearGroupHistoryMessage"},
          @{OIM_LIST_CELL_TITLE: @"更改群成员禁言状态", OIM_LIST_CELL_FUNC: @"changeGroupMemberMute"},
          @{OIM_LIST_CELL_TITLE: @"更改群禁言状态", OIM_LIST_CELL_FUNC: @"changeGroupMute"},
          @{OIM_LIST_CELL_TITLE: @"搜索群", OIM_LIST_CELL_FUNC: @"searchGroups",},
          @{OIM_LIST_CELL_TITLE: @"设置群昵称", OIM_LIST_CELL_FUNC: @"setGroupMemberNickname",},
          @{OIM_LIST_CELL_TITLE: @"设置群成员级别", OIM_LIST_CELL_FUNC: @"setGroupMemberRoleLevel",},
          @{OIM_LIST_CELL_TITLE: @"根据加入时间分页获取组成员列表", OIM_LIST_CELL_FUNC: @"getGroupMemberListByJoinTimeFilter",},
          @{OIM_LIST_CELL_TITLE: @"设置进群方式", OIM_LIST_CELL_FUNC: @"setGroupVerification",},
          @{OIM_LIST_CELL_TITLE: @"获取群主和管理员", OIM_LIST_CELL_FUNC: @"getGroupMemberOwnerAndAdmin",},
          @{OIM_LIST_CELL_TITLE: @"群成员间是否可加好友", OIM_LIST_CELL_FUNC: @"setGroupApplyMemberFriend",},
          @{OIM_LIST_CELL_TITLE: @"群成员间是否可查看信息", OIM_LIST_CELL_FUNC: @"setGroupLookMemberInfo",},
        ],
        
        @[@{OIM_LIST_CELL_TITLE: @"发送消息", OIM_LIST_CELL_FUNC: @"sendMessage"},
          @{OIM_LIST_CELL_TITLE: @"获取聊天历史", OIM_LIST_CELL_FUNC: @"getHistoryMessageList"},
          @{OIM_LIST_CELL_TITLE: @"获取反向聊天历史", OIM_LIST_CELL_FUNC: @"getHistoryMessageListReverse"},
          @{OIM_LIST_CELL_TITLE: @"撤销消息", OIM_LIST_CELL_FUNC: @"revokeMessage"},
          @{OIM_LIST_CELL_TITLE: @"输入状态", OIM_LIST_CELL_FUNC: @"typingStatusUpdate"},
          @{OIM_LIST_CELL_TITLE: @"单聊已读", OIM_LIST_CELL_FUNC: @"markC2CMessageAsRead"},
          @{OIM_LIST_CELL_TITLE: @"清空单聊消息", OIM_LIST_CELL_FUNC: @"clearC2CHistoryMessage"},
          @{OIM_LIST_CELL_TITLE: @"清空单聊本地/远端消息", OIM_LIST_CELL_FUNC: @"clearC2CHistoryMessageFromLocalAndSvr"},
          @{OIM_LIST_CELL_TITLE: @"清空群聊本地/远端消息", OIM_LIST_CELL_FUNC: @"clearGroupHistoryMessageFromLocalAndSvr"},
          @{OIM_LIST_CELL_TITLE: @"本地插入消息", OIM_LIST_CELL_FUNC: @"insertSingleMessageToLocalStorage",},
          @{OIM_LIST_CELL_TITLE: @"删除本地所有消息", OIM_LIST_CELL_FUNC: @"deleteAllMsgFromLocal",},
          @{OIM_LIST_CELL_TITLE: @"删除本地和远端所有消息", OIM_LIST_CELL_FUNC: @"deleteAllMsgFromLocalAndSvr",},
          @{OIM_LIST_CELL_TITLE: @"上传多媒体文件", OIM_LIST_CELL_FUNC: @"uploadFile",},
          @{OIM_LIST_CELL_TITLE: @"设置全局消息接收情况", OIM_LIST_CELL_FUNC: @"setGlobalRecvMessageOpt",},
        ],
        
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
          @{OIM_LIST_CELL_TITLE: @"查找本地消息", OIM_LIST_CELL_FUNC: @"searchLocalMessages"},
          @{OIM_LIST_CELL_TITLE: @"删除本地所有会话", OIM_LIST_CELL_FUNC: @"deleteAllConversationFromLocal"},
          @{OIM_LIST_CELL_TITLE: @"重置会话at标准位", OIM_LIST_CELL_FUNC: @"resetConversationGroupAtType"},],
        
        @[@{OIM_LIST_CELL_TITLE: @"获取子部门列表", OIM_LIST_CELL_FUNC: @"getSubDepartment"},
          @{OIM_LIST_CELL_TITLE: @"获取父部门列表", OIM_LIST_CELL_FUNC: @"getParentDepartment"},
          @{OIM_LIST_CELL_TITLE: @"获取部门成员信息", OIM_LIST_CELL_FUNC: @"getDepartmentMember"},
          @{OIM_LIST_CELL_TITLE: @"获取用户在所有部门信息", OIM_LIST_CELL_FUNC: @"getUserInDepartment"},
          @{OIM_LIST_CELL_TITLE: @"获取子部门信息和部门成员信息", OIM_LIST_CELL_FUNC: @"getDepartmentMemberAndSubDepartment"},
          @{OIM_LIST_CELL_TITLE: @"获取部门信息", OIM_LIST_CELL_FUNC: @"getDepartmentInfo"},
          @{OIM_LIST_CELL_TITLE: @"搜索组织架构", OIM_LIST_CELL_FUNC: @"searchOrganization"},],
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
        
    } onNewRecvMessageRevoked:^(OIMMessageRevoked * _Nullable msgRovoked) {
        
    }];
}

- (void)initSDK {
    
    NSLog(@"\n\n-----初始化------");
    
    BOOL initSuccess = [OIMManager.manager initSDKWithApiAdrr:API_ADDRESS
                                                       wsAddr:WS_ADDRESS
                                                      dataDir:nil
                                                     logLevel:6
                                                objectStorage:@"minio"
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
            
            [OIMManager.manager wakeUpWithOnSuccess:^(NSString * _Nullable data) {
                NSLog(@"data");
            } onFailure:^(NSInteger code, NSString * _Nullable msg) {
                NSLog(@"msg");
            }];
            
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

- (void)setHeartbeatInterval {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager setHeartbeatInterval:30];
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


- (void)searchFriends {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMSearchUserParam *t = [OIMSearchUserParam new];
        t.keywordList = @[@"x2"];
        t.isSearchRemark = YES;
        t.isSearchUserID = YES;
        
        [OIMManager.manager searchFriends:t
                              onSuccess:^(NSArray<OIMSearchUserInfo *> * _Nullable usersInfo) {
            
        
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

- (void)changeGroupMemberMute {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager changeGroupMemberMute:GROUP_ID
                                           userID:OTHER_USER_ID
                                     mutedSeconds:1
                                        onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)changeGroupMute {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager changeGroupMute:GROUP_ID
                                     isMute:YES
                                  onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)searchGroups {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMSearchGroupParam *param = [OIMSearchGroupParam new];
        param.isSearchGroupName = YES;
        param.keywordList = @[@"test"];
        
        [OIMManager.manager searchGroups:param
                               onSuccess:^(NSArray<OIMGroupInfo *> * _Nullable groupsInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setGroupMemberNickname {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager setGroupMemberNickname:GROUP_ID
                                            userID:OTHER_USER_ID
                                     groupNickname:@"群昵称"
                                         onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setGroupMemberRoleLevel {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager setGroupMemberRoleLevel:GROUP_ID
                                             userID:OTHER_USER_ID
                                          roleLevel:OIMGroupMemberRoleAdmin
                                          onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getGroupMemberListByJoinTimeFilter {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager getGroupMemberListByJoinTimeFilter:GROUP_ID
                                                        offset:0
                                                         count:100
                                                 joinTimeBegin:[NSDate new].timeIntervalSince1970
                                                   joinTimeEnd:[NSDate new].timeIntervalSince1970
                                              filterUserIDList:@[]
                                                     onSuccess:^(NSArray<OIMGroupMemberInfo *> * _Nullable groupMembersInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setGroupVerification {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager setGroupVerification:GROUP_ID
                                needVerification:OIMGroupVerificationTypeDirectly
                                       onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getGroupMemberOwnerAndAdmin {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager getGroupMemberOwnerAndAdmin:GROUP_ID
                                              onSuccess:^(NSArray<OIMGroupMemberInfo *> * _Nullable groupMembersInfo) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setGroupApplyMemberFriend {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager setGroupApplyMemberFriend:GROUP_ID
                                                 rule:0
                                            onSuccess:^(NSString * _Nullable data) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setGroupLookMemberInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager setGroupLookMemberInfo:GROUP_ID
                                              rule:0
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
//        OIMAtInfo *t = [OIMAtInfo new];
//        t.atUserID = OTHER_USER_ID;
//        t.groupNickname = @"x2";
//        self.testMessage = [OIMMessageInfo createTextAtMessage:@"一条消息" atUidList:@[] atUsersInfo:@[t] message:nil];
        
//        OIMMessageEntity *e1 = [OIMMessageEntity new];
//        OIMMessageEntity *e2 = [OIMMessageEntity new];
//        
//        self.testMessage = [OIMMessageInfo createAdvancedTextMessage:@"text" messageEntityList:@[e1, e2]];
        
        [OIMManager.manager sendMessage:self.testMessage
                                 recvID:OTHER_USER_ID
                                groupID:GROUP_ID
                        offlinePushInfo:nil
                              onSuccess:^(OIMMessageInfo * _Nullable message) {
            // 这里特别注意下，返回的这个message 需要替换数据源。
            self.testMessage = message;
            callback(nil, nil);
        } onProgress:^(NSInteger number) {
            NSLog(@"progress:%zd", number);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
        
        /* 不使用sdk的文件上传
        OIMPictureInfo *pic = [OIMPictureInfo new];
        pic.url = @"xxx";
        
        self.testMessage = [OIMMessageInfo createImageMessageByURL:pic bigPicture:pic snapshotPicture:pic];
        self.testMessage = [OIMMessageInfo createSoundMessageByURL:@"xxx"
                                                          duration:10
                                                              size:100];
        self.testMessage = [OIMMessageInfo createVideoMessageByURL:@"xxx"
                                                         videoType:@"mp4"
                                                          duration:10
                                                              size:100
                                                          snapshot:@"https://c-ssl.duitang.com/uploads/item/202105/29/20210529001057_aSeLB.jpeg"];
        [OIMManager.manager sendMessageNotOss:self.testMessage
                                       recvID:OTHER_USER_ID
                                      groupID:GROUP_ID
                              offlinePushInfo:nil
                                    onSuccess:^(OIMMessageInfo * _Nullable message) {
            self.testMessage = message;
                        callback(nil, nil);
        } onProgress:^(NSInteger number) {
            
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
         */
    }];
}

- (void)getHistoryMessageList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager getHistoryMessageList:CONVERSASTION_ID
                                           userId:OTHER_USER_ID
                                          groupID:GROUP_ID
                                 startClientMsgID:nil
                                            count:20
                                        onSuccess:^(NSArray<OIMMessageInfo *> * _Nullable messages) {
            
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            
        }];
       
        [OIMManager.manager getHistoryMessageListWithUserId:OTHER_USER_ID
                                                    groupID:GROUP_ID
                                           startClientMsgID:nil
                                                      count:20
                                                  onSuccess:^(NSArray<OIMMessageInfo *> * _Nullable messages) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
    
    
}

- (void)getHistoryMessageListReverse {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMGetMessageOptions *options = [OIMGetMessageOptions new];
        options.userID = OTHER_USER_ID;
        options.groupID = GROUP_ID;
        options.conversationID = CONVERSASTION_ID;
        
        [OIMManager.manager getHistoryMessageListReverse:options
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
        
        [OIMManager.manager newRevokeMessage:self.testMessage
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
                                                    onSuccess:^(OIMMessageInfo * _Nullable message) {
            
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
                                                   onSuccess:^(OIMMessageInfo * _Nullable message) {
            
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
        t.conversationID = CONVERSASTION_ID;
        t.keywordList = @[@"x"];
        
        [OIMManager.manager searchLocalMessages:t
                                      onSuccess:^(OIMSearchResultInfo * _Nullable result) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)deleteAllMsgFromLocal {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager deleteAllMsgFromLocalWithOnSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)deleteAllMsgFromLocalAndSvr {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager deleteAllMsgFromLocalAndSvrWithOnSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)clearC2CHistoryMessageFromLocalAndSvr {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager clearC2CHistoryMessageFromLocalAndSvr:OTHER_USER_ID
                                                          onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)clearGroupHistoryMessageFromLocalAndSvr {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager clearGroupHistoryMessageFromLocalAndSvr:GROUP_ID
                                                          onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)uploadFile {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager uploadFileWithFullPath:[[NSBundle mainBundle]pathForResource:@"file_test.zip" ofType:nil]
                                         onProgress:^(NSInteger number) {
            NSLog(@"progress:%zd", number);
        } onSuccess:^(NSString * _Nullable data) {
            NSLog(@"upload success:%@", data);
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)setGlobalRecvMessageOpt {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager setGlobalRecvMessageOpt:OIMReceiveMessageOptNotReceive
                                          onSuccess:^(NSString * _Nullable data) {
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

- (void)deleteAllConversationFromLocal {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager deleteAllConversationFromLocalWithOnSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)resetConversationGroupAtType {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager resetConversationGroupAtType:CONVERSASTION_ID
                                               onSuccess:^(NSString * _Nullable data) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

#pragma mark -
#pragma mark - Organization

- (void)getSubDepartment {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getSubDepartment:@""
                                      offset:0
                                       count:100
                                   onSuccess:^(NSArray<OIMDepartmentInfo *> * _Nullable departmentList) {
    
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getParentDepartment {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getParentDepartment:@""
                                      offset:0
                                       count:100
                                   onSuccess:^(NSArray<OIMDepartmentInfo *> * _Nullable departmentList) {
    
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getDepartmentMember {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getDepartmentMember:@""
                                         offset:0
                                          count:100
                                      onSuccess:^(NSArray<OIMDepartmentMemberInfo *> * _Nullable members) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getUserInDepartment {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getUserInDepartment:@""
                                      onSuccess:^(NSArray<OIMUserInDepartmentInfo *> * _Nullable members) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getDepartmentMemberAndSubDepartment {
    
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getDepartmentMemberAndSubDepartment:@""
                                                      onSuccess:^(OIMDepartmentMemberAndSubInfo * _Nullable items) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getDepartmentInfo {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        [OIMManager.manager getDepartmentInfo:@""
                                    onSuccess:^(NSArray<OIMDepartmentInfo *> * _Nullable departmentList) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)searchOrganization {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
       
        OIMSearchOrganizationParam *param = [OIMSearchOrganizationParam new];
        param.keyword = @"";
        param.isSearchUserName = YES;
        
        [OIMManager.manager searchOrganization:param
                                        offset:0
                                         count:100
                                     onSuccess:^(OIMDepartmentMemberAndSubInfo * _Nullable items) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

@end
