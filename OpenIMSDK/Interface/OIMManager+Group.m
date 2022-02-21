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
    
    Open_im_sdkJoinGroup(callback, [self operationId], gid, reqMsg ?: @"");
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
                    filter:(NSInteger)filter
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


@end
