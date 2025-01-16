//
//  OIMMergeElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMMessageElem.h"
@class OIMMessageInfo;

NS_ASSUME_NONNULL_BEGIN

@interface OIMMergeElem : NSObject

@property (nonatomic, nullable, copy) NSString *title;
@property (nonatomic, nullable, copy) NSArray<NSString *> *abstractList;
@property (nonatomic, nullable, copy) NSArray<OIMMessageInfo *> *multiMessage;
@property (nonatomic, nullable, copy) NSArray<OIMMessageEntity *> *messageEntityList;

@end

NS_ASSUME_NONNULL_END
