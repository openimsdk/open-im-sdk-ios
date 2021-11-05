//
//  GroupMembersList.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@class GroupMembersInfo;

NS_ASSUME_NONNULL_BEGIN

@interface GroupMembersList : BaseModal

@property int nextSeq;
@property(nullable) NSArray<GroupMembersInfo*> /*List<GroupMembersInfo>*/ *data;

@end

NS_ASSUME_NONNULL_END
