//
//  GroupApplicationInfo.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupApplicationInfo : BaseModal

/**
 *
 */
@property(nullable) NSString *id;
/**
 * 群组ID
 */
@property(nullable) NSString *groupID;
/**
 * 申请用户的ID
 */
@property(nullable) NSString *fromUserID;
/**
 * 接收用户的ID
 */
@property(nullable) NSString *toUserID;
/**
 * 0：未处理，1：拒绝，2：同意
 */
@property int flag; //INIT = 0, REFUSE = -1, AGREE = 1
/**
 * 原因
 */
@property(nullable) NSString *reqMsg;
/**
 * 处理反馈
 */
@property(nullable) NSString *handledMsg;
/**
 * 时间
 */
@property int createTime;
/**
 * 申请用户的昵称
 */
@property(nullable) NSString *fromUserNickName;
/**
 * 接收用户的昵称
 */
@property(nullable) NSString *toUserNickName;
/**
 * 申请用户的头像
 */
@property(nullable) NSString *fromUserFaceURL;
/**
 * 接收用户的昵称
 */
@property(nullable) NSString *toUserFaceURL;
/**
 * 处理人
 */
@property(nullable) NSString *handledUser;
/**
 * 0：申请进群, 1：邀请进群
 */
@property int type; //APPLICATION = 0, INVITE = 1
/**
 * 0：未处理, 1：被其他人处理, 2：被自己处理
 */
@property int handleStatus; //UNHANDLED = 0, BY_OTHER = 1, BY_SELF = 2
/**
 * 0：拒绝，1：同意
 */
@property int handleResult; //REFUSE = 0, AGREE = 1

@end

NS_ASSUME_NONNULL_END
