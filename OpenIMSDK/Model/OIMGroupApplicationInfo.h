//
//  OIMGroupApplicationInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// Group joining application information
///
@interface OIMGroupApplicationInfo : NSObject

@property (nonatomic, nullable, copy) NSString *groupID;
@property (nonatomic, nullable, copy) NSString *groupName;
@property (nonatomic, nullable, copy) NSString *notification;
@property (nonatomic, nullable, copy) NSString *introduction;
@property (nonatomic, nullable, copy) NSString *groupFaceURL;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, nullable, copy) NSString *creatorUserID;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, nullable, copy) NSString *ownerUserID;
@property (nonatomic, assign) NSInteger memberCount;
@property (nonatomic, nullable, copy) NSString *userID;
@property (nonatomic, nullable, copy) NSString *nickname;
@property (nonatomic, nullable, copy) NSString *userFaceURL;
@property (nonatomic, assign) OIMApplicationStatus handleResult;
@property (nonatomic, nullable, copy) NSString *reqMsg;
@property (nonatomic, nullable, copy) NSString *handledMsg;
@property (nonatomic, assign) NSInteger reqTime;
@property (nonatomic, nullable, copy) NSString *handleUserID;
@property (nonatomic, assign) NSInteger handledTime;
@property (nonatomic, nullable, copy) NSString *ex;
@property (nonatomic, nullable, copy) NSString *inviterUserID;
@property (nonatomic, assign) OIMJoinType joinSource;

@end

@interface DeleteGroupRequest : NSObject

@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *fromUserID;

- (instancetype)initWithGroupID:(NSString *)groupID fromUserID:(NSString *)fromUserID;
- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end

@interface GetGroupApplicationListAsRecipientReq : NSObject

@property (nonatomic, copy) NSArray<NSString *> *groupIDs;
@property (nonatomic, copy) NSArray<NSNumber *> *handleResults;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (instancetype)initWithGroupIDs:(NSArray<NSString *> *)groupIDs
                   handleResults:(NSArray<NSNumber *> *)handleResults
                         offset:(NSInteger)offset
                          count:(NSInteger)count;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end

@interface GetGroupApplicationListAsApplicantReq : NSObject

@property (nonatomic, copy) NSArray<NSString *> *groupIDs;
@property (nonatomic, copy) NSArray<NSNumber *> *handleResults;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (instancetype)initWithGroupIDs:(NSArray<NSString *> *)groupIDs
                   handleResults:(NSArray<NSNumber *> *)handleResults
                         offset:(NSInteger)offset
                          count:(NSInteger)count;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end

@interface GetGroupApplicationUnhandledCountReq : NSObject

@property (nonatomic, assign) NSInteger time;

- (instancetype)initWithTime:(NSInteger)time;
- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;
- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
