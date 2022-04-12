//
//  OIMGroupInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMGroupBaseInfo : NSObject

@property (nonatomic, nullable, copy) NSString *groupName;
@property (nonatomic, nullable, copy) NSString *notification;
@property (nonatomic, nullable, copy) NSString *introduction;
@property (nonatomic, nullable, copy) NSString *faceURL;
@property (nonatomic, nullable, copy) NSString *ex;

@end

@interface OIMGroupCreateInfo : OIMGroupBaseInfo

@property (nonatomic, assign) NSInteger groupType;

@end

/// 群组信息
///
@interface OIMGroupInfo : OIMGroupCreateInfo

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *ownerUserID;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger memberCount;
/// ok = 0 blocked = 1 Dismissed = 2 Muted  = 3
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, nullable, copy) NSString *creatorUserID;

@end

NS_ASSUME_NONNULL_END
