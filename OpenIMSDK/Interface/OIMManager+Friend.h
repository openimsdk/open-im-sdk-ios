//
//  OIMManager+Friend.h
//  OpenIMSDK
//
//  Created by x on 2022/2/16.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Friend)

/**
 * Add a friend
 *
 * @param userID    User ID of the other person
 * @param reqMessage Request message
 */
- (void)addFriend:(NSString *)userID
       reqMessage:(NSString * _Nullable)reqMessage
        onSuccess:(nullable OIMSuccessCallback)onSuccess
        onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get received friend applications, i.e., people who have applied to be friends with me
 */
- (void)getFriendApplicationListAsRecipientWithOnSuccess:(nullable OIMFriendApplicationsCallback)onSuccess
                                    onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Friend applications sent by the current user
 */
- (void)getFriendApplicationListAsApplicantWithOnSuccess:(nullable OIMFriendApplicationsCallback)onSuccess
                                        onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Accept a friend application from someone
 * @param userID User ID
 */
- (void)acceptFriendApplication:(NSString *)userID
                      handleMsg:(NSString *)msg
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Reject a friend application
 *
 * @param userID  User ID
 */
- (void)refuseFriendApplication:(NSString *)userID
                      handleMsg:(NSString *)msg
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Add to the blacklist
 *
 * @param userID  User ID
 */
- (void)addToBlackList:(NSString *)userID
             onSuccess:(nullable OIMSuccessCallback)onSuccess
             onFailure:(nullable OIMFailureCallback)onFailure;

- (void)addToBlackList:(NSString *)userID
                    ex:(NSString * _Nullable)ex
             onSuccess:(OIMSuccessCallback)onSuccess
             onFailure:(OIMFailureCallback)onFailure;
/**
 * Blacklist
 */
- (void)getBlackListWithOnSuccess:(nullable OIMBlacksInfoCallback)onSuccess
                        onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Remove from the blacklist
 *
 * @param userID  User ID
 */
- (void)removeFromBlackList:(NSString *)userID
                  onSuccess:(nullable OIMSuccessCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get related information for a specified list of friends
 *
 * @param usersID List of user IDs
 */
- (void)getSpecifiedFriendsInfo:(NSArray <NSString *> *)usersID
                      onSuccess:(nullable OIMFullUsersInfoCallback)onSuccess
                      onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Get information for all friends
 */
- (void)getFriendListWithOnSuccess:(nullable OIMFullUsersInfoCallback)onSuccess
                         onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Check if there is a friend relationship, i.e., if the user is in the friend list of the logged-in user. Note: Friendship is a two-way relationship.
 * A result of 1 means the user is a friend (and not in the blacklist).
 *
 * @param usersID User ID list
*/
- (void)checkFriend:(NSArray <NSString *> *)usersID
          onSuccess:(nullable OIMSimpleResultsCallback)onSuccess
          onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Set a friend's remark
 *
 * @param uid User ID
 * @param remark Remark information
 */
- (void)setFriendRemark:(NSString *)uid
                 remark:(NSString * _Nullable)remark
              onSuccess:(nullable OIMSuccessCallback)onSuccess
              onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Delete a friend; friendship is a two-way relationship, this function only deletes the user's own friend
 *
 * @param friendUserID  Friend's ID
 */
- (void)deleteFriend:(NSString *)friendUserID
           onSuccess:(nullable OIMSuccessCallback)onSuccess
           onFailure:(nullable OIMFailureCallback)onFailure;

/**
 * Local friend search
 */
- (void)searchFriends:(OIMSearchFriendsParam *)searchParam
            onSuccess:(nullable OIMSearchUsersInfoCallback)onSuccess
            onFailure:(nullable OIMFailureCallback)onFailure;

- (void)setFriendsEx:(NSArray<NSString *> *)friendIDs
                  ex:(NSString *)ex
           onSuccess:(nullable OIMSuccessCallback)onSuccess
           onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
