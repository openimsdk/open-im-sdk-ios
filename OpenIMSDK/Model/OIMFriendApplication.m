//
//  OIMFriendApplication.m
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMFriendApplication.h"

@implementation OIMFriendApplication

@end

@implementation DeleteFriendRequest

- (instancetype)initWithFromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID {
    self = [super init];
    if (self) {
        _fromUserID = fromUserID;
        _toUserID = toUserID;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    NSString *fromUserID = json[@"fromUserID"];
    NSString *toUserID = json[@"toUserID"];
    return [self initWithFromUserID:fromUserID toUserID:toUserID];
}

- (NSDictionary *)toJson {
    return @{
        @"fromUserID": self.fromUserID ?: @"",
        @"toUserID": self.toUserID ?: @""
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DeleteFriendRequest{fromUserID: %@, toUserID: %@}", self.fromUserID, self.toUserID];
}

@end

@implementation GetFriendApplicationListAsApplicantReq

- (instancetype)initWithOffset:(NSInteger)offset count:(NSInteger)count {
    self = [super init];
    if (self) {
        _offset = offset;
        _count = count;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    NSInteger offset = [json[@"offset"] integerValue];
    NSInteger count = [json[@"count"] integerValue];
    return [self initWithOffset:offset count:count];
}

- (NSDictionary *)toJson {
    return @{
        @"offset": @(self.offset),
        @"count": @(self.count)
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GetFriendApplicationListAsApplicantReq{offset: %ld, count: %ld}", (long)self.offset, (long)self.count];
}

@end

@implementation GetFriendApplicationUnhandledCountReq

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
    return @{
        @"time": @(self.time)
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GetSelfUnhandledApplyCountReq{time: %ld}", (long)self.time];
}

@end

@implementation GetFriendApplicationListAsRecipientReq

- (instancetype)initWithHandleResults:(NSArray<NSNumber *> *)handleResults
                               offset:(NSInteger)offset
                                count:(NSInteger)count {
    self = [super init];
    if (self) {
        _handleResults = handleResults ?: @[];
        _offset = offset;
        _count = count;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    NSArray *resultsArray = json[@"handleResults"];
    NSMutableArray<NSNumber *> *parsedResults = [NSMutableArray array];

    if ([resultsArray isKindOfClass:[NSArray class]]) {
        for (id item in resultsArray) {
            if ([item respondsToSelector:@selector(integerValue)]) {
                [parsedResults addObject:@([item integerValue])];
            }
        }
    }

    NSInteger offset = [json[@"offset"] integerValue];
    NSInteger count = [json[@"count"] integerValue];

    return [self initWithHandleResults:parsedResults offset:offset count:count];
}

- (NSDictionary *)toJson {
    return @{
        @"handleResults": self.handleResults ?: @[],
        @"offset": @(self.offset),
        @"count": @(self.count)
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GetFriendApplicationListAsRecipientReq{handleResults: %@, offset: %ld, count: %ld}",
            self.handleResults,
            (long)self.offset,
            (long)self.count];
}

@end
