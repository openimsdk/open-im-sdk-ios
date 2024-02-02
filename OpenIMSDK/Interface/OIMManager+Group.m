//
//  OIMManager+Group.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+Group.h"
#import "CallbackProxy.h"

@implementation OIMManager (Group)

- (void)createGroup:(OIMGroupCreateInfo *)groupCreateInfo
          onSuccess:(OIMGroupInfoCallback)onSuccess
          onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
        
    Open_im_sdkCreateGroup(callback, [self operationId], groupCreateInfo.mj_JSONString);
}

- (void)joinGroup:(NSString *)groupID
           reqMsg:(NSString *)reqMsg
       joinSource:(OIMJoinType)joinSource
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkJoinGroup(callback, [self operationId], groupID, reqMsg ?: @"", joinSource, nil);
}

- (void)joinGroup:(NSString *)groupID
           reqMsg:(NSString *)reqMsg
       joinSource:(OIMJoinType)joinSource
               ex:(NSString *)ex
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkJoinGroup(callback, [self operationId], groupID, reqMsg ?: @"", joinSource, ex);
}

- (void)quitGroup:(NSString *)groupID
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkQuitGroup(callback, [self operationId], groupID);
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

- (void)getSpecifiedGroupsInfo:(NSArray <NSString *> *)groupsID
                     onSuccess:(nullable OIMGroupsInfoCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetSpecifiedGroupsInfo(callback, [self operationId], groupsID.mj_JSONString);
}

- (void)setGroupInfo:(OIMGroupInfo *)info
           onSuccess:(OIMSuccessCallback)onSuccess
           onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupInfo(callback, [self operationId], info.mj_JSONString);
}

- (void)getGroupMemberList:(NSString *)groupID
                    filter:(OIMGroupMemberFilter)filter
                    offset:(NSInteger)offset
                     count:(NSInteger)count
                 onSuccess:(OIMGroupMembersInfoCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetGroupMemberList(callback, [self operationId], groupID, (int32_t)filter, (int32_t)offset, (int32_t)count);
}

- (void)getSpecifiedGroupMembersInfo:(NSString *)groupID
                             usersID:(NSArray <NSString *> *)usersID
                           onSuccess:(nullable OIMGroupMembersInfoCallback)onSuccess
                           onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    
    Open_im_sdkGetSpecifiedGroupMembersInfo(callback, [self operationId], groupID, usersID.mj_JSONString);
}

- (void)kickGroupMember:(NSString *)groupID
                 reason:(NSString *)reason
                usersID:(NSArray <NSString *> *)usersID
              onSuccess:(OIMSuccessCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];

    Open_im_sdkKickGroupMember(callback, [self operationId], groupID, reason ?: @"", usersID.mj_JSONString);
}

- (void)transferGroupOwner:(NSString *)groupID
                  newOwner:(NSString *)userID
                 onSuccess:(OIMSuccessCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkTransferGroupOwner(callback, [self operationId], groupID, userID);
}

- (void)inviteUserToGroup:(NSString *)groupID
                   reason:(NSString *)reason
                  usersID:(NSArray <NSString *> *)usersID
                onSuccess:(OIMSuccessCallback)onSuccess
                onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];

    Open_im_sdkInviteUserToGroup(callback, [self operationId], groupID, reason ?: @"", usersID.mj_JSONString);
}

- (void)getGroupApplicationListAsRecipientWithOnSuccess:(OIMGroupsApplicationCallback)onSuccess
                                              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupApplicationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetGroupApplicationListAsRecipient(callback, [self operationId]);
}

- (void)getGroupApplicationListAsApplicantWithOnSuccess:(OIMGroupsApplicationCallback)onSuccess
                                              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMGroupApplicationInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetGroupApplicationListAsApplicant(callback, [self operationId]);
}

- (void)acceptGroupApplication:(NSString *)groupID
                    fromUserId:(NSString *)fromUserID
                     handleMsg:(NSString *)handleMsg
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkAcceptGroupApplication(callback, [self operationId], groupID, fromUserID, handleMsg ?: @"");
}

- (void)refuseGroupApplication:(NSString *)groupID
                    fromUserId:(NSString *)fromUserID
                     handleMsg:(NSString *)handleMsg
                     onSuccess:(OIMSuccessCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkRefuseGroupApplication(callback, [self operationId], groupID, fromUserID, handleMsg ?: @"");
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

- (void)setGroupMemberInfo:(OIMGroupMemberInfo *)groupMemberInfo
                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSetGroupMemberInfo(callback, [self operationId], groupMemberInfo.mj_JSONString);
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

- (void)isJoinedGroup:(NSString *)groupID
            onSuccess:(OIMBoolCallback)onSuccess
            onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([data isEqualToString:@"true"]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkIsJoinGroup(callback, [self operationId], groupID);
}
@end
