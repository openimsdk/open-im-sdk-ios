//
//  OIMManager+Group.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+Group.h"
#import "CallbackProxy.h"

@implementation OIMManager (Group)

- (void)createGroup:(OIMGroupCreateInfo *)groupBaseInfo
         memberList:(NSArray<OIMGroupMemberBaseInfo *> *)list
          onSuccess:(OIMGroupInfoCallback)onSuccess
          onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkCreateGroup(callback, [self operationId], groupBaseInfo.mj_JSONString, [OIMGroupMemberBaseInfo mj_keyValuesArrayWithObjectArray:list].mj_JSONString);
}

- (void)joinGroup:(NSString *)gid
           reqMsg:(NSString *)reqMsg
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkJoinGroup(callback, [self operationId], gid, reqMsg ?: @"", OIMJoinTypeSearch);
}

- (void)joinGroup:(NSString *)gid
           reqMsg:(NSString *)reqMsg
       joinSource:(OIMJoinType)joinSource
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkJoinGroup(callback, [self operationId], gid, reqMsg ?: @"", joinSource);
}

- (void)quitGroup:(NSString *)gid
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkQuitGroup(callback, [self operationId], gid);
}


- (void)getJoinedGroupListWithOnSuccess:(OIMGroupsInfoCallback)onSuccess
                              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetJoinedGroupList(callback, [self operationId]);
}

- (void)getGroupsInfo:(NSArray *)gids
            onSuccess:(OIMGroupsInfoCallback)onSuccess
            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetGroupsInfo(callback, [self operationId], gids.mj_JSONString);
}

- (void)setGroupInfo:(NSString *)gid
           groupInfo:(OIMGroupBaseInfo *)info
           onSuccess:(OIMSuccessCallback)onSuccess
           onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupInfo(callback, [self operationId], gid, info.mj_JSONString);
}

- (void)getGroupMemberList:(NSString *)groupId
                    filter:(OIMGroupMemberRole)filter
                    offset:(NSInteger)offset
                     count:(NSInteger)count
                 onSuccess:(OIMGroupMembersInfoCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetGroupMemberList(callback, [self operationId], groupId, (int32_t)filter, (int32_t)offset, (int32_t)count);
}

- (void)getGroupMembersInfo:(NSString *)groupId
                       uids:(NSArray<NSString *> *)uids
                  onSuccess:(OIMGroupMembersInfoCallback)onSuccess
                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    
    Open_im_sdkGetGroupMembersInfo(callback, [self operationId], groupId, uids.mj_JSONString);
}

- (void)kickGroupMember:(NSString *)groupId
                 reason:(NSString *)reason
                   uids:(NSArray *)uids
              onSuccess:(OIMSimpleResultsCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMSimpleResultInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    
    Open_im_sdkKickGroupMember(callback, [self operationId], groupId, reason ?: @"", uids.mj_JSONString);
}

- (void)transferGroupOwner:(NSString *)groupId
                  newOwner:(NSString *)uid
                 onSuccess:(OIMSuccessCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkTransferGroupOwner(callback, [self operationId], groupId, uid);
}

- (void)inviteUserToGroup:(NSString *)groupId
                   reason:(NSString *)reason
                     uids:(NSArray <NSString *> *)uids
                onSuccess:(OIMSimpleResultsCallback)onSuccess
                onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMSimpleResultInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkInviteUserToGroup(callback, [self operationId], groupId, reason ?: @"", uids.mj_JSONString);
}

- (void)getGroupApplicationListWithOnSuccess:(OIMGroupsApplicationCallback)onSuccess
                                   onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupApplicationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetRecvGroupApplicationList(callback, [self operationId]);
}

- (void)getSendGroupApplicationListWithOnSuccess:(OIMGroupsApplicationCallback)onSuccess
                                       onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupApplicationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetSendGroupApplicationList(callback, [self operationId]);
}

- (void)acceptGroupApplication:(NSString *)groupId
                    fromUserId:(NSString *)fromUserID
                     handleMsg:(NSString *)handleMsg
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkAcceptGroupApplication(callback, [self operationId], groupId, fromUserID, handleMsg ?: @"");
}

- (void)refuseGroupApplication:(NSString *)groupId
                    fromUserId:(NSString *)fromUserID
                     handleMsg:(NSString *)handleMsg
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkRefuseGroupApplication(callback, [self operationId], groupId, fromUserID, handleMsg ?: @"");
}

- (void)dismissGroup:(NSString *)groupID
           onSuccess:(OIMSuccessCallback)onSuccess
           onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDismissGroup(callback, [self operationId], groupID);
}

- (void)changeGroupMemberMute:(NSString *)groupID
                       userID:(NSString *)userID
                 mutedSeconds:(NSInteger)mutedSeconds
                    onSuccess:(OIMSuccessCallback)onSuccess
                    onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkChangeGroupMemberMute(callback, [self operationId], groupID, userID, mutedSeconds);
}

- (void)changeGroupMute:(NSString *)groupID
                 isMute:(BOOL)isMute
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkChangeGroupMute(callback, [self operationId], groupID, isMute);
}

- (void)searchGroups:(OIMSearchGroupParam *)searchParam
           onSuccess:(OIMGroupsInfoCallback)onSuccess
           onFailure:(OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkSearchGroups(callback, [self operationId], searchParam.mj_JSONString);
}

- (void)setGroupMemberNickname:(NSString *)groupID
                        userID:(NSString *)userID
                 groupNickname:(NSString *)groupNickname
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupMemberNickname(callback, [self operationId], groupID, userID, groupNickname ?: @"");
}

- (void)setGroupMemberRoleLevel:(NSString *)groupID
                         userID:(NSString *)userID
                      roleLevel:(OIMGroupMemberRole)roleLevel
                      onSuccess:(OIMSuccessCallback)onSuccess
                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupMemberRoleLevel(callback, [self operationId], groupID, userID, roleLevel);
}

- (void)getGroupMemberListByJoinTimeFilter:(NSString *)groupID
                                    offset:(NSInteger)offset
                                     count:(NSInteger)count
                             joinTimeBegin:(NSInteger)joinTimeBegin
                               joinTimeEnd:(NSInteger)joinTimeEnd
                          filterUserIDList:(NSArray <NSString *> *)filterUserIDList
                                 onSuccess:(OIMGroupMembersInfoCallback)onSuccess
                                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetGroupMemberListByJoinTimeFilter(callback, [self operationId], groupID, (int32_t)offset, (int32_t)count, joinTimeBegin, joinTimeEnd, filterUserIDList.mj_JSONString);
}

- (void)setGroupVerification:(NSString *)groupID
            needVerification:(OIMGroupVerificationType)needVerification
                   onSuccess:(OIMSuccessCallback)onSuccess
                   onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupVerification(callback, [self operationId], groupID, (int32_t)needVerification);
}

- (void)getGroupMemberOwnerAndAdmin:(NSString *)groupID
                          onSuccess:(OIMGroupMembersInfoCallback)onSuccess
                          onFailure:(OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetGroupMemberOwnerAndAdmin(callback, [self operationId], groupID);
}

- (void)setGroupApplyMemberFriend:(NSString *)groupID
                             rule:(int32_t)rule
                        onSuccess:(nullable OIMSuccessCallback)onSuccess
                        onFailure:(nullable OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupApplyMemberFriend(callback, [self operationId], groupID, rule);
}

- (void)setGroupLookMemberInfo:(NSString *)groupID
                          rule:(int32_t)rule
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupLookMemberInfo(callback, [self operationId], groupID, rule);
}

- (void)searchGroupMembers:(OIMSearchParam *)searchParam
                 onSuccess:(OIMGroupMembersInfoCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkSearchGroupMembers(callback, [self operationId], searchParam.mj_JSONString);
}
@end
