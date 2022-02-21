//
//  OIMQuoteElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

@class OIMMessageInfo;

NS_ASSUME_NONNULL_BEGIN

@interface OIMQuoteElem : NSObject

@property(nonatomic, nullable, copy) NSString *text;

@property(nonatomic, nullable, strong) OIMMessageInfo *quoteMessage;

@end

NS_ASSUME_NONNULL_END
