//
//  OIMManager+Friend.m
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager+Friend.h"
#import "CallbackProxy.h"

@implementation OIMManager (Friend)

- (void)addFriend:(NSString *)userID
       reqMessage:(NSString *)reqMessage
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    NSDictionary *param = @{@"toUserID": userID, @"reqMsg": reqMessage ?: @""};
    Open_im_sdkAddFriend(callback, [self operationId], param.mj_JSONString);
}

- (void)getFriendApplicationListAsRecipientWithOnSuccess:(OIMFriendApplicationsCallback)onSuccess
                                    onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFriendApplication mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    
    Open_im_sdkGetFriendApplicationListAsRecipient(callback, [self operationId]);
}

- (void)getFriendApplicationListAsApplicantWithOnSuccess:(OIMFriendApplicationsCallback)onSuccess
                                        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFriendApplication mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetFriendApplicationListAsApplicant(callback, [self operationId]);
}

- (void)acceptFriendApplication:(NSString *)userID
                      handleMsg:(NSString *)msg
                      onSuccess:(OIMSuccessCallback)onSuccess
                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    NSDictionary *param = @{@"toUserID": userID, @"handleMsg": msg ?: @""};
    Open_im_sdkAcceptFriendApplication(callback, [self operationId], param.mj_JSONString);
}

- (void)refuseFriendApplication:(NSString *)userID
                      handleMsg:(NSString *)msg
                      onSuccess:(OIMSuccessCallback)onSuccess
                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    NSDictionary *param = @{@"toUserID": userID, @"handleMsg": msg ?: @""};
    Open_im_sdkRefuseFriendApplication(callback, [self operationId], param.mj_JSONString);
}

- (void)addToBlackList:(NSString *)userID
             onSuccess:(OIMSuccessCallback)onSuccess
             onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkAddBlack(callback, [self operationId], userID);
}

- (void)getBlackListWithOnSuccess:(OIMBlacksInfoCallback)onSuccess
                        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMBlackInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetBlackList(callback, [self operationId]);
}

- (void)removeFromBlackList:(NSString *)userID
                  onSuccess:(OIMSuccessCallback)onSuccess
                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkRemoveBlack(callback, [self operationId], userID);
}

- (void)getSpecifiedFriendsInfo:(NSArray<NSString *> *)usersID
                      onSuccess:(OIMFullUsersInfoCallback)onSuccess
                      onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFullUserInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetSpecifiedFriendsInfo(callback, [self operationId], usersID.mj_JSONString);
}

- (void)getFriendListWithOnSuccess:(OIMFullUsersInfoCallback)onSuccess
                         onFailure:(OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFullUserInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetFriendList(callback, [self operationId]);
}

- (void)checkFriend:(NSArray<NSString *> *)usersID
          onSuccess:(OIMSimpleResultsCallback)onSuccess
          onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMSimpleResultInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkCheckFriend(callback, [self operationId], usersID.mj_JSONString);
}

- (void)setFriendRemark:(NSString *)userID
                 remark:(NSString *)remark
              onSuccess:(OIMSuccessCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    NSDictionary *param = @{@"toUserID": userID, @"remark": remark ?: @""};
    Open_im_sdkSetFriendRemark(callback, [self operationId], param.mj_JSONString);
}

- (void)deleteFriend:(NSString *)friendUserID
           onSuccess:(OIMSuccessCallback)onSuccess onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkDeleteFriend(callback, [self operationId], friendUserID);
}

- (void)searchFriends:(OIMSearchFriendsParam *)searchParam
            onSuccess:(nullable OIMSearchUsersInfoCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure {
    
    assert(searchParam.isSearchRemark || searchParam.isSearchNickname || searchParam.isSearchUserID);
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMSearchFriendsInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkSearchFriends(callback, [self operationId], searchParam.mj_JSONString);
}
@end
