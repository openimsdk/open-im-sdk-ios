//
//  BaseModal.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModal : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary *)dict;
- (NSString *) className;
- (void)objectFromDictionary:(NSDictionary*) dict;

@end

NS_ASSUME_NONNULL_END
