//
//  GroupInfo.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupInfo : BaseModal

/**
 * 组ID
 */
@property(nullable) NSString *groupID;
/**
 * 群名
 */
@property(nullable) NSString *groupName;
/**
 * 群公告
 */
@property(nullable) NSString *notification;
/**
 * 群简介
 */
@property(nullable) NSString *introduction;
/**
 * 群头像
 */
@property(nullable) NSString *faceUrl;
/**
 * 群主id
 */
@property(nullable) NSString *ownerId;
/**
 * 创建时间
 */
@property long createTime;
/**
 * 群成员数量
 */
@property int memberCount;

@end

NS_ASSUME_NONNULL_END
