//
//  OIMDepartmentInfo.m
//  OpenIMSDK
//
//  Created by x on 2022/5/13.
//

#import "OIMDepartmentInfo.h"
#import <MJExtension/MJExtension.h>

@implementation OIMDepartmentMemberInfo

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"parentDepartmentList" : [OIMDepartmentInfo class]};
};

@end


@implementation OIMDepartmentInfo

@end

@implementation OIMUserInDepartmentInfo


@end

@implementation OIMDepartmentMemberAndSubInfo


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"departmentList" : [OIMDepartmentInfo class],
             @"departmentMemberList": [OIMDepartmentMemberInfo class]
    };
}

@end


