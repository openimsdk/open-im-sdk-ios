//
//  OIMUserInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// Personal information, including all details
///
@interface OIMUserInfo : NSObject

@property (nonatomic, nullable, copy) NSString *userID;
@property (nonatomic, nullable, copy) NSString *nickname;
@property (nonatomic, nullable, copy) NSString *faceURL;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, nullable, copy) NSString *ex;
@property (nonatomic, nullable, copy) NSString *attachedInfo;
@property (nonatomic, assign) OIMReceiveMessageOpt globalRecvMsgOpt;
@end

@interface OIMUserStatusInfo : NSObject

@property (nonatomic, nullable, copy) NSString *userID;
@property (nonatomic, nullable, copy) NSArray *platformIDs;
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
