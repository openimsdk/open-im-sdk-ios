//
//  OIMSearchResultInfo.m
//  OpenIMSDK
//
//  Created by x on 2022/2/17.
//

#import "OIMSearchResultInfo.h"
#import <MJExtension/MJExtension.h>
#import "OIMMessageInfo.h"

@implementation OIMSearchResultItemInfo

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"messageList" : [OIMMessageInfo class]};
}

@end

@implementation OIMSearchResultInfo

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"searchResultItems" : [OIMSearchResultItemInfo class],
             @"findResultItems" : [OIMSearchResultItemInfo class]
    };
}

@end

@implementation OIMGetAdvancedHistoryMessageListInfo

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"messageList" : [OIMMessageInfo class]};
}

@end
