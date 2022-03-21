//
//  OIMAttachedInfoElem.h
//  OpenIMSDK
//
//  Created by x on 2022/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 已读用户
///
@interface OIMGroupHasReadInfo : NSObject

@property (nonatomic, nullable, copy) NSArray <NSString *> *hasReadUserIDList;

@property (nonatomic, assign) NSInteger hasReadCount;

@end

@interface OIMAttachedInfoElem : NSObject

@property (nonatomic, nullable, strong) OIMGroupHasReadInfo *groupHasReadInfo;

@end

NS_ASSUME_NONNULL_END
