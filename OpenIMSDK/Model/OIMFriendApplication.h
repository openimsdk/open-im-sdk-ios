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

@interface DeleteFriendRequest : NSObject

@property (nonatomic, copy) NSString *fromUserID;
@property (nonatomic, copy) NSString *toUserID;

- (instancetype)initWithFromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID;
- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end

@interface GetFriendApplicationListAsApplicantReq : NSObject

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (instancetype)initWithOffset:(NSInteger)offset count:(NSInteger)count;
- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end

@interface GetFriendApplicationUnhandledCountReq : NSObject

@property (nonatomic, assign) NSInteger time;

- (instancetype)initWithTime:(NSInteger)time;
- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end

@interface GetFriendApplicationListAsRecipientReq : NSObject

@property (nonatomic, copy) NSArray<NSNumber *> *handleResults;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (instancetype)initWithHandleResults:(NSArray<NSNumber *> *)handleResults
                               offset:(NSInteger)offset
                                count:(NSInteger)count;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end


NS_ASSUME_NONNULL_END
