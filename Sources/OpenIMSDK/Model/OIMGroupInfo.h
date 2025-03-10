//
//  OIMGroupInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMGroupBaseInfo : NSObject

@property (nonatomic, assign) OIMGroupType groupType;
@property (nonatomic, nullable, copy) NSString *groupName;
@property (nonatomic, nullable, copy) NSString *notification;
@property (nonatomic, nullable, copy) NSString *introduction;
@property (nonatomic, nullable, copy) NSString *faceURL;
@property (nonatomic, nullable, copy) NSString *ex;

@end

@interface OIMGroupCreateInfo : NSObject

@property (nonatomic, strong) OIMGroupBaseInfo *groupInfo;
@property (nonatomic, copy) NSArray <NSString *> *memberUserIDs;
@property (nonatomic, copy) NSArray <NSString *> *adminUserIDs;
@property (nonatomic, copy) NSString *ownerUserID;

@end

/// Group Information
///
@interface OIMGroupInfo : OIMGroupBaseInfo

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, assign, readonly) NSInteger createTime;
@property (nonatomic, assign, readonly) NSInteger memberCount;
@property (nonatomic, assign, readonly) OIMGroupStatus status;
@property (nonatomic, copy, readonly) NSString *creatorUserID;
@property (nonatomic, copy, readonly) NSString *ownerUserID;
@property (nonatomic, assign) OIMGroupVerificationType needVerification;
@property (nonatomic, assign) OIMAllowType lookMemberInfo;
@property (nonatomic, assign) OIMAllowType applyMemberFriend;
@property (nonatomic, assign) NSInteger notificationUpdateTime;
@property (nonatomic, nullable, copy) NSString *notificationUserID;

@end

NS_ASSUME_NONNULL_END
