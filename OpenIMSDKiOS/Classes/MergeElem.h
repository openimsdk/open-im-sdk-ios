//
//  MergeElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@class Message;

NS_ASSUME_NONNULL_BEGIN

@interface MergeElem : BaseModal

@property(nullable) NSString *title;
@property(nullable) NSArray<NSString*>/*List<String>*/ *abstractList;
@property(nullable) NSArray<Message*>/*List<Message>*/ *multiMessage;

@end

NS_ASSUME_NONNULL_END
