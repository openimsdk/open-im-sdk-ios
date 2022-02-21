//
//  OIMGroupInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMGroupInfo.h"

@implementation OIMGroupBaseInfo

-(instancetype)init {
    self = [super init];
    
    if (self) {
        self.groupName = @"";
        self.notification = @"";
        self.introduction = @"";
        self.faceURL = @"";
        self.ex = @"";
    }
    
    return self;
}

@end

@implementation OIMGroupCreateInfo



@end

@implementation OIMGroupInfo

@end
