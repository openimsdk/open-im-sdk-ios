//
//  OIMAttachedInfoElem.m
//  OpenIMSDK
//
//  Created by x on 2022/3/18.
//

#import "OIMAttachedInfoElem.h"
#import <MJExtension/MJExtension.h>

@implementation OIMGroupHasReadInfo

@end

@implementation OIMUploadProgress

@end

@implementation OIMAttachedInfoElem

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"messageEntityList" : [OIMMessageEntity class]};
}

@end
