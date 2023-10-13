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

/**
 *  The following fields are decoded from the 'detail' field
 */
@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *opUser;

@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *quitUser;

@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *entrantUser;
/**
 *  Information about the new group owner after a group change
 */
@property (nonatomic, nullable, strong, readonly) OIMGroupMemberInfo *groupNewOwner;

@property (nonatomic, nullable, strong, readonly) OIMGroupInfo *group;

@property (nonatomic, nullable, strong, readonly) NSArray <OIMGroupMemberInfo *> *kickedUserList;

@property (nonatomic, nullable, strong, readonly) NSArray <OIMGroupMemberInfo *> *invitedUserList;

@end

NS_ASSUME_NONNULL_END
