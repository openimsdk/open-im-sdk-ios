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

/**
 Integrates PublicUserInfo, FriendInfo, and BlackInfo.
 When getting user information:
 - If it's a friend, publicInfo and friendInfo will be set.
 - If it's in the blacklist, publicInfo and blackInfo will be set.
 - If it's both a friend and in the blacklist, all three will be set.

 When getting friend information:
 - If it's in the blacklist, friendInfo and blackInfo will be set, but publicInfo is not set.
 */
@interface OIMFullUserInfo : NSObject

@property (nonatomic, nullable, strong) OIMPublicUserInfo *publicInfo;
@property (nonatomic, nullable, strong) OIMFriendInfo *friendInfo;
@property (nonatomic, nullable, strong) OIMBlackInfo *blackInfo;

@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *showName;
@property (nonatomic, copy, readonly) NSString *faceURL;
@end

NS_ASSUME_NONNULL_END
