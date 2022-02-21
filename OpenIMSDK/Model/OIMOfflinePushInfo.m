//
//  OIMOfflinePushInfo.m
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMOfflinePushInfo.h"

@implementation OIMOfflinePushInfo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.title = @"";
        self.desc = @"";
        self.ex = @"";
        self.iOSPushSound = @"";
        self.iOSBadgeCount = YES;
    }
    
    return self;
}

@end
