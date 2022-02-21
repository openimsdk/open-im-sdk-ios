//
//  OIMFullUserInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMPublicUserInfo.h"
#import "OIMFriendInfo.h"
#import "OIMBlackInfo.h"

NS_ASSUME_NONNULL_BEGIN

/*
 整合了PublicUserInfo， FriendInfo和BlackInfo
 getuserinfo时，
 如果是好友，publicInfo和friendInfo会设置，
 如果是黑名单，publicinfo和blackInfo会设置
 如果即时好友，也是黑名单，则publicInfo， friendInfo，blackInfo都会设置

 getfriend时
 如果是黑名单，则friendInfo和blackInfo会设置， 但publicInfo不设置

 getblack时，
 如果是好友，则blackInfo和friendInfo会设置，但publicInfo不设置
 */
@interface OIMFullUserInfo : NSObject

@property(nonatomic, nullable, strong) OIMPublicUserInfo *publicInfo;
@property(nonatomic, nullable, strong) OIMFriendInfo *friendInfo;
@property(nonatomic, nullable, strong) OIMBlackInfo *blackInfo;

@end

NS_ASSUME_NONNULL_END
