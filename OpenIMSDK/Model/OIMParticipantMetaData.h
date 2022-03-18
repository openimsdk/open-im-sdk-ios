//
//  OIMParticipantMetaData.h
//  OpenIMSDK
//
//  Created by x on 2022/3/17.
//

#import <Foundation/Foundation.h>
#import "OIMGroupInfo.h"
#import "OIMGroupMemberInfo.h"
#import "OIMFullUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// 参与者信息
@interface OIMParticipantMetaData : NSObject

@property (nonatomic, strong) OIMGroupInfo *groupInfo;

@property (nonatomic, strong) OIMGroupMemberInfo *groupMemberInfo;

@property (nonatomic, strong) OIMPublicUserInfo *publicUserInfo;

@end

NS_ASSUME_NONNULL_END
