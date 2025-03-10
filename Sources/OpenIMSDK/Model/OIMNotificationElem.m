//
//  OIMNotificationElem.m
//  OpenIMSDK
//
//  Created by x on 2022/2/21.
//

#import "OIMNotificationElem.h"
#import <MJExtension/MJExtension.h>

@implementation OIMNotificationElem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"groupNewOwner" : @"newGroupOwner"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"kickedUserList" : [OIMGroupMemberInfo class],
             @"invitedUserList": [OIMGroupMemberInfo class]
    };

}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    
    if (detail.length > 0) {
        OIMNotificationElem *elem = [OIMNotificationElem mj_objectWithKeyValues:detail];
        _group = elem.group;
        _opUser = elem.opUser;
        _quitUser = elem.quitUser;
        _entrantUser = elem.entrantUser;
        _kickedUserList = elem.kickedUserList;
        _invitedUserList = elem.invitedUserList;
        _groupNewOwner = elem.groupNewOwner;
    }
}

@end
