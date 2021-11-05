//
//  LocationElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationElem : BaseModal

@property(nullable) NSString *description;
@property double longitude;
@property double latitude;

@end

NS_ASSUME_NONNULL_END
