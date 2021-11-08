//
//  GroupMemberRole.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupMemberRole : BaseModal

@property(nullable) NSString *uid;
@property int setRole;

@end

NS_ASSUME_NONNULL_END
