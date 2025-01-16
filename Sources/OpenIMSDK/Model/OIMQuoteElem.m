//
//  OIMQuoteElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMQuoteElem.h"

@implementation OIMQuoteElem

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"messageEntityList" : [OIMMessageEntity class]};
}

@end
