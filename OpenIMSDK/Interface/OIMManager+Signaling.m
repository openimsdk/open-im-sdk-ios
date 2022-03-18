//
//  OIMManager+Signaling.m
//  OpenIMSDK
//
//  Created by x on 2022/3/17.
//

#import "OIMManager+Signaling.h"
#import "CallbackProxy.h"

@implementation OIMManager (Signaling)

- (void)signalingInvite:(OIMInvitationInfo *)invitation
        offlinePushInfo:(OIMOfflinePushInfo *)offlinePushInfo
              onSuccess:(OIMSignalingResultCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMInvitationResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    invitation.sessionType = OIMConversationTypeC2C;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"invitation"] = invitation.mj_JSONObject;
    param[@"offlinePushInfo"] = offlinePushInfo.mj_JSONObject;
    
    Open_im_sdkSignalingInvite(callback, [self operationId], param.mj_JSONString);
}

- (void)signalingInviteInGroup:(OIMInvitationInfo *)invitation
                     onSuccess:(nullable OIMSignalingResultCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMInvitationResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    invitation.sessionType = OIMConversationTypeGroup;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"invitation"] = invitation.mj_JSONObject;
    
    Open_im_sdkSignalingInvite(callback, [self operationId], param.mj_JSONString);
}

- (void)signalingAccept:(OIMSignalingInfo *)invitation
              onSuccess:(OIMSignalingResultCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMInvitationResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
        
    Open_im_sdkSignalingAccept(callback, [self operationId], invitation.mj_JSONString);
}


- (void)signalingReject:(OIMSignalingInfo *)invitation
              onSuccess:(OIMSuccessCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSignalingReject(callback, [self operationId], invitation.mj_JSONString);
}

- (void)signalingCancel:(OIMSignalingInfo *)invitation
              onSuccess:(OIMSuccessCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSignalingCancel(callback, [self operationId], invitation.mj_JSONString);
}

- (void)signalingHungUp:(OIMSignalingInfo *)invitation
              onSuccess:(OIMSuccessCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSignalingHungUp(callback, [self operationId], invitation.mj_JSONString);
}

@end
