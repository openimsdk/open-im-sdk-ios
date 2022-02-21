//
//  OIMCallbacker+Friend.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCallbacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMCallbacker (Friend)

/*
 * 设置好友关系监听器
 *
 * 好友被拉入黑名单回调   onBlackAdded
 * 好友从黑名单移除回调   onBlackDeleted
 * 发起的好友请求被接受时回调    onFriendApplicationAccepted
 * 我接受别人的发起的好友请求时回调 onFriendApplicationAdded
 * 删除好友请求时回调    onFriendApplicationDeleted
 * 请求被拒绝回调  onFriendApplicationRejected
 * 好友资料发生变化时回调  onFriendInfoChanged
 * 已添加好友回调  onFriendAdded
 * 好友被删除时回调 onFriendDeleted
 **/
- (void)setFriendListenerWithOnBlackAdded:(OIMBlackInfoCallback)onBlackAdded
                           onBlackDeleted:(OIMBlackInfoCallback)onBlackDeleted
              onFriendApplicationAccepted:(OIMFriendApplicationCallback)onFriendApplicationAccepted
                 onFriendApplicationAdded:(OIMFriendApplicationCallback)onFriendApplicationAdded
               onFriendApplicationDeleted:(OIMFriendApplicationCallback)onFriendApplicationDeleted
              onFriendApplicationRejected:(OIMFriendApplicationCallback)onFriendApplicationRejected
                      onFriendInfoChanged:(OIMFriendInfoCallback)onFriendInfoChanged
                            onFriendAdded:(OIMFriendInfoCallback)onFriendAdded
                          onFriendDeleted:(OIMFriendInfoCallback)onFriendDeleted;
@end

NS_ASSUME_NONNULL_END
