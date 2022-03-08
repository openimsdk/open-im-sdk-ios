//
//  OIMLocationElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import "OIMLocationElem.h"

@implementation OIMLocationElem
@synthesize description;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc" : @"description"};
}
@end
