//
//  OIMMessageInfo.m
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMMessageInfo.h"

@implementation OIMMessageInfo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.offlinePushInfo = [OIMOfflinePushInfo new];
        self.status = OIMMessageStatusUndefine;
    }
    
    return self;
}

- (NSTimeInterval)hasReadTime {
    if (_hasReadTime == 0) {
        _hasReadTime = _attachedInfoElem.hasReadTime;
    }
    
    return _hasReadTime;
}

@end
