//
//  OIMPublicUserInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 用户公开信息，主要是基本信息，不包括手机等其它隐私字段
///
@interface OIMPublicUserInfo : NSObject

@property(nonatomic, nullable, copy) NSString *userID;
@property(nonatomic, nullable, copy) NSString *nickname;
@property(nonatomic, nullable, copy) NSString *faceURL;
@property(nonatomic, assign) OIMGender gender;

@end

NS_ASSUME_NONNULL_END
