//
//  OIMQuoteElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>
#import "OIMMessageElem.h"
@class OIMMessageInfo;

NS_ASSUME_NONNULL_BEGIN

@interface OIMQuoteElem : NSObject

@property (nonatomic, nullable, copy) NSString *text;

@property (nonatomic, nullable, strong) OIMMessageInfo *quoteMessage;

@property (nonatomic, nullable, copy) NSArray <OIMMessageEntity *> *messageEntityList;
@end

NS_ASSUME_NONNULL_END
