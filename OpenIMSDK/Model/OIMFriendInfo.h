//
//  OIMFriendInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

///好友相关信息，比较全，所有信息都包括
///
@interface OIMFriendInfo : NSObject

@property(nonatomic, nullable, copy) NSString *ownerUserID;

@property(nonatomic, nullable, copy) NSString *friendUserID;

@property(nonatomic, nullable, copy) NSString *remark;

@property(nonatomic, assign) NSInteger createTime;

@property(nonatomic, assign) NSInteger addSource;

@property(nonatomic, nullable, copy) NSString *operatorUserID;

@property(nonatomic, nullable, copy) NSString *nickname;

@property(nonatomic, nullable, copy) NSString *faceURL;

@property(nonatomic, assign) OIMGender gender;

@property(nonatomic, nullable, copy) NSString *phoneNumber;

@property(nonatomic, assign) NSInteger birth;

@property(nonatomic, nullable, copy) NSString *email;

@property(nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
