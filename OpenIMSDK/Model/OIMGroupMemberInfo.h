//
//  OIMGroupMemberInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// Group Member Information
///
@interface OIMGroupMemberBaseInfo : NSObject

@property (nonatomic, nullable, copy) NSString *userID;

@property (nonatomic, assign) OIMGroupMemberRole roleLevel;

@end

/// Group Member Information
///
@interface OIMGroupMemberInfo : OIMGroupMemberBaseInfo

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *nickname;
@property (nonatomic, nullable, copy) NSString *faceURL;
/**
 *  Join time
 */
@property (nonatomic, assign) NSInteger joinTime;
/**
 *  Method of joining
 */
@property (nonatomic, assign) OIMJoinType joinSource;
/**
 *  Operator's ID
 */
@property (nonatomic, nullable, copy) NSString *operatorUserID;
/**
 *  Mute end timestamp (in seconds)
 */
@property (nonatomic, assign) NSTimeInterval muteEndTime;

@property (nonatomic, copy) NSString *inviterUserID;

@property (nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
