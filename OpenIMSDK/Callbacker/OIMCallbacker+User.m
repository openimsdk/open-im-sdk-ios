//
//  OIMCallbacker+User.m
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCallbacker+User.h"

@implementation OIMCallbacker (User)

- (void)setSelfUserInfoUpdateListener:(OIMUserInfoCallback)onUserInfoUpdate {
    self.onSelfInfoUpdated = onUserInfoUpdate;
}

@end
