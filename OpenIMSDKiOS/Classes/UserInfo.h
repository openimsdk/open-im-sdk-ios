//
//  UserInfo.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/4.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : BaseModal

/**
     * 用户id
     */
@property(nullable) NSString *uid;
    /**
     * 用户名
     */
@property(nullable) NSString *name;
    /**
     * 用户头像
     */
@property(nullable) NSString *icon;
    /**
     * 性别：1男，2女
     */
@property int gender;
    /**
     * 手机号
     */
@property(nullable) NSString *mobile;
    /**
     * 生日
     */
@property(nullable) NSString *birth;
    /**
     * 邮箱
     */
@property(nullable) NSString *email;
    /**
     * 扩展字段
     */
@property(nullable) NSString *ex;
    /**
     * 备注
     */
@property(nullable) NSString *comment;
    /**
     * 黑名单：1已拉入黑名单
     */
@property int isInBlackList;
    /**
     * 验证消息
     */
@property(nullable) NSString *reqMessage;
    /**
     * 申请时间
     */
@property(nullable) NSString *applyTime;
    /**
     * 好友申请列表：0等待处理；1已同意；2已拒绝<br />
     * 好友关系：1已经是好友
     */
@property int flag;

@end

NS_ASSUME_NONNULL_END
