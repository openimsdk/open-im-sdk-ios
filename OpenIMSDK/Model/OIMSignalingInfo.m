//
//  OIMSignalingInfo.m
//  OpenIMSDK
//
//  Created by x on 2022/3/17.
//

#import "OIMSignalingInfo.h"
#import <MJExtension/MJExtension.h>

@implementation OIMInvitationInfo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _timeout = 30;
        _platformID = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? iPad : iPhone;
        _groupID = @"";
    }
    
    return self;
}

- (BOOL)isVideo {
    return [self.mediaType isEqualToString:@"video"];
}
@end

@implementation OIMInvitationResultInfo

@end

@implementation OIMSignalingInfo

@end

@implementation OIMParticipantMetaData

@end

@implementation OIMParticipantConnectedInfo

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"metaData" : [OIMParticipantMetaData class],
             @"participant" : [OIMParticipantMetaData class]
    };
}
@end

@implementation OIMMeetingInfo

@end

@implementation OIMMeetingInfoList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"meetingInfoList" : [OIMMeetingInfo class],
    };
}
@end

@implementation OIMMeetingStreamEvent

@end
