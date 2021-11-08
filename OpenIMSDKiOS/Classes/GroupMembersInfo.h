//
//  GroupMembersInfo.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupMembersInfo : BaseModal

/**
     * 群id
     */
@property(nullable) NSString *groupID;
    /**
     * 用户id
     */
@property(nullable) NSString *userId;
    /**
     * 群角色
     */
@property int role;
    /**
     * 入群时间
     */
@property int joinTime;
    /**
     * 群内昵称
     */
@property(nullable) NSString *nickName;
    /**
     * 头像
     */
@property(nullable) NSString *faceUrl;
@property(nullable) id ext;

@end

NS_ASSUME_NONNULL_END
