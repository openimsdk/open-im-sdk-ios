//
//  OIMAttachedInfoElem.h
//  OpenIMSDK
//
//  Created by x on 2022/3/18.
//

#import <Foundation/Foundation.h>
#import "OIMMessageElem.h"

NS_ASSUME_NONNULL_BEGIN

/// 已读用户
///
@interface OIMGroupHasReadInfo : NSObject

@property (nonatomic, nullable, copy) NSArray <NSString *> *hasReadUserIDList;

@property (nonatomic, assign) NSInteger hasReadCount;

@property (nonatomic, assign) NSInteger groupMemberCount;

@end

@interface OIMAttachedInfoElem : NSObject

@property (nonatomic, nullable, strong) OIMGroupHasReadInfo *groupHasReadInfo;

@property (nonatomic, assign) BOOL isPrivateChat;

@property (nonatomic, assign) NSTimeInterval hasReadTime;

@property (nonatomic, assign) BOOL notSenderNotificationPush;

@property (nonatomic, strong) NSArray <OIMMessageEntity *> *messageEntityList;
@end

NS_ASSUME_NONNULL_END
