//
//  OIMMergeElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMMergeElem.h"
#import <MJExtension/MJExtension.h>
#import "OIMMessageInfo.h"

@implementation OIMMergeElem

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"multiMessage" : [OIMMessageInfo class],
             @"messageEntityList" : [OIMMessageEntity class]};
}

@end
