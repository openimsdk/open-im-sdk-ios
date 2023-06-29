//
//  OIMMessageElem.m
//  OpenIMSDK
//
//  Created by x on 2022/7/15.
//

#import "OIMMessageElem.h"
#import <MJExtension/MJExtension.h>

@implementation OIMMessageEntity

@end

@implementation OIMAdvancedTextElem

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"messageEntityList" : [OIMMessageEntity class]};
}

@end

@implementation OIMMessageElem

@end

@implementation OIMTextElem

@end

@implementation OIMCardElem

@end

@implementation OIMTypingElem

@end
