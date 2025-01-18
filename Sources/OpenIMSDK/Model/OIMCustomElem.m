//
//  OIMCustomElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCustomElem.h"
#import <MJExtension/MJExtension.h>

@implementation OIMCustomElem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"description_" : @"description"};
}

@end
