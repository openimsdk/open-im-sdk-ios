//
//  OIMFriendApplication.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// 好友申请信息，谁申请添加谁为好友，以及对申请的处理结果
///
@interface OIMFriendApplication : NSObject

@property (nonatomic, nullable, copy) NSString *fromUserID;

@property (nonatomic, nullable, copy) NSString *fromNickname;

@property (nonatomic, nullable, copy) NSString *fromFaceURL;

@property (nonatomic, assign) OIMGender fromGender;

@property (nonatomic, nullable, copy) NSString *toUserID;

@property (nonatomic, nullable, copy) NSString *toNickname;

@property (nonatomic, nullable, copy) NSString *toFaceURL;

@property (nonatomic, assign) OIMGender toGender;

@property (nonatomic, assign) OIMApplicationStatus handleResult;

@property (nonatomic, nullable, copy) NSString *reqMsg;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, nullable, copy) NSString *handlerUserID;

@property (nonatomic, nullable, copy) NSString *handleMsg;

@property (nonatomic, assign) NSInteger handleTime;

@property (nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
