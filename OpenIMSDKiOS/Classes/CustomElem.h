//
//  CustomElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomElem : BaseModal

@property(nullable) NSString *data;
@property(nullable) NSString *extension;
@property(nullable) NSString *description;

@end

NS_ASSUME_NONNULL_END
