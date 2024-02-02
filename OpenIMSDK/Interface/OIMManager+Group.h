//
//  OIMManager+Group.h
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Group)

/**
 * Create a group
 */
- (void)createGroup:(OIMGroupCreateInfo *)groupBaseInfo
          onSuccess:(nullable OIMGroupInfoCallback)onSuccess
          onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Apply to join a group
 *
 * @param groupID    Group ID
 * @param reqMsg Request message for joining the group
 * @param joinSource Method of joining
 */
- (void)joinGroup:(NSString *)groupID
           reqMsg:(NSString * _Nullable)reqMsg
       joinSource:(OIMJoinType)joinSource
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure;

- (void)joinGroup:(NSString *)groupID
           reqMsg:(NSString *)reqMsg
       joinSource:(OIMJoinType)joinSource
               ex:(NSString * _Nullable)ex
        onSuccess:(OIMSuccessCallback)onSuccess
        onFailure:(OIMFailureCallback)onFailure;

/**
 * Quit a group
 */
- (void)quitGroup:(NSString *)groupID
        onSuccess:(nullable OIMSuccessCallback)onSuccess
        onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get the list of joined groups
 */
- (void)getJoinedGroupListWithOnSuccess:(nullable OIMGroupsInfoCallback)onSuccess
                                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Batch get group information
 *
 * @param groupsID Group ID collection
 */
- (void)getSpecifiedGroupsInfo:(NSArray <NSString *> *)groupsID
                     onSuccess:(nullable OIMGroupsInfoCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set or update group information
 */
- (void)setGroupInfo:(OIMGroupInfo *)groupInfo
           onSuccess:(nullable OIMSuccessCallback)onSuccess
           onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get group members
 *
 * @param groupID Group ID
 * @param filter Member filter, 0 for no filter, 1 for group creator, 2 for administrator; default value is 0
 * @param offset Starting offset
 * @param count Member count
 */
- (void)getGroupMemberList:(NSString *)groupID
                    filter:(OIMGroupMemberFilter)filter
                    offset:(NSInteger)offset
                     count:(NSInteger)count
                 onSuccess:(nullable OIMGroupMembersInfoCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get a list of specified group members
 *
 * @param groupID Group ID
 * @param usersID Group member IDs
 */
- (void)getSpecifiedGroupMembersInfo:(NSString *)groupID
                             usersID:(NSArray <NSString *> *)usersID
                           onSuccess:(nullable OIMGroupMembersInfoCallback)onSuccess
                           onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Remove members from a group
 *
 * @param groupID Group ID
 * @param reason Reason for removal
 * @param usersID List of user IDs to be removed from the group
 */
- (void)kickGroupMember:(NSString *)groupID
                 reason:(NSString * _Nullable)reason
                usersID:(NSArray <NSString *> *)usersID
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Transfer group ownership, only the group owner can perform this action
 *
 * @param groupID Group ID
 * @param userID New group owner's user ID
 */
- (void)transferGroupOwner:(NSString *)groupID
                  newOwner:(NSString *)userID
                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Invite certain people to join a group; all group members can perform this action
 *
 * @param groupID Group ID
 * @param usersID List of user IDs to be invited
 * @param reason Invitation message
 */
- (void)inviteUserToGroup:(NSString *)groupID
                   reason:(NSString *)reason
                  usersID:(NSArray <NSString *> *)usersID
                onSuccess:(nullable OIMSuccessCallback)onSuccess
                onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get a list of group member applications received by administrators or group owners
 */
- (void)getGroupApplicationListAsRecipientWithOnSuccess:(nullable OIMGroupsApplicationCallback)onSuccess
                                              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Group applications sent by the current user
 */
- (void)getGroupApplicationListAsApplicantWithOnSuccess:(nullable OIMGroupsApplicationCallback)onSuccess
                                              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Accept someone's application to join a group as an administrator or group owner
 *
 * @param groupID Group ID
 * @param fromUserID User ID of the user applying to join the group
 * @param handleMsg Handling message
 */
- (void)acceptGroupApplication:(NSString *)groupID
                    fromUserId:(NSString *)fromUserID
                     handleMsg:(NSString * _Nullable)handleMsg
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/*
 * Reject someone's application to join a group as an administrator or group owner
 *
 * @param groupId Group ID
 * @param fromUserID User ID of the user applying to join the group
 * @param handleMsg Handling message
 */
- (void)refuseGroupApplication:(NSString *)groupID
                    fromUserId:(NSString *)fromUserID
                     handleMsg:(NSString * _Nullable)handleMsg
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Disband a group
 * Disband a group
 *
 * @param groupID Group ID
 */
- (void)dismissGroup:(NSString *)groupID
           onSuccess:(nullable OIMSuccessCallback)onSuccess
           onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Mute or unmute a group member, mutedSeconds is set to 0 for unmuting
 */
- (void)changeGroupMemberMute:(NSString *)groupID
                       userID:(NSString *)userID
                 mutedSeconds:(NSInteger)mutedSeconds
           onSuccess:(nullable OIMSuccessCallback)onSuccess
           onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Mute or unmute a group
 */
- (void)changeGroupMute:(NSString *)groupID
                 isMute:(BOOL)isMute
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Search for groups by group name or group ID
 */
- (void)searchGroups:(OIMSearchGroupParam *)searchParam
           onSuccess:(nullable OIMGroupsInfoCallback)onSuccess
           onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set group member nickname
 */
- (void)setGroupMemberNickname:(NSString *)groupID
                        userID:(NSString *)userID
                 groupNickname:(NSString * _Nullable)groupNickname
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set group member role level
 */
- (void)setGroupMemberRoleLevel:(NSString *)groupID
                         userID:(NSString *)userID
                      roleLevel:(OIMGroupMemberRole)roleLevel
                      onSuccess:(nullable OIMSuccessCallback)onSuccess
                      onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set group member's info
 */
- (void)setGroupMemberInfo:(OIMGroupMemberInfo *)groupMemberInfo
                 onSuccess:(nullable OIMSuccessCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get the list of group members based on join time
 * @param groupID Group ID
 * @param joinTimeBegin Start time for joining
 * @param joinTimeEnd End time for joining
 * @param offset Starting index
 * @param count Total count
 * @param filterUserIDList List of user IDs to filter
 */
- (void)getGroupMemberListByJoinTimeFilter:(NSString *)groupID
                                    offset:(NSInteger)offset
                                     count:(NSInteger)count
                             joinTimeBegin:(NSInteger)joinTimeBegin
                               joinTimeEnd:(NSInteger)joinTimeEnd
                          filterUserIDList:(NSArray <NSString *> *)filterUserIDList
                                 onSuccess:(nullable OIMGroupMembersInfoCallback)onSuccess
                                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set group verification option for joining
 * @param groupID Group ID
 * @param needVerification Joining settings
 */
- (void)setGroupVerification:(NSString *)groupID
            needVerification:(OIMGroupVerificationType)needVerification
                   onSuccess:(nullable OIMSuccessCallback)onSuccess
                   onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get the list of managers and owners
 * @param groupID Group ID
 */
- (void)getGroupMemberOwnerAndAdmin:(NSString *)groupID
                          onSuccess:(nullable OIMGroupMembersInfoCallback)onSuccess
                          onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Determine whether group members can add each other as friends
 * @param groupID Group ID
 * @param rule 0: Default behavior, 1: Not allowed
 */
- (void)setGroupApplyMemberFriend:(NSString *)groupID
                             rule:(int32_t)rule
                          onSuccess:(nullable OIMSuccessCallback)onSuccess
                          onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * View group member information
 * @param groupID Group ID
 * @param rule 0: Default behavior, 1: Not allowed
 */
- (void)setGroupLookMemberInfo:(NSString *)groupID
                          rule:(int32_t)rule
                     onSuccess:(nullable OIMSuccessCallback)onSuccess
                     onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Search group members
 */
- (void)searchGroupMembers:(OIMSearchGroupMembersParam *)searchParam
                 onSuccess:(nullable OIMGroupMembersInfoCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Check if the user has joined the group
 */
- (void)isJoinedGroup:(NSString *)groupID
            onSuccess:(nullable OIMBoolCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END

