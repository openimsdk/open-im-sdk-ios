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
    invitation.inviterUserID = invitation.inviterUserID ?: [self getLoginUserID];
    invitation.mediaType = invitation.mediaType.length == 0 ? @"video" : invitation.mediaType;
    invitation.roomID = invitation.roomID.length == 0 ? [[NSUUID UUID]UUIDString].lowercaseString : invitation.roomID;
    
    OIMSignalingInfo *info = [OIMSignalingInfo new];
    info.invitation = invitation;
    info.userID = [self getLoginUserID];
    
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

- (void)signalingGetTokenByRoomID:(NSString *)groupID
                        onSuccess:(OIMSignalingResultCallback)onSuccess
                        onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMInvitationResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkSignalingGetTokenByRoomID(callback, [self operationId], groupID);
}

- (void)signalingCloseRoom:(NSString *)roomID
                 onSuccess:(OIMSuccessCallback)onSuccess
                 onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSignalingCloseRoom(callback, [self operationId], roomID);
}

- (void)signalingCreateMeeting:(NSString *)meetingName
             meetingHostUserID:(NSString *)meetingHostUserID
                     startTime:(NSNumber *)startTime
               meetingDuration:(NSNumber *)meetingDuration
             inviteeUserIDList:(NSArray *)inviteeUserIDList
                     onSuccess:(OIMSignalingResultCallback)onSuccess
                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMInvitationResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"meetingName"] = meetingName;
    
    if (meetingHostUserID != nil) {
        params[@"meetingHostUserID"] = meetingHostUserID;
    }
    
    if (startTime != nil) {
        params[@"startTime"] = startTime;
    }
    
    if (meetingDuration != nil) {
        params[@"meetingDuration"] = meetingDuration;
    }
    
    params[@"inviteeUserIDList"] = inviteeUserIDList ?: [NSArray new];
    
    Open_im_sdkSignalingCreateMeeting(callback, [self operationId], params.mj_JSONString);
}

- (void)signalingJoinMeeting:(NSString *)roomID
                        name:(nullable NSString *)name
         participantNickname:(nullable NSString *)participantNickname
                   onSuccess:(nullable OIMSignalingResultCallback)onSuccess
                   onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMInvitationResultInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"roomID"] = roomID;
    params[@"name"] = name ?: @"";
    params[@"participantNickname"] = participantNickname ?: @"";
    
    Open_im_sdkSignalingJoinMeeting(callback, [self operationId], params.mj_JSONString);
}

- (void)signalingOperateStream:(NSString *)roomID
                        userID:(NSString *)userID
                    streamType:(NSString *)streamType
                          mute:(BOOL)mute
                       muteAll:(BOOL)muteAll
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSignalingOperateStream(callback, [self operationId], streamType, roomID, userID, mute, muteAll);;
}

- (void)signalingUpdateMeetingInfo:(NSString *)roomID
                           setting:(NSDictionary *)params
                         onSuccess:(OIMSuccessCallback)onSuccess
                         onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    NSMutableDictionary *p = [NSMutableDictionary new];
    p[@"roomID"] = roomID;
    [p addEntriesFromDictionary:params];
    
    Open_im_sdkSignalingUpdateMeetingInfo(callback, [self operationId], p.mj_JSONString);
}

- (void)signalingGetMeetingsWithSuccess:(OIMSignalingMeetingsInfoCallback)onSuccess
                              onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMeetingInfoList mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkSignalingGetMeetings(callback, [self operationId]);
}

- (void)signalingSendCustomSignal:(NSString *)roomID
                       customInfo:(NSString *)customInfo
                        onSuccess:(OIMSuccessCallback)onSuccess onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkSignalingSendCustomSignal(callback, [self operationId], customInfo, roomID);
}

- (void)getSignalingInvitationInfoStartAppWithOnSuccess:(nullable OIMSignalingInvitationCallback)onSuccess
                                              onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMSignalingInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetSignalingInvitationInfoStartApp(callback, [self operationId]);
}

@end
