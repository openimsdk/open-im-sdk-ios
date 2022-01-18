//
//  GroupInviteResult.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupInviteResult : BaseModal

@property(nullable) NSString *uid;
@property int result; // 0成功 -1失败

@end

NS_ASSUME_NONNULL_END
