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
        "roomID": "", // 选填
        "timeout": 30,// 默认30s
        "mediaType": "video", / "audio" // 默认"video"
    }
 * 邀请群里某些人加入音视频
    {
        "inviteeUserIDList": ["useID1", "userID2"],
        "groupID": "groupID", // 必填
        "roomID": "", // 选填
        "timeout": 30,// 默认30s
        "mediaType": "video", / "audio" // 默认"video"
    }
 * @param offlinePushInfo 离线push消息
 */
- (OIMSignalingInfo *)signalingInvite:(OIMInvitationInfo *)invitation
                      offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
                            onSuccess:(nullable OIMSignalingResultCallback)onSuccess
                            onFailure:(nullable OIMFailureCallback)onFailure;

/*
 *  邀请群里某些人加入音视频 - 只在于参数的设置
 */
- (OIMSignalingInfo *)signalingInviteInGroup:(OIMInvitationInfo *)invitation
                             offlinePushInfo:(OIMOfflinePushInfo * _Nullable)offlinePushInfo
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

/**
 根据群ID查房间信息，正在通话的群成员信息
 */
- (void)signalingGetRoomByGroupID:(NSString *)groupID
                        onSuccess:(nullable OIMSignalingParticipantChangeCallback)onSuccess
                        onFailure:(nullable OIMFailureCallback)onFailure;

/**
 根据群ID查token
 */
- (void)signalingGetTokenByRoomID:(NSString *)groupID
                        onSuccess:(nullable OIMSignalingResultCallback)onSuccess
                        onFailure:(nullable OIMFailureCallback)onFailure;

/**
 创建会议
 @param meetingName 会议主题
 @param meetingHostUserID 会议主持人ID
 @param startTime 开始时间s
 @param meetingDuration 会议时长s
 @param inviteeUserIDList 被邀请人ID列表
 */
- (void)signalingCreateMeeting:(NSString *)meetingName
             meetingHostUserID:(NSString *)meetingHostUserID
                     startTime:(nullable NSNumber *)startTime
               meetingDuration:(nullable NSNumber *)meetingDuration
             inviteeUserIDList:(nullable NSArray *)inviteeUserIDList
                     onSuccess:(nullable OIMSignalingResultCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/**
 加入会议
 @param roomID 会议ID
 @param name 会议主题
 @param participantNickname 加入房间显示的名称
 */
- (void)signalingJoinMeeting:(NSString *)roomID
                        name:(nullable NSString *)name
         participantNickname:(nullable NSString *)participantNickname
                   onSuccess:(nullable OIMSignalingResultCallback)onSuccess
                   onFailure:(nullable OIMFailureCallback)onFailure;

/**
 会议室 管理员对指定的某一个入会人员设置禁言
 @param roomID 会议ID
 @param userID 目标的用户ID
 @param streamType video/audio
 @param mute YES：禁言
 @param muteAll video/audio 一起设置
 */
- (void)signalingOperateStream:(NSString *)roomID
                        userID:(NSString *)userID
                    streamType:(NSString *)streamType
                          mute:(BOOL)mute
                       muteAll:(BOOL)muteAll
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/**
  会议设置
@param roomID 会议id
 @param params 设置相关参数，需要谁设置谁
///  String meetingName,
///  int startTime = 0,
///  int endTime = 0,
///  bool participantCanUnmuteSelf = true,
///  bool participantCanEnableVideo = true,
///  bool onlyHostInviteUser = true,
///  bool onlyHostShareScreen = true,
///  bool joinDisableMicrophone = true,
///  bool joinDisableVideo = true,
///  bool isMuteAllVideo = true,
///  bool isMuteAllMicrophone = true,
///  NSArray<String> addCanScreenUserIDList =  [],
///  NSArray<String> reduceCanScreenUserIDList =  [],
///  NSArray<String> addDisableMicrophoneUserIDList =  [],
///  NSArray<String> reduceDisableMicrophoneUserIDList =  [],
///  NSArray<String> addDisableVideoUserIDList =  [],
///  NSArray<String> reduceDisableVideoUserIDList =  [],
///  NSArray<String> addPinedUserIDList = [],
///  NSArray<String> reducePinedUserIDList =  [],
///  NSArray<String> addBeWatchedUserIDList =  [],
///  NSArray<String> reduceBeWatchedUserIDList =  [],
 */
- (void)signalingUpdateMeetingInfo:(NSString *)roomID
                           setting:(NSDictionary *)params
                         onSuccess:(nullable OIMSuccessCallback)onSuccess
                         onFailure:(nullable OIMFailureCallback)onFailure;

/**
 获取所有的未完成会议
 */
- (void)signalingGetMeetingsWithSuccess:(nullable OIMSignalingMeetingsInfoCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 结束会议
 */
- (void)signalingCloseRoom:(NSString *)roomID
                        onSuccess:(nullable OIMSuccessCallback)onSuccess
                        onFailure:(nullable OIMFailureCallback)onFailure;

- (void)signalingSendCustomSignal:(NSString *)roomID
                       customInfo:(NSString *)customInfo
                        onSuccess:(nullable OIMSuccessCallback)onSuccess
                        onFailure:(nullable OIMFailureCallback)onFailure;

/**
 启动app的时候，检查是否有未完成的音视频邀请
 */
- (void)getSignalingInvitationInfoStartAppWithOnSuccess:(nullable OIMSignalingInvitationCallback)onSuccess
                                              onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
