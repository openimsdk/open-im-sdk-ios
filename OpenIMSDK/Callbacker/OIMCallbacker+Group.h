//
//  OIMCallbacker+Group.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCallbacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMCallbacker (Group)

/*
 * 设置组监听器
 * 
 */
- (void)setGroupListenerWithOnGroupInfoChanged:(OIMGroupInfoCallback)onGroupInfoChanged
                            onJoinedGroupAdded:(OIMGroupInfoCallback)onJoinedGroupAdded
                          onJoinedGroupDeleted:(OIMGroupInfoCallback)onJoinedGroupDeleted
                            onGroupMemberAdded:(OIMGroupMemberInfoCallback)onGroupMemberAdded
                          onGroupMemberDeleted:(OIMGroupMemberInfoCallback)onGroupMemberDeleted
                      onGroupMemberInfoChanged:(OIMGroupMemberInfoCallback)onGroupMemberInfoChanged
                       onGroupApplicationAdded:(OIMGroupApplicationCallback)onGroupApplicationAdded
                     onGroupApplicationDeleted:(OIMGroupApplicationCallback)onGroupApplicationDeleted
                    onGroupApplicationAccepted:(OIMGroupApplicationCallback)onGroupApplicationAccepted
                    onGroupApplicationRejected:(OIMGroupApplicationCallback)onGroupApplicationRejected;
@end

NS_ASSUME_NONNULL_END
