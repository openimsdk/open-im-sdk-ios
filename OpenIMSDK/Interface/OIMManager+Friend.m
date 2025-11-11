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

- (void)getFriendApplicationListAsRecipientWithOnSuccess:(nullable OIMFriendApplicationsCallback)onSuccess
                                               onFailure:(nullable OIMFailureCallback)onFailure {
    [self getFriendApplicationListAsRecipientWithReq:nil onSuccess:onSuccess onFailure:onFailure];
}

- (void)getFriendApplicationListAsRecipientWithReq:(nullable GetFriendApplicationListAsRecipientReq *)req
                                           onSuccess:(OIMFriendApplicationsCallback)onSuccess
                                         onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFriendApplication mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    
    Open_im_sdkGetFriendApplicationListAsRecipient(callback, [self operationId], req ? req.mj_JSONString : @"{}");
}

- (void)getFriendApplicationListAsApplicantWithOnSuccess:(nullable OIMFriendApplicationsCallback)onSuccess
                                               onFailure:(nullable OIMFailureCallback)onFailure {
    [self getFriendApplicationListAsApplicantWithReq:nil onSuccess:onSuccess onFailure:onFailure];
}

- (void)getFriendApplicationListAsApplicantWithReq:(nullable GetFriendApplicationListAsApplicantReq *)req
                                         onSuccess:(nullable OIMFriendApplicationsCallback)onSuccess
                                        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFriendApplication mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetFriendApplicationListAsApplicant(callback, [self operationId], req ? req.mj_JSONString : @"{}");
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
    [self addToBlackList:userID ex:nil onSuccess:onSuccess onFailure:onFailure];
}

- (void)addToBlackList:(NSString *)userID
                    ex:(NSString *)ex
             onSuccess:(OIMSuccessCallback)onSuccess
             onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkAddBlack(callback, [self operationId], userID, ex);
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

- (void)getSpecifiedFriendsInfo:(NSArray <NSString *> *)usersID
                    filterBlack:(BOOL)filterBlack
                      onSuccess:(nullable OIMFriendsInfoCallback)onSuccess
                      onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFriendInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetSpecifiedFriendsInfo(callback, [self operationId], usersID.mj_JSONString, filterBlack);
}

- (void)getFriendListWithFilterBlack:(BOOL)filterBlack
                           onSuccess:(nullable OIMFriendsInfoCallback)onSuccess
                         onFailure:(nullable OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFriendInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetFriendList(callback, [self operationId], filterBlack);
}

- (void)getFriendListPageWithOffset:(NSInteger)offset
                              count:(NSInteger)count
                        filterBlack:(BOOL)filterBlack
                          onSuccess:(OIMFriendsInfoCallback)onSuccess
                          onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMFriendInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetFriendListPage(callback, [self operationId], (int32_t)offset, (int32_t)count, filterBlack);
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
        
    OIMUpdateFriendsReq *req = [OIMUpdateFriendsReq new];
    req.friendUserIDs = @[userID];
    req.remark = remark;
    
    [self updateFriends:req onSuccess:onSuccess onFailure:onFailure];
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

- (void)setFriendsEx:(NSArray<NSString *> *)friendIDs
                  ex:(NSString *)ex
           onSuccess:(OIMSuccessCallback)onSuccess
           onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    OIMUpdateFriendsReq *req = [OIMUpdateFriendsReq new];
    req.friendUserIDs = friendIDs;
    req.ex = ex;
    
    [self updateFriends:req onSuccess:onSuccess onFailure:onFailure];
}

- (void)updateFriends:(OIMUpdateFriendsReq *)req
            onSuccess:(nullable OIMSuccessCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];

    Open_im_sdkUpdateFriends(callback, [self operationId], req.mj_JSONString);
}

- (void)getFriendApplicationUnhandledCount:(GetFriendApplicationUnhandledCountReq *)req
                                 onSuccess:(OIMNumberCallback)onSuccess
                                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess(data.integerValue);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetFriendApplicationUnhandledCount(callback, [self operationId], req.mj_JSONString);
}
@end
