//
//  OIMGroupMemberInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 群成员信息
///
@interface OIMGroupMemberBaseInfo : NSObject

@property (nonatomic, nullable, copy) NSString *userID;
// 角色
@property (nonatomic, assign) OIMGroupMemberRole roleLevel;

@end

/// 群成员信息
/// 
@interface OIMGroupMemberInfo : OIMGroupMemberBaseInfo

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *nickname;
@property (nonatomic, nullable, copy) NSString *faceURL;
// 加入时间
@property (nonatomic, assign) NSInteger joinTime;
// 入群方式
@property (nonatomic, assign) OIMJoinType joinSource;
// 操作者id
@property (nonatomic, nullable, copy) NSString *operatorUserID;
// 被禁言结束时间戳s
@property (nonatomic, assign) NSTimeInterval muteEndTime;

@property (nonatomic, copy) NSString *inviterUserID;

@property (nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
