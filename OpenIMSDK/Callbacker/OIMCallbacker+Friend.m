//
//  OIMCallbacker+Friend.m
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMCallbacker+Friend.h"

@implementation OIMCallbacker (Friend)

- (void)setFriendListenerWithOnBlackAdded:(OIMBlackInfoCallback)onBlackAdded
                           onBlackDeleted:(OIMBlackInfoCallback)onBlackDeleted
              onFriendApplicationAccepted:(OIMFriendApplicationCallback)onFriendApplicationAccepted
                 onFriendApplicationAdded:(OIMFriendApplicationCallback)onFriendApplicationAdded
               onFriendApplicationDeleted:(OIMFriendApplicationCallback)onFriendApplicationDeleted
              onFriendApplicationRejected:(OIMFriendApplicationCallback)onFriendApplicationRejected
                      onFriendInfoChanged:(OIMFriendInfoCallback)onFriendInfoChanged
                            onFriendAdded:(OIMFriendInfoCallback)onFriendAdded
                          onFriendDeleted:(OIMFriendInfoCallback)onFriendDeleted {
    self.onBlackAdded = onBlackAdded;
    self.onBlackDeleted = onBlackDeleted;
    self.onFriendApplicationAccepted = onFriendApplicationAccepted;
    self.onFriendApplicationAdded = onFriendApplicationAdded;
    self.onFriendApplicationDeleted = onFriendApplicationDeleted;
    self.onFriendApplicationRejected = onFriendApplicationRejected;
    self.onFriendInfoChanged = onFriendInfoChanged;
    self.onFriendAdded = onFriendAdded;
    self.onFriendDeleted = onFriendDeleted;
}





@end
