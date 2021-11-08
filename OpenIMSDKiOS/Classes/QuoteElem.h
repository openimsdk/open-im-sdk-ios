//
//  QuoteElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@class Message;

NS_ASSUME_NONNULL_BEGIN

@interface QuoteElem : BaseModal

@property(nullable) NSString *text;
@property(nullable) Message *quoteMessage;

@end

NS_ASSUME_NONNULL_END
