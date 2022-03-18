//
//  OIMSearchParam.m
//  OpenIMSDK
//
//  Created by x on 2022/2/17.
//

#import "OIMSearchParam.h"

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
