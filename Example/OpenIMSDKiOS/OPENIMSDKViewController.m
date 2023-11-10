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
 * The port is fixed, do not modify.
 * LOGIN_USER_ID is generated after registration.
 * LOGIN_USER_TOKEN is generated after registration.
 * OTHER_USER_ID is generated after registration.
 * GROUP_ID is generated after creating a group.
 * CONVERSATION_ID is generated after having a conversation.
 * Note: Some APIs only allow setting either other_user_id or group_id, not both, for example when sending messages.
 */
#define API_ADDRESS         @"http://x:10002"
#define WS_ADDRESS          @"ws://x:10001"

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
    
    self.titles = @[@"Login", @"User Information", @"Friends", @"Groups", @"Messages", @"Conversations"];

    self.funcs = @[
        @[@{OIM_LIST_CELL_TITLE: @"Login", OIM_LIST_CELL_FUNC: @"login"},
          @{OIM_LIST_CELL_TITLE: @"Login Status", OIM_LIST_CELL_FUNC: @"loginStatus"},
          @{OIM_LIST_CELL_TITLE: @"Logout", OIM_LIST_CELL_FUNC: @"logout"},
          @{OIM_LIST_CELL_TITLE: @"Set Heartbeat", OIM_LIST_CELL_FUNC: @"setHeartbeatInterval"},
        ],
        
        @[@{OIM_LIST_CELL_TITLE: @"Get User Info", OIM_LIST_CELL_FUNC: @"getSelfInfo"},
          @{OIM_LIST_CELL_TITLE: @"Modify User Info", OIM_LIST_CELL_FUNC: @"setSelfInfo"},
          @{OIM_LIST_CELL_TITLE: @"Get Specific User Info", OIM_LIST_CELL_FUNC: @"getUsersInfo"}],
        
        @[@{OIM_LIST_CELL_TITLE: @"Add Friend", OIM_LIST_CELL_FUNC: @"addFriend"},
          @{OIM_LIST_CELL_TITLE: @"Get Friend Application List", OIM_LIST_CELL_FUNC: @"getFriendApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"Get Sent Friend Application List", OIM_LIST_CELL_FUNC: @"getSendFriendApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"Accept Friend Application", OIM_LIST_CELL_FUNC: @"acceptFriendApplication"},
          @{OIM_LIST_CELL_TITLE: @"Refuse Friend Application", OIM_LIST_CELL_FUNC: @"refuseFriendApplication"},
          @{OIM_LIST_CELL_TITLE: @"Add to Blacklist", OIM_LIST_CELL_FUNC: @"addToBlackList"},
          @{OIM_LIST_CELL_TITLE: @"Blacklist", OIM_LIST_CELL_FUNC: @"getBlackList"},
          @{OIM_LIST_CELL_TITLE: @"Remove from Blacklist", OIM_LIST_CELL_FUNC: @"removeFromBlackList"},
          @{OIM_LIST_CELL_TITLE: @"Get Specific Friend Info", OIM_LIST_CELL_FUNC: @"getDesignatedFriendsInfo"},
          @{OIM_LIST_CELL_TITLE: @"Get Friend List", OIM_LIST_CELL_FUNC: @"getFriendList"},
          @{OIM_LIST_CELL_TITLE: @"Check Friend Relationship", OIM_LIST_CELL_FUNC: @"checkFriend"},
          @{OIM_LIST_CELL_TITLE: @"Set Friend Remark", OIM_LIST_CELL_FUNC: @"setFriendRemark"},
          @{OIM_LIST_CELL_TITLE: @"Delete Friend", OIM_LIST_CELL_FUNC: @"deleteFriend"},
          @{OIM_LIST_CELL_TITLE: @"Local Search for Friends", OIM_LIST_CELL_FUNC: @"searchFriends"}],
        
        @[@{OIM_LIST_CELL_TITLE: @"Create Group Chat", OIM_LIST_CELL_FUNC: @"createGroup"},
          @{OIM_LIST_CELL_TITLE: @"Join Group Chat", OIM_LIST_CELL_FUNC: @"joinGroup"},
          @{OIM_LIST_CELL_TITLE: @"Leave Group Chat", OIM_LIST_CELL_FUNC: @"quitGroup"},
          @{OIM_LIST_CELL_TITLE: @"Group List", OIM_LIST_CELL_FUNC: @"getJoinedGroupList"},
          @{OIM_LIST_CELL_TITLE: @"Get Specific Group Information", OIM_LIST_CELL_FUNC: @"getGroupsInfo"},
          @{OIM_LIST_CELL_TITLE: @"Set Group Information", OIM_LIST_CELL_FUNC: @"setGroupInfo"},
          @{OIM_LIST_CELL_TITLE: @"Get Group Member List", OIM_LIST_CELL_FUNC: @"getGroupMemberList"},
          @{OIM_LIST_CELL_TITLE: @"Get Specific Group Member List", OIM_LIST_CELL_FUNC: @"getGroupMembersInfo"},
          @{OIM_LIST_CELL_TITLE: @"Remove Group Member", OIM_LIST_CELL_FUNC: @"kickGroupMember"},
          @{OIM_LIST_CELL_TITLE: @"Transfer Group Ownership", OIM_LIST_CELL_FUNC: @"transferGroupOwner"},
          @{OIM_LIST_CELL_TITLE: @"Invite Users to Group", OIM_LIST_CELL_FUNC: @"inviteUserToGroup"},
          @{OIM_LIST_CELL_TITLE: @"Get Group Join Requests", OIM_LIST_CELL_FUNC: @"getGroupApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"Get Sent Group Join Requests", OIM_LIST_CELL_FUNC: @"getSendGroupApplicationList"},
          @{OIM_LIST_CELL_TITLE: @"Accept Someone to Group", OIM_LIST_CELL_FUNC: @"acceptGroupApplication"},
          @{OIM_LIST_CELL_TITLE: @"Reject Someone from Group", OIM_LIST_CELL_FUNC: @"refuseGroupApplication"},
          @{OIM_LIST_CELL_TITLE: @"Clear Group Chat History", OIM_LIST_CELL_FUNC: @"clearGroupHistoryMessage"},
          @{OIM_LIST_CELL_TITLE: @"Dissolve Group", OIM_LIST_CELL_FUNC: @"clearGroupHistoryMessage"},
          @{OIM_LIST_CELL_TITLE: @"Change Group Member Mute Status", OIM_LIST_CELL_FUNC: @"changeGroupMemberMute"},
          @{OIM_LIST_CELL_TITLE: @"Change Group Mute Status", OIM_LIST_CELL_FUNC: @"changeGroupMute"},
          @{OIM_LIST_CELL_TITLE: @"Search for Groups", OIM_LIST_CELL_FUNC: @"searchGroups"},
          @{OIM_LIST_CELL_TITLE: @"Set Group Nickname", OIM_LIST_CELL_FUNC: @"setGroupMemberNickname"},
          @{OIM_LIST_CELL_TITLE: @"Set Group Member Role Level", OIM_LIST_CELL_FUNC: @"setGroupMemberRoleLevel"},
          @{OIM_LIST_CELL_TITLE: @"Get Group Members by Join Time", OIM_LIST_CELL_FUNC: @"getGroupMemberListByJoinTimeFilter"},
          @{OIM_LIST_CELL_TITLE: @"Set Group Entry Mode", OIM_LIST_CELL_FUNC: @"setGroupVerification"},
          @{OIM_LIST_CELL_TITLE: @"Get Group Owners and Admins", OIM_LIST_CELL_FUNC: @"getGroupMemberOwnerAndAdmin"},
          @{OIM_LIST_CELL_TITLE: @"Allow Adding Friends Among Group Members", OIM_LIST_CELL_FUNC: @"setGroupApplyMemberFriend"},
          @{OIM_LIST_CELL_TITLE: @"Allow Viewing Information Among Group Members", OIM_LIST_CELL_FUNC: @"setGroupLookMemberInfo"},
        ],
        
        @[@{OIM_LIST_CELL_TITLE: @"Send Message", OIM_LIST_CELL_FUNC: @"sendMessage"},
          @{OIM_LIST_CELL_TITLE: @"Get Chat History", OIM_LIST_CELL_FUNC: @"getHistoryMessageList"},
          @{OIM_LIST_CELL_TITLE: @"Get Reverse Chat History", OIM_LIST_CELL_FUNC: @"getHistoryMessageListReverse"},
          @{OIM_LIST_CELL_TITLE: @"Revoke Message", OIM_LIST_CELL_FUNC: @"revokeMessage"},
          @{OIM_LIST_CELL_TITLE: @"Typing Status", OIM_LIST_CELL_FUNC: @"typingStatusUpdate"},
          @{OIM_LIST_CELL_TITLE: @"Mark Single Chat as Read", OIM_LIST_CELL_FUNC: @"markC2CMessageAsRead"},
          @{OIM_LIST_CELL_TITLE: @"Clear Single Chat Messages", OIM_LIST_CELL_FUNC: @"clearC2CHistoryMessage"},
          @{OIM_LIST_CELL_TITLE: @"Clear Local/Remote Single Chat Messages", OIM_LIST_CELL_FUNC: @"clearC2CHistoryMessageFromLocalAndSvr"},
          @{OIM_LIST_CELL_TITLE: @"Clear Local/Remote Group Chat Messages", OIM_LIST_CELL_FUNC: @"clearGroupHistoryMessageFromLocalAndSvr"},
          @{OIM_LIST_CELL_TITLE: @"Insert Local Message", OIM_LIST_CELL_FUNC: @"insertSingleMessageToLocalStorage"},
          @{OIM_LIST_CELL_TITLE: @"Delete All Local Messages", OIM_LIST_CELL_FUNC: @"deleteAllMsgFromLocal"},
          @{OIM_LIST_CELL_TITLE: @"Delete All Local and Remote Messages", OIM_LIST_CELL_FUNC: @"deleteAllMsgFromLocalAndSvr"},
          @{OIM_LIST_CELL_TITLE: @"Upload Media Files", OIM_LIST_CELL_FUNC: @"uploadFile"},
          @{OIM_LIST_CELL_TITLE: @"Set Global Message Receive Options", OIM_LIST_CELL_FUNC: @"setGlobalRecvMessageOpt"},
        ],
        
        @[@{OIM_LIST_CELL_TITLE: @"Conversation List", OIM_LIST_CELL_FUNC: @"getAllConversationList"},
          @{OIM_LIST_CELL_TITLE: @"Get Conversation List by Page", OIM_LIST_CELL_FUNC: @"getConversationListSplit"},
          @{OIM_LIST_CELL_TITLE: @"Get a Single Conversation", OIM_LIST_CELL_FUNC: @"getOneConversation"},
          @{OIM_LIST_CELL_TITLE: @"Get Multiple Conversations", OIM_LIST_CELL_FUNC: @"getMultipleConversation"},
          @{OIM_LIST_CELL_TITLE: @"Delete Conversation", OIM_LIST_CELL_FUNC: @"deleteConversation"},
          @{OIM_LIST_CELL_TITLE: @"Set Conversation Draft", OIM_LIST_CELL_FUNC: @"setConversationDraft"},
          @{OIM_LIST_CELL_TITLE: @"Pin Conversation", OIM_LIST_CELL_FUNC: @"pinConversation"},
          @{OIM_LIST_CELL_TITLE: @"Get Unread Message Count", OIM_LIST_CELL_FUNC: @"getTotalUnreadMsgCount"},
          @{OIM_LIST_CELL_TITLE: @"Mark as Read", OIM_LIST_CELL_FUNC: @"markGroupMessageHasRead"},
          @{OIM_LIST_CELL_TITLE: @"Do Not Disturb Status", OIM_LIST_CELL_FUNC: @"getConversationRecvMessageOpt"},
          @{OIM_LIST_CELL_TITLE: @"Set Do Not Disturb", OIM_LIST_CELL_FUNC: @"setConversationRecvMessageOpt"},
          @{OIM_LIST_CELL_TITLE: @"Insert Group Message Locally", OIM_LIST_CELL_FUNC: @"insertGroupMessageToLocalStorage"},
          @{OIM_LIST_CELL_TITLE: @"Search Local Messages", OIM_LIST_CELL_FUNC: @"searchLocalMessages"},
          @{OIM_LIST_CELL_TITLE: @"Delete All Local Conversations", OIM_LIST_CELL_FUNC: @"deleteAllConversationFromLocal"},
          @{OIM_LIST_CELL_TITLE: @"Reset Conversation Group At Type", OIM_LIST_CELL_FUNC: @"resetConversationGroupAtType"}]
        
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
    
    [cell.funcButton setTitle:[@"Touch me" stringByAppendingString:item[OIM_LIST_CELL_TITLE]] forState:UIControlStateNormal];
    
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
    //You can also use the protocol method, please refer to the callback header file of the sdk
    
    [OIMManager.callbacker setUserListenerWithUserInfoUpdate:^(OIMUserInfo * _Nullable userInfo) {
        
    } onUserStatusChanged:^(OIMUserStatusInfo * _Nullable statusInfo) {
        
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
    
    
    [OIMManager.callbacker setAdvancedMsgListenerWithOnRecvMessageRevoked:^(OIMMessageRevokedInfo * _Nullable msgRovoked) {
        
    } onRecvC2CReadReceipt:^(NSArray<OIMReceiptInfo *> * _Nullable msgReceiptList) {
        
    } onRecvGroupReadReceipt:^(NSArray<OIMReceiptInfo *> * _Nullable msgReceiptList) {
        
    } onRecvNewMessage:^(OIMMessageInfo * _Nullable message) {
        
    }];
}

- (void)initSDK {
    OIMInitConfig *config = [OIMInitConfig new];
    config.apiAddr = @"";
    config.wsAddr = @"";
    
    BOOL success = [OIMManager.manager initSDKWithConfig:config
                                            onConnecting:^{
        
    } onConnectFailure:^(NSInteger code, NSString * _Nullable msg) {
        
    } onConnectSuccess:^{
        
    } onKickedOffline:^{
        
    } onUserTokenExpired:^{
        
    }];
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
        info.faceURL = @"xxx";
        
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
                           reqMessage:@"your message"
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
        
        [OIMManager.manager getFriendApplicationListAsRecipientWithOnSuccess:^(NSArray<OIMFriendApplication *> * _Nullable friendApplications) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getSendFriendApplicationList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager getFriendApplicationListAsApplicantWithOnSuccess:^(NSArray<OIMFriendApplication *> * _Nullable friendApplications) {
            
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
        
        [OIMManager.manager getBlackListWithOnSuccess:^(NSArray<OIMBlackInfo *> * _Nullable blackInfo) {
            
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
        
        [OIMManager.manager getSpecifiedFriendsInfo:@[OTHER_USER_ID]
                                          onSuccess:^(NSArray<OIMFriendInfo *> * _Nullable friendInfo) {
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
                                     remark:@"remark"
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
        
        OIMSearchFriendsParam *t = [OIMSearchFriendsParam new];
        t.keywordList = @[@"x2"];
        t.isSearchRemark = YES;
        t.isSearchUserID = YES;
        
        [OIMManager.manager searchFriends:t
                                onSuccess:^(NSArray<OIMSearchFriendsInfo *> * _Nullable usersInfo) {
            
            
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
        t.ownerUserID = LOGIN_USER_ID;
        t.memberUserIDs = @[OTHER_USER_ID];
        
        [OIMManager.manager createGroup:t
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
                           joinSource:OIMJoinTypeSearch
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
        
        [OIMManager.manager getSpecifiedGroupsInfo:@[GROUP_ID]
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
        
        OIMGroupInfo *t = [OIMGroupInfo new];
        t.introduction = @"this is a super group";
        
        [OIMManager.manager setGroupInfo:t
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
        
        [OIMManager.manager getSpecifiedGroupMembersInfo:GROUP_ID
                                                 usersID:@[OTHER_USER_ID]
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
                                     reason:@"nothing"
                                    usersID:@[OTHER_USER_ID]
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
                                       reason:@"reason"
                                      usersID:@[OTHER_USER_ID]
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
        
        [OIMManager.manager getGroupApplicationListAsRecipientWithOnSuccess:^(NSArray<OIMGroupApplicationInfo *> * _Nullable groupsInfo) {
            
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)getSendGroupApplicationList {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        [OIMManager.manager getGroupApplicationListAsApplicantWithOnSuccess:^(NSArray<OIMGroupApplicationInfo *> * _Nullable groupsInfo) {
            
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
        
        [OIMManager.manager clearConversationAndDeleteAllMsg:CONVERSASTION_ID
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
                                     groupNickname:@"group nick name"
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
        
        self.testMessage = [OIMMessageInfo createTextMessage:[@"test message" stringByAppendingFormat:@"%d", arc4random() % 1000]];
//        OIMMessageInfo *message = [OIMMessageInfo createTextAtAllMessage:@""
//                                                             displayText:nil
//                                                                 message:nil];
//        [OIMMessageInfo createImageMessage:@"/xxx.png"];
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
        //        self.testMessage = [OIMMessageInfo createTextAtMessage:@"message" atUidList:@[] atUsersInfo:@[t] message:nil];
        
        //        OIMMessageEntity *e1 = [OIMMessageEntity new];
        //        OIMMessageEntity *e2 = [OIMMessageEntity new];
        //
        //        self.testMessage = [OIMMessageInfo createAdvancedTextMessage:@"text" messageEntityList:@[e1, e2]];
        
        [OIMManager.manager sendMessage:self.testMessage
                                 recvID:OTHER_USER_ID
                                groupID:GROUP_ID
                        offlinePushInfo:nil
                              onSuccess:^(OIMMessageInfo * _Nullable message) {
            // Please pay special attention here, the returned 'message' needs to be replaced with the data source.
            self.testMessage = message;
            callback(nil, nil);
        } onProgress:^(NSInteger number) {
            NSLog(@"progress:%zd", number);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
        
        /* File upload without sdk
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
        OIMGetAdvancedHistoryMessageListParam *param = [OIMGetAdvancedHistoryMessageListParam new];
        param.conversationID = CONVERSASTION_ID;
        param.lastMinSeq = 0;
        param.startClientMsgID = @"xxx";
        param.count = 100;
        
        [OIMManager.manager getAdvancedHistoryMessageList:param
                                                onSuccess:^(OIMGetAdvancedHistoryMessageListInfo * _Nullable result) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
    
    
}

- (void)getHistoryMessageListReverse {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        
        OIMGetAdvancedHistoryMessageListParam *param = [OIMGetAdvancedHistoryMessageListParam new];
        param.conversationID = CONVERSASTION_ID;
        param.lastMinSeq = 0;
        param.startClientMsgID = @"xxx";
        param.count = 100;
        
        [OIMManager.manager getAdvancedHistoryMessageListReverse:param
                                                       onSuccess:^(OIMGetAdvancedHistoryMessageListInfo * _Nullable result) {
            callback(nil, nil);
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            callback(@(code), msg);
        }];
    }];
}

- (void)revokeMessage {
    [self operate:_cmd
             todo:^(void (^callback)(NSNumber *code, NSString *msg)) {
        [OIMManager.manager revokeMessage:CONVERSASTION_ID
                              clientMsgID:@""
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
                                        msgTip:@"typing"
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
        
        [OIMManager.manager markConversationMessageAsRead:CONVERSASTION_ID
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
        
        [OIMManager.manager deleteMessageFromLocalStorage:CONVERSASTION_ID
                                              clientMsgID:@""
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
        
        [OIMManager.manager clearConversationAndDeleteAllMsg:CONVERSASTION_ID
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
        
        OIMMessageInfo *t = [OIMMessageInfo createTextMessage:@"text message"];
        
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
        
        [OIMManager.manager clearConversationAndDeleteAllMsg:CONVERSASTION_ID
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
        
        [OIMManager.manager clearConversationAndDeleteAllMsg:CONVERSASTION_ID
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
        [OIMManager.manager uploadFile:[[NSBundle mainBundle]pathForResource:@"file_test.zip" ofType:nil]
                                  name:nil
                                 cause:nil
                            onProgress:^(NSInteger saveBytes, NSInteger currentBytes, NSInteger totalBytes) {
            
        } onCompletion:^(NSInteger totalBytes, NSString * _Nonnull url, NSInteger putType) {
            
        } onSuccess:^(NSString * _Nullable data) {
            
        } onFailure:^(NSInteger code, NSString * _Nullable msg) {
            
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
        
        [OIMManager.manager deleteConversationAndDeleteAllMsg:CONVERSASTION_ID
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
                                       draftText:@"draft"
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
        
        [OIMManager.manager markConversationMessageAsRead:CONVERSASTION_ID
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
        [OIMManager.manager setConversationRecvMessageOpt:CONVERSASTION_ID
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
        [OIMManager.manager hideConversation:CONVERSASTION_ID
                                   onSuccess:^(NSString * _Nullable data) {
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

@end
