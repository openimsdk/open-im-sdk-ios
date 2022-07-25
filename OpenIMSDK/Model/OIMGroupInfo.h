//
//  OIMGroupInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMGroupBaseInfo : NSObject

@property (nonatomic, nullable, copy) NSString *groupName;
@property (nonatomic, nullable, copy) NSString *notification;
@property (nonatomic, nullable, copy) NSString *introduction;
@property (nonatomic, nullable, copy) NSString *faceURL;
@property (nonatomic, nullable, copy) NSString *ex;

@end

@interface OIMGroupCreateInfo : OIMGroupBaseInfo

@property (nonatomic, assign) OIMGroupType groupType;

@end

/// 群组信息
///
@interface OIMGroupInfo : OIMGroupCreateInfo

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *ownerUserID;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger memberCount;
/// 群状态：0正常，1被封，2解散，3禁言
@property (nonatomic, assign) OIMGroupStatus status;
@property (nonatomic, copy) NSString *creatorUserID;
@property (nonatomic, assign) NSInteger needVerification;
@property (nonatomic, assign) NSInteger lookMemberInfo;
@property (nonatomic, assign) NSInteger applyMemberFriend;
@property (nonatomic, assign) NSInteger notificationUpdateTime;
@property (nonatomic, copy) NSString *notificationUserID;

@end

NS_ASSUME_NONNULL_END
