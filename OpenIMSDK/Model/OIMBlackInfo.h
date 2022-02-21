//
//  OIMBlackInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 黑名单信息，黑名单用户基本信息，注意黑名单是双向关系。
///
@interface OIMBlackInfo : NSObject

@property(nonatomic, nullable, copy) NSString *ownerUserID;

@property(nonatomic, nullable, copy) NSString *blockUserID;

@property(nonatomic, nullable, copy) NSString *nickname;

@property(nonatomic, nullable, copy) NSString *faceURL;

@property(nonatomic, assign) OIMGender gender;

@property(nonatomic, assign) NSInteger createTime;

@property(nonatomic, assign) NSInteger addSource;

@property(nonatomic, nullable, copy) NSString *operatorUserID;

@property(nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
