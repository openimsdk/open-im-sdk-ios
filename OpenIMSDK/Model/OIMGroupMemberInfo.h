//
//  OIMGroupMemberInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 群成员信息
///
@interface OIMGroupMemberBaseInfo : NSObject

@property (nonatomic, nullable, copy) NSString *userID;
@property (nonatomic, assign) OIMGroupMemberRole roleLevel;

@end

/// 群成员信息
/// 
@interface OIMGroupMemberInfo : OIMGroupMemberBaseInfo

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *nickname;
@property (nonatomic, nullable, copy) NSString *faceURL;
@property (nonatomic, assign) NSInteger joinTime;
@property (nonatomic, assign) NSInteger joinSource;
@property (nonatomic, nullable, copy) NSString *operatorUserID;
@property (nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
