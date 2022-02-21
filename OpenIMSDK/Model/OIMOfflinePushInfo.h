//
//  OIMOfflinePushInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMOfflinePushInfo : NSObject

@property(nonatomic, nullable, copy) NSString *title;
@property(nonatomic, nullable, copy) NSString *desc;
@property(nonatomic, nullable, copy) NSString *iOSPushSound;
@property(nonatomic, assign) BOOL iOSBadgeCount;
@property(nonatomic, nullable, copy) NSString *operatorUserID;
@property(nonatomic, nullable, copy) NSString *ex;

@end

NS_ASSUME_NONNULL_END
