//
//  OIMNotificationElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/21.
//

#import <Foundation/Foundation.h>
#import "OIMGroupMemberInfo.h"
#import "OIMGroupInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMNotificationElem : NSObject

@property (nonatomic, nullable, copy) NSString *detail;

/// 以下字段是从detail里面decode出来的
@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *opUser;

@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *quitUser;

@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *entrantUser;
/// 群改变新群主的信息
@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *groupNewOwner;

@property (nonatomic, nullable, strong, readonly) OIMGroupInfo *group;

@property (nonatomic, nullable, strong, readonly) NSArray <OIMGroupMemberInfo *> *kickedUserList;

@property (nonatomic, nullable, strong, readonly) NSArray <OIMGroupMemberInfo *> *invitedUserList;

@end

NS_ASSUME_NONNULL_END
