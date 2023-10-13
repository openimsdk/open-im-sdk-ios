//
//  OIMAttachedInfoElem.h
//  OpenIMSDK
//
//  Created by x on 2022/3/18.
//

#import <Foundation/Foundation.h>
#import "OIMMessageElem.h"

NS_ASSUME_NONNULL_BEGIN

/// Users who have read the message
///
@interface OIMGroupHasReadInfo : NSObject

@property (nonatomic, nullable, copy) NSArray <NSString *> *hasReadUserIDList;

@property (nonatomic, assign) NSInteger hasReadCount;

/**
 *  Number of group members at the time of sending this message
 */
@property (nonatomic, assign) NSInteger groupMemberCount;

@end

@interface OIMUploadProgress : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger save;

@property (nonatomic, assign) NSInteger current;
@end

@interface OIMAttachedInfoElem : NSObject

@property (nonatomic, nullable, strong) OIMGroupHasReadInfo *groupHasReadInfo;

@property (nonatomic, assign) BOOL isPrivateChat;

@property (nonatomic, assign) NSTimeInterval burnDuration;

@property (nonatomic, assign) NSTimeInterval hasReadTime;

@property (nonatomic, assign) BOOL notSenderNotificationPush;

@property (nonatomic, copy) NSArray <OIMMessageEntity *> *messageEntityList;

@property (nonatomic, assign) BOOL isEncryption;

@property (nonatomic, assign) BOOL inEncryptStatus;

@property (nonatomic, strong) OIMUploadProgress *uploadProgress;

@end

NS_ASSUME_NONNULL_END
