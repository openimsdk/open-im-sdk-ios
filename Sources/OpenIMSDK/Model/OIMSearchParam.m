//
//  OIMSearchParam.m
//  OpenIMSDK
//
//  Created by x on 2022/2/17.
//

#import "OIMSearchParam.h"
#import <MJExtension/MJExtension.h>
#import "OIMMessageInfo.h"

@implementation OIMSearchParam

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _senderUserIDList = @[];
        _messageTypeList = @[];
    }
    
    return self;
}

@end


@implementation OIMSearchGroupParam

@end

@implementation OIMGetMessageOptions

@end

@implementation OIMGetAdvancedHistoryMessageListParam

@end

@implementation OIMSearchFriendsParam

@end

@implementation OIMFindMessageListParam

@end

@implementation OIMSearchGroupMembersParam

@end
