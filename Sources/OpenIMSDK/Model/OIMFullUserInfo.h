//
//  OIMFullUserInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// Public user information, mainly basic information, excluding other privacy fields such as phone number.
///
@interface OIMPublicUserInfo : NSObject

@property (nonatomic, nullable, copy) NSString *userID;

@property (nonatomic, nullable, copy) NSString *nickname;

@property (nonatomic, nullable, copy) NSString *faceURL;

@property (nonatomic, nullable, copy) NSString *ex;

@end

/// Blacklist information, basic information of users in the blacklist. Note that the blacklist is a mutual relationship.
///
@interface OIMBlackInfo : OIMPublicUserInfo

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, assign) NSInteger addSource;

@property (nonatomic, nullable, copy) NSString *operatorUserID;

@property (nonatomic, nullable, copy) NSString *attachedInfo;

@end

/// Friend information, basic information of users who are friends. Note that the blacklist is a mutual relationship.
///
@interface OIMFriendInfo : OIMPublicUserInfo

@property (nonatomic, nullable, copy) NSString *ownerUserID;

@property (nonatomic, nullable, copy) NSString *remark;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, assign) NSInteger addSource;

@property (nonatomic, nullable, copy) NSString *operatorUserID;

@property (nonatomic, nullable, copy) NSString *attachedInfo;


@end

@interface OIMSearchFriendsInfo : OIMFriendInfo

@property (nonatomic, assign) OIMRelationship relationship;

@end

NS_ASSUME_NONNULL_END
