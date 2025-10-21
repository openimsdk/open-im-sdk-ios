//
//  OIMGroupApplicationInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMGroupApplicationInfo.h"

@implementation OIMGroupApplicationInfo

@end

@implementation DeleteGroupRequest

- (instancetype)initWithGroupID:(NSString *)groupID fromUserID:(NSString *)fromUserID {
    self = [super init];
    if (self) {
        _groupID = groupID;
        _fromUserID = fromUserID;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    NSString *groupID = json[@"groupID"];
    NSString *fromUserID = json[@"fromUserID"];
    return [self initWithGroupID:groupID fromUserID:fromUserID];
}

- (NSDictionary *)toJson {
    return @{
        @"groupID": self.groupID ?: @"",
        @"fromUserID": self.fromUserID ?: @""
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DeleteGroupRequest{groupID: %@, fromUserID: %@}", self.groupID, self.fromUserID];
}

@end

@implementation GetGroupApplicationListAsRecipientReq

- (instancetype)initWithGroupIDs:(NSArray<NSString *> *)groupIDs
                   handleResults:(NSArray<NSNumber *> *)handleResults
                         offset:(NSInteger)offset
                          count:(NSInteger)count {
    self = [super init];
    if (self) {
        _groupIDs = groupIDs ?: @[];
        _handleResults = handleResults ?: @[];
        _offset = offset;
        _count = count;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    NSArray *groupIDsArray = json[@"groupIDs"];
    NSArray *handleResultsArray = json[@"handleResults"];
    
    NSMutableArray<NSString *> *groupIDs = [NSMutableArray array];
    if ([groupIDsArray isKindOfClass:[NSArray class]]) {
        for (id item in groupIDsArray) {
            if ([item isKindOfClass:[NSString class]]) {
                [groupIDs addObject:item];
            }
        }
    }
    
    NSMutableArray<NSNumber *> *handleResults = [NSMutableArray array];
    if ([handleResultsArray isKindOfClass:[NSArray class]]) {
        for (id item in handleResultsArray) {
            if ([item respondsToSelector:@selector(integerValue)]) {
                [handleResults addObject:@([item integerValue])];
            }
        }
    }
    
    NSInteger offset = [json[@"offset"] integerValue];
    NSInteger count = [json[@"count"] integerValue];
    
    return [self initWithGroupIDs:groupIDs handleResults:handleResults offset:offset count:count];
}

- (NSDictionary *)toJson {
    return @{
        @"groupIDs": self.groupIDs ?: @[],
        @"handleResults": self.handleResults ?: @[],
        @"offset": @(self.offset),
        @"count": @(self.count)
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GetGroupApplicationListAsRecipientReq{groupIDs: %@, handleResults: %@, offset: %ld, count: %ld}",
            self.groupIDs, self.handleResults, (long)self.offset, (long)self.count];
}

@end

@implementation GetGroupApplicationListAsApplicantReq

- (instancetype)initWithGroupIDs:(NSArray<NSString *> *)groupIDs
                   handleResults:(NSArray<NSNumber *> *)handleResults
                         offset:(NSInteger)offset
                          count:(NSInteger)count {
    self = [super init];
    if (self) {
        _groupIDs = groupIDs ?: @[];
        _handleResults = handleResults ?: @[];
        _offset = offset;
        _count = count;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    NSArray *groupIDsArray = json[@"groupIDs"];
    NSArray *handleResultsArray = json[@"handleResults"];
    
    NSMutableArray<NSString *> *groupIDs = [NSMutableArray array];
    if ([groupIDsArray isKindOfClass:[NSArray class]]) {
        for (id item in groupIDsArray) {
            if ([item isKindOfClass:[NSString class]]) {
                [groupIDs addObject:item];
            }
        }
    }
    
    NSMutableArray<NSNumber *> *handleResults = [NSMutableArray array];
    if ([handleResultsArray isKindOfClass:[NSArray class]]) {
        for (id item in handleResultsArray) {
            if ([item respondsToSelector:@selector(integerValue)]) {
                [handleResults addObject:@([item integerValue])];
            }
        }
    }
    
    NSInteger offset = [json[@"offset"] integerValue];
    NSInteger count = [json[@"count"] integerValue];
    
    return [self initWithGroupIDs:groupIDs handleResults:handleResults offset:offset count:count];
}

- (NSDictionary *)toJson {
    return @{
        @"groupIDs": self.groupIDs ?: @[],
        @"handleResults": self.handleResults ?: @[],
        @"offset": @(self.offset),
        @"count": @(self.count)
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GetGroupApplicationListAsApplicantReq{groupIDs: %@, handleResults: %@, offset: %ld, count: %ld}",
            self.groupIDs, self.handleResults, (long)self.offset, (long)self.count];
}

@end

@implementation GetGroupApplicationUnhandledCountReq

- (instancetype)initWithTime:(NSInteger)time {
    self = [super init];
    if (self) {
        _time = time;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    NSInteger time = [json[@"time"] integerValue];
    return [self initWithTime:time];
}

- (NSDictionary *)toJson {
    return @{@"time": @(self.time)};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GetGroupApplicationUnhandledCountReq{time: %ld}", (long)self.time];
}

@end
