//
//  OIMManager+Signaling.h
//  OpenIMSDK
//
//  Created by x on 2022/3/17.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Signaling)

/*
 * 邀请个人加入音视频
 *
 * @param invitation
 * 邀请个人加入：
    {
        "inviteeUserIDList": ["userID"],  //只有一个元素
        "roomID": "roomID",
        "timeout": 1000,
        "mediaType": "video",
        "sessionType": x,
    }
 * 邀请群里某些人加入音视频
    {
        "inviteeUserIDList": ["useID1", "userID2"],
        "groupID": "groupID",
        "roomID": "roomID",
        "timeout": 1000,
        "mediaType": "video",
        "sessionType": x
    }
 * @param offlinePushInfo 离线push消息
 */
- (void)signalingInvite:(OIMInvitationInfo *)invitation
        offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
              onSuccess:(nullable OIMSignalingResultCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;


- (void)signalingInviteInGroup:(OIMInvitationInfo *)invitation
                     onSuccess:(nullable OIMSignalingResultCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/*
 *  同意某人音视频邀请
 *  opUserID 操作人的ID
 *  invitation
    {
         "inviterUserID": "userID",
         "inviteeUserIDList": [
             "userID"
         ],
         "groupID": "groupID",
         "roomID": "roomID",
         "timeout": 1000,
         "mediaType": "video",
         "sessionType": x
     }
 */
- (void)signalingAccept:(OIMSignalingInfo *)invitation
              onSuccess:(nullable OIMSignalingResultCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/*
 *  拒绝某人音视频邀请
 *  opUserID 操作人的ID
 *  invitation
    {
         "inviterUserID": "userID",
         "inviteeUserIDList": [
             "userID"
         ],
         "groupID": "groupID",
         "roomID": "roomID",
         "timeout": 1000,
         "mediaType": "video",
         "sessionType": x
     }
 */
- (void)signalingReject:(OIMSignalingInfo *)invitation
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/*
 *  取消某人音视频邀请
 *  opUserID 操作人的ID
 *  invitation
    {
         "inviterUserID": "userID",
         "inviteeUserIDList": [
             "userID"
         ],
         "groupID": "groupID",
         "roomID": "roomID",
         "timeout": 1000,
         "mediaType": "video",
         "sessionType": x
     }
 */
- (void)signalingCancel:(OIMSignalingInfo *)invitation
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;


- (void)signalingHungUp:(OIMSignalingInfo *)invitation
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
