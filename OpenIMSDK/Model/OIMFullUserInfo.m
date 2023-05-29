//
//  OIMFullUserInfo.m
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMFullUserInfo.h"

@implementation OIMPublicUserInfo

@end

@implementation OIMBlackInfo

@end

@implementation OIMFriendInfo

@end

@implementation OIMSearchFriendsInfo

@end

@implementation OIMFullUserInfo

- (NSString *)userID {
    NSString *userID = self.publicInfo.userID;
    
    if (userID.length == 0) {
        userID = self.friendInfo.userID;
    }
    
    if (userID.length == 0) {
        userID = self.blackInfo.userID;
    }
    
    return userID;
}

- (NSString *)showName {
    NSString *name = nil;
    
    if (self.friendInfo != nil) {
        name = self.friendInfo.nickname.length > 0 ? self.friendInfo.nickname : self.friendInfo.userID;
    } else if (self.blackInfo != nil) {
        name = self.blackInfo.nickname.length > 0 ? self.blackInfo.nickname : self.blackInfo.userID;
    } else if (self.publicInfo != nil) {
        name = self.publicInfo.nickname.length > 0 ? self.publicInfo.nickname : self.publicInfo.userID;
    }
    
    return name;
}

- (NSString *)faceURL {
    NSString *url = self.publicInfo.faceURL;
    
    if (url.length == 0) {
        url = self.friendInfo.faceURL;
    }
    
    if (url.length == 0) {
        url = self.blackInfo.faceURL;
    }
    
    return url;
}

- (OIMGender)gender {
    OIMGender gender = OIMGenderMale;
    
    if (self.friendInfo != nil) {
        gender = self.friendInfo.gender;
    } else if (self.blackInfo != nil) {
        gender = self.blackInfo.gender;
    } else if (self.publicInfo != nil) {
        gender = self.publicInfo.gender;
    }
    
    return gender;
}

@end
