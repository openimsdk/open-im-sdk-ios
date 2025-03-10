//
//  OIMManager.h
//  OpenIMSDK
//
//  Created by x on 2022/2/15.
//

#import <Foundation/Foundation.h>
#import "OIMCallbacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager : NSObject

+ (instancetype)manager;

/**
 * All listeners setup here (User, Friend, Group, Conversation, AdvancedMsg, etc.)
 */
@property (nonatomic, strong, class, readonly) OIMManager *manager;
@property (nonatomic, strong, class, readonly) OIMCallbacker *callbacker;
@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *objectStorage;
/**
 * SDK version number
 */
+ (NSString *)sdkSdkVersion;

/**
 * Get the login user's UID
 */
- (NSString *)getLoginUserID;

- (NSString *)operationId;
@end

NS_ASSUME_NONNULL_END
