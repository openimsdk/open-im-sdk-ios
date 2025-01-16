//
//  OIMFriendApplication.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

#import "OIMMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// Friend application information, indicating who is applying to add whom as a friend and the result of handling the application.
///
@interface OIMFriendApplication : NSObject

@property (nonatomic, nullable, copy) NSString *fromUserID;

@property (nonatomic, nullable, copy) NSString *fromNickname;

@property (nonatomic, nullable, copy) NSString *fromFaceURL;

@property (nonatomic, nullable, copy) NSString *toUserID;

@property (nonatomic, nullable, copy) NSString *toNickname;

@property (nonatomic, nullable, copy) NSString *toFaceURL;

@property (nonatomic, assign) OIMApplicationStatus handleResult;

@property (nonatomic, nullable, copy) NSString *reqMsg;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, nullable, copy) NSString *handlerUserID;

@property (nonatomic, nullable, copy) NSString *handleMsg;

@property (nonatomic, assign) NSInteger handleTime;

@property (nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
