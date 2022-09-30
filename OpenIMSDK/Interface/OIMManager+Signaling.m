//
//  OIMManager+Signaling.m
//  OpenIMSDK
//
//  Created by x on 2022/3/17.
//

#import "OIMManager+Signaling.h"
#import "CallbackProxy.h"

@implementation OIMManager (Signaling)

- (OIMSignalingInfo *)signalingInvite:(OIMInvitationInfo *)invitation
        offlinePushInfo:(OIMOfflinePushInfo *)offlinePushInfo
              onSuccess:(OIMSignalingResultCallback)onSuccess
              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMInvitationResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    invitation.sessionType = invitation.groupID.length == 0 ? OIMConversationTypeC2C : OIMConversationTypeGroup;
    invitation.inviterUserID = invitation.inviterUserID ?: self.getLoginUid;
    invitation.mediaType = invitation.mediaType.length == 0 ? @"video" : invitation.mediaType;
    invitation.roomID = invitation.roomID.length == 0 ? [[NSUUID UUID]UUIDString].lowercaseString : invitation.roomID;
    
    OIMSignalingInfo *info = [OIMSignalingInfo new];
    info.invitation = invitation;
    info.opUserID = [self getLoginUid];
    
    if (invitation.groupID.length > 0) {
        if (!offlinePushInfo) {
            offlinePushInfo = [OIMOfflinePushInfo new];
        }
        offlinePushInfo.title = @"有群邀请你加入音视频";
    }
    
    info.offlinePushInfo = offlinePushInfo;
        
    if (invitation.sessionType == OIMConversationTypeGroup) {
        Open_im_sdkSignalingInviteInGroup(callback, [self operationId], info.mj_JSONString);
    } else {
        Open_im_sdkSignalingInvite(callback, [self operationId], info.mj_JSONString);
    }
    
    return info;
}

- (OIMSignalingInfo *)signalingInviteInGroup:(OIMInvitationInfo *)invitation
               offlinePushInfo:(OIMOfflinePushInfo *)offlinePushInfo
                     onSuccess:(OIMSignalingResultCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    return [self signalingInvite:invitation offlinePushInfo:offlinePushInfo onSuccess:onSuccess onFailure:onFailure];
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

- (void)signalingGetRoomByGroupID:(NSString *)groupID
                        onSuccess:(OIMSignalingParticipantChangeCallback)onSuccess
                        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMParticipantConnectedInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
        
    Open_im_sdkSignalingGetRoomByGroupID(callback, [self operationId], groupID);
}

@end
